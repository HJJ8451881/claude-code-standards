# before/after A/B 實驗：從編造到 N=3

日期：2026-08-20

## 為什麼

`examples/before-after.md` 是這個 repo 說服力最強的一塊——它把抽象的「我能管控 AI 產出品質」變成看得見的差異。但初版是**憑印象編的**，沒有實際執行過，這在一份要拿給人看的文件裡是不能接受的。

本次目的是把它換成真實可查證的實驗資料，並讓任何人都能重現。

## 做了什麼

### 實驗設計

用 `claude --safe-mode` 建立乾淨對照組——這個旗標會停用 CLAUDE.md、skills、hooks、plugins，但 auth 與模型選擇正常，是目前唯一能在同一台機器上做出「無個人化設定」對照的方法。

```
before: claude --safe-mode -p "<需求>"
after:  claude --safe-mode --append-system-prompt "$(cat skills/python-standards.md)" -p "<需求>"
```

兩組唯一變因就是那 20 行規則。

### 產出

- `examples/reproduce.sh` — 一鍵重現，每組預設跑三次。會先寫出環境指紋（UTC 時間、CLI 版本、OS、需求原文）到 `raw/environment.txt`。
- `examples/raw/*.json` — 六次執行的完整 `--output-format json` 回傳，未經編輯。含 `session_id`、`modelUsage`（模型 ID 與 token 數）、`total_cost_usd`、`duration_ms`。
- `examples/raw/README.md` — 說明每個欄位的意義與已知瑕疵。
- `examples/before-after.md` — 依實測重寫。

### 兩次被資料推翻的判斷

這是本次最值得記的部分：

1. **初版憑印象寫**「無規範版沒有型別註解」。無證據。
2. **實跑 N=1**，那一次的輸出**剛好有完整型別註解**。據此改寫成「無規範版其實不差」，並在文件裡強調這個反直覺結論。
3. **跑到 N=3**，三次**全部沒有**型別註解——步驟 2 那次是離群值。

結果是：初版憑印象寫的反而比較接近典型輸出，但當時沒有證據支持，改掉仍然正確；**錯在用 N=1 就下反向結論**。

這段經過已寫進 `before-after.md`（「我在這個實驗裡被打臉兩次」一節），當作 N=1 不可信的實例保留，而不是把過程掃掉只留漂亮結論。

## 驗證

- **已驗證**：六次執行皆 `is_error: false`，主模型 `claude-sonnet-5`，合計 $0.4454 USD / 115 秒。原始 JSON 全數保留。
- **已驗證（N=3，三次無例外）**：型別註解 before 0/3 vs after 3/3；`logging` 0/3 vs 3/3；`print()` 輸出結果 3/3 vs 0/3。
- **已驗證**：先前手動跑的那組 after 輸出所附的六個測試，由 transcript 重建後以 pytest 重跑確認 → 6 passed，非採信模型自述的「6 passed」（該 session 寫在暫存區的檔案事後被沙箱回收）。
- **實驗瑕疵（已揭露，未修正）**：這批 raw 資料執行時未預先開放 Write 權限，六次寫檔都被權限提示擋下。對 before 無實質影響（三次都只貼程式碼）；但污染了 after 的「會不會主動寫測試」觀察——只剩 1 次確證 + 1 次意圖詢問，**不算穩定結論**。`reproduce.sh` 已加 `--tools ""` 讓兩組條件對等，但 `raw/` 那批**刻意不重跑**，瑕疵照實記在 `raw/README.md` 與 `before-after.md`。
- **未驗證**：N=3 仍然是很小的樣本。表中 2/3 或 1/3 的項目應視為「觀察到」而非「證實」。要讓 try/except 與測試那兩列站得住，需要 N=10 以上。
- **未驗證**：只測了一個任務（讀 CSV 做統計）。規範在跨檔案、長專案情境下的效果沒有量測，文件裡已聲明這是這份對照表的邊界。

## 待辦 / 已放棄

- **待辦**：提高 N 到 10 以上，讓 try/except 與「主動寫測試」兩列有結論。成本約 $1.5。
- **待辦**：尚未 commit。若要保留時間戳證據，`raw/` 與 `reproduce.sh` 應先單獨 commit，分析文件再第二次 commit。
- **已放棄**：不重跑 `raw/` 那批來消除權限污染。理由：事後重跑再宣稱是原始資料，正好違背這份文件想證明的東西；揭露瑕疵比消滅瑕疵誠實。
- **已放棄**：不收錄與公司內部系統耦合過深的 skill。去識別化後只剩空殼，沒有展示價值。
