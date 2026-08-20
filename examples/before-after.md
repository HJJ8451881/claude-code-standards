# Before / after：同一句需求，有無規範的差別

這不是示意，是實跑的 A/B，每組跑三次，原始輸出全部保留在 [`raw/`](raw/)。

## 實驗設計

| | 指令 |
|---|---|
| before | `claude --safe-mode -p "<需求>"` |
| after | `claude --safe-mode --append-system-prompt "$(cat skills/python-standards.md)" -p "<需求>"` |

`--safe-mode` 停用所有個人化設定（CLAUDE.md、skills、hooks、plugins），確保 before 那側真的乾淨。兩組唯一的差別，就是有沒有把 `python-standards.md` 那 20 行規則餵進 system prompt。

需求原文：

> 寫一個讀 CSV、計算某個數值欄位平均值與標準差的函式。

重現方式見 [`reproduce.sh`](reproduce.sh)。環境指紋、模型 ID、token 用量、成本、session ID 全部記在 `raw/`。

```
date_utc:      2026-08-20T12:33:42Z
claude_cli:    2.1.237 (Claude Code)
model:         claude-sonnet-5
runs_per_arm:  3
```

## 結果（N=3）

| 面向 | before | after |
|---|:---:|:---:|
| 函式簽名有型別註解 | **0 / 3** | **3 / 3** |
| 用 `logging` | **0 / 3** | **3 / 3** |
| 有 try/except | 2 / 3 | **3 / 3** |
| 用 `print()` 輸出結果 | **3 / 3** | **0 / 3** |
| 有 docstring | 3 / 3 | 3 / 3 |
| 主動提供／詢問測試 | 0 / 3 | 2 / 3（見下方污染說明） |
| 主動推薦改用 pandas | 3 / 3 | 0 / 3 |

前四項在三次之間**完全沒有例外**，不是抽樣運氣。

### 典型的 before 輸出

```python
def csv_column_stats(file_path, column_name, encoding="utf-8"):
    """讀取 CSV，回傳指定數值欄位的 (平均值, 標準差)。"""
    values = []
    with open(file_path, newline="", encoding=encoding) as f:
        reader = csv.DictReader(f)
        for row in reader:
            raw = row[column_name]
            if raw == "" or raw is None:
                continue
            values.append(float(raw))

    if not values:
        raise ValueError(f"欄位 '{column_name}' 沒有可用的數值")

    mean = statistics.mean(values)
    stdev = statistics.stdev(values) if len(values) > 1 else 0.0
    return mean, stdev


if __name__ == "__main__":
    mean, stdev = csv_column_stats("data.csv", "price")
    print(f"平均值: {mean}, 標準差: {stdev}")
```

### 典型的 after 輸出

```python
logger = logging.getLogger(__name__)


def compute_column_stats(csv_path: str | Path, column: str) -> tuple[float, float]:
    """讀取 CSV，計算指定數值欄位的平均值與樣本標準差，回傳 (mean, stdev)。"""
    values: list[float] = []
    try:
        with open(csv_path, newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            for row in reader:
                raw = row.get(column)
                if raw is None or raw == "":
                    continue
                values.append(float(raw))
    except (OSError, csv.Error) as exc:
        logger.error("讀取 CSV 檔案 %s 失敗: %s", csv_path, exc)
        raise
    except ValueError as exc:
        logger.error("欄位 %r（於 %s）含非數值資料: %s", column, csv_path, exc)
        raise

    if not values:
        raise ValueError(f"欄位 {column!r} 中沒有可用的數值資料")

    mean = statistics.mean(values)
    stdev = statistics.stdev(values) if len(values) > 1 else 0.0
    return mean, stdev
```

三次 after 都是這個形狀：完整型別、`logging`、例外分流後 re-raise 不吞掉、無 `print`。

## 實驗污染（誠實揭露）

**這批 raw 資料有一個瑕疵。** 執行時沒有預先開放 Write 權限，六次執行的檔案寫入都被權限提示擋下。影響：

- 對 before 沒有實質影響——它三次都只是貼程式碼，本來就沒打算寫檔。
- 對 after 有影響。`after-1` 在被擋前成功寫出程式碼與**六個測試並實際跑過**；`after-3` 明確詢問「需要我一併補上單元測試嗎」；`after-2` 只貼程式碼。所以「規範會讓它主動寫測試」這條，**在 N=3 下只能算 1 次確證 + 1 次意圖，不算穩定結論**。

`reproduce.sh` 已改為兩組都加 `--tools ""`，讓雙方在同一個「只能回文字」的條件下比較，避免這個變因。`raw/` 保留的是原始那批（含此瑕疵），不事後重跑covering過去——資料就是這樣產生的。

## 我在這個實驗裡被打臉兩次

**第一次**：最初我沒有真的跑，憑印象寫了一份「無規範版沒有型別註解」的對照。

**第二次**：於是我真的跑了一次（N=1），那一次的輸出**剛好有完整型別註解**。我據此改寫，宣稱「無規範版其實不差、型別註解是完整的」。

**然後跑到 N=3**，三次全部沒有型別註解——N=1 那次才是離群值。

這件事本身比對照表更值得看：**N=1 兩個方向都會騙人。** 生成式模型的輸出有隨機性，跑一次就下結論，跟沒跑差不多。這也是為什麼這裡把三次的原始 JSON 都留著，而不是只貼一份漂亮的。

## 這證明了什麼、沒證明什麼

**證明了**：同一個模型的輸出品質，取決於能不能把工程標準轉譯成**可逐條檢查的規則**。「型別要完整」「外部呼叫要包 try/except 並 log」「不要用 print」這種規則會 3/3 生效；「請寫好一點」不會。

**也證明了**：before 那側並不是垃圾。它有 docstring、有空值處理、會主動說明樣本標準差與母體標準差的差別、還會推薦 pandas。它缺的是**你沒開口要就不會有的東西**——型別、log、例外處理、測試。規範真正省下的不是「把爛程式碼變好」，而是省下你每次都要記得去要，以及在你沒想到要要的那些次接住它。

**沒有證明**：這是刻意挑的小任務，好讓差異在一頁內看得完。跨檔案的架構一致性、全域變數蔓延、例外處理風格不統一累積出來的除錯成本——那些才是規範價值最高的地方，但沒辦法濃縮成一張表。另外 N=3 仍然很小，上表中 2/3 或 1/3 的項目都應該當作「觀察到」而非「證實」。

## 原始資料

`raw/` 下每個 `.json` 是 `claude --output-format json` 的完整回傳，含：

- `session_id` — 可回溯到該次對話
- `modelUsage` — 模型 ID 與 token 數（本批：`claude-sonnet-5`）
- `total_cost_usd`、`duration_ms` — 可對照 API 用量帳單

六次執行合計 $0.445 USD、115 秒。
