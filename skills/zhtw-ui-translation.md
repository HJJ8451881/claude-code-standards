---
name: zhtw-ui-translation
description: Traditional Chinese (Taiwan) localization of software interfaces — the team's term table, what must stay untranslated, scanning for missed strings, and the silent failure modes of i18n frameworks. Use when translating or reviewing a ground-control or similar operator interface for 繁體中文, filling in strings that were missed, changing an interface's default language, or debugging a language that is selectable but does nothing when picked.
---

# Interface localization for Taiwan

The target is wording a Taiwanese engineer reads naturally, not a literally correct translation.

## Terms

| Source | Rendering | Note |
|---|---|---|
| Rover | 地面／水面載具 | When a project covers both ground vehicles and boats; never 漫遊車 or 探測車 |
| Force (verb prefix) | 使用 | "Force軟體解碼器" → 「使用軟體解碼器」, not 強制 |
| Hz | Hz | Not 赫茲 — units stay in the original |

Add new term decisions to this table, and record the reasoning in the project's memory.

## Leave untranslated

- Parameter names, flag names, and log keywords — the user greps on them and looks them up in upstream docs.
- Established English abbreviations (MAVLink, RTK, EKF, GUIDED, RTL).
- Proper nouns and brands.
- Anything that can't be judged confidently. A missing translation beats a wrong one — wrong ones are far harder to find later.

## Register

- Replace Simplified-Chinese usage with Taiwanese equivalents: 檔案 not 文件, 軟體 not 軟件, 預設 not 默認, 記憶體 not 內存.
- Keep interface strings short. Chinese occupies more width than English, and over-long button text gets clipped or breaks the layout.
- One term must render identically across the whole interface. Do a global comparison pass after finishing.

## Scanning for gaps

Missed strings are guaranteed. Scan in this order:

1. Diff the key counts between source and translation files to find entries with no rendering.
2. Actually run the application and click through every page — **dynamically assembled strings, error messages, and modal dialogs** are where gaps cluster, and static scanning cannot see them.
3. When a gap is reported from a screenshot, chase the rest of the same class in that file rather than fixing only the one string shown.

## Silent i18n failures

Adding a language usually means editing several places at once, and missing one leaves the language **selectable but inert**, with no error: the language list in the config file, the translation file, the front-end supported-language allowlist, and the compiled catalog on the back end (many frameworks only recognize the compiled artifact, not the source `.po`).

Languages shipped upstream are not necessarily usable — vendors often compile only some of them, leaving the rest broken on arrival. **Confirm whether it was already broken before assuming a change broke it.**

Also: i18next treats `:` as its namespace separator by default, so a key like `t("Author:")` always returns the source string. When a handful of strings simply refuse to translate, check that first.
