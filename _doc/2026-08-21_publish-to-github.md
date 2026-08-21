# 發布到 GitHub：改名、帳號歸戶與一次歷史覆寫

日期：2026-08-21

## 為什麼

repo 內容已完成，要推上 GitHub 作為公開作品集。過程中換過一次目錄名、換過一次 GitHub 帳號，兩者都在 push 之後才發現要修，留下記錄避免下次重踩。

## 做了什麼

### 改名

`claude-code-setup` → `claude-code-standards`。理由：`setup` 讀起來像安裝說明，`standards` 才對得上這個 repo 真正在賣的東西——方法論而非設定檔。面試官掃 repo 清單時，前者容易被跳過。

連帶更新 repo 內所有自我引用（README 標題、`_doc/v1.0.md` 標題與目錄樹）。

### 帳號與信箱歸戶

commit 的 author 信箱換過兩次，最終定案：

```
200689512+HJJ8451881@users.noreply.github.com
```

用 GitHub 的 noreply 位址而非私人 Gmail，原因是 **public repo 的 commit metadata 是永久公開的**——任何人 clone 下來 `git log` 就看得到，爬蟲會收。noreply 位址一樣能正確歸戶、一樣計入 contribution。

信箱只設在這個 repo 的 local config，沒有動全域設定。

### 一次 force push（覆寫公開歷史）

第一次 push 用的是**前一個帳號**的 noreply 位址，導致 commit 歸戶到別的帳號——新帳號 profile 上不會有這些 contribution，且 repo 裡的作者連結會指向另一個人。

用 `git filter-branch --env-filter` 改寫兩個 commit 的 author/committer 信箱（保留原始 author date），再 `git push --force-with-lease` 覆寫。

**可以這樣做的前提**：repo 建立不到一小時、無 fork、無協作者、無人 clone。任何一項不成立就不該這樣處理。`--force-with-lease` 而非 `--force`，會先確認遠端仍是本地已知的狀態才覆寫。

### 認證方式

一開始用 HTTPS remote，非互動 shell 讀不到 GitHub 認證（`~/.git-credentials` 裡只有內部主機的憑證）。改用 SSH remote 後正常。

`~/.ssh/config` 中 `github.com` 綁定單一金鑰且 `IdentitiesOnly yes`，代表這台機器對 GitHub 只會使用這一個帳號；若要用另一個帳號推送，需另加 `Host` alias。

## 驗證

- **已驗證**：`ssh -T git@github.com` 回應 `Hi HJJ8451881!`，確認 SSH 金鑰對應的是預期帳號。
- **已驗證**：push 後以 GitHub API 查詢兩個 repo 的 commit，`author.login` 皆為 `HJJ8451881`，信箱皆為預期的 noreply 位址。歸戶正確。
- **已驗證**：兩個 commit 的時間差仍在（`12:50:09` → `12:50:18`），原始資料仍先於分析——filter-branch 保留了 author date，force push 沒有破壞這個順序。
- **已驗證**：repo 為 Public（API `private: false`）。
- **未驗證**：`description` 與 `topics` 在寫這份記錄時仍為空（API 回 `description: null`、`topics: []`）。這兩欄只能在網頁介面設定，尚未填入。

## 待辦 / 已放棄

- **待辦**：填入 repo 的 description 與 topics。repo 清單上每一行只顯示名稱加一句 description，這一行決定對方點不點進去，目前是空白。
- **待辦**：把這兩個 repo pin 到 profile。
- **已放棄**：不改用私人 Gmail 作為 commit 信箱，理由見上。
- **已放棄**：不沿用舊帳號。兩個帳號各有取捨（舊帳號 2019 年建立、看起來不像臨時開的；新帳號名稱較不易讀），已擇一，不再反覆。
