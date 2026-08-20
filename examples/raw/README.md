# 原始實驗資料

[`../before-after.md`](../before-after.md) 那份 A/B 的未經編輯輸出。由 [`../reproduce.sh`](../reproduce.sh) 產生。

| 檔案 | 內容 |
|---|---|
| `environment.txt` | 執行時間（UTC）、Claude Code CLI 版本、OS、每組執行次數、需求原文 |
| `before-{1,2,3}.json` | 未載入規範的三次執行 |
| `after-{1,2,3}.json` | 載入 `skills/python-standards.md` 的三次執行 |

每個 `.json` 是 `claude --output-format json` 的完整回傳。可查證的欄位：

- `session_id` / `uuid` — 該次對話的識別碼
- `modelUsage` — 模型 ID 與各自的 token 數（本批主模型為 `claude-sonnet-5`）
- `total_cost_usd`、`duration_ms`、`num_turns` — 可對照 API 用量帳單
- `result` — 模型回覆的完整文字

快速檢視：

```bash
jq -r '.session_id, .total_cost_usd, (.modelUsage | keys[])' before-1.json
jq -r '.result' after-1.json
```

## 注意

這批資料是在**沒有預先開放 Write 權限**的情況下跑的，六次執行的檔案寫入都被權限提示擋下。這對 before 沒有影響（它本來就只貼程式碼），但污染了 after 那組「會不會主動寫測試並執行」的觀察——`before-after.md` 裡有完整說明。

`reproduce.sh` 已加上 `--tools ""` 修正這個變因。這裡刻意保留原始那批未重跑，因為資料就是這樣產生的。
