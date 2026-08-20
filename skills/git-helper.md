---
name: git-helper
description: Conventional Commits messages in English, plus the versioned _doc/vX.Y design record. Consult this skill before every commit and before writing or bumping a design-record version — because it carries hard rules on staging and on getting the draft approved that are easy to violate by just doing it directly.
---

# Git commits and versioned records

## Hard rules

- **Never run `git add` on your own initiative.** What gets staged is entirely the user's call — analyze only what is already in `git diff --staged`. If the staging area is empty, report that and stop.
- Commit messages are always **English**, following Conventional Commits (`<type>: <description>`).
- Draft first, get the user's confirmation, and only then `git commit`.

## Message content

Beyond the summary line, list the key changes as bullets. Granularity follows the change itself — a single-function patch needs no bullets; a cross-file refactor does.

## Versioned `_doc/` records

Write these only when the user asks to update the documentation or version record — not on an ordinary commit.

- Scan `_doc/` for the current highest version, increment it, and use that as the filename (`v1.1.md` → `v1.2.md`).
- Cover both what changed and the motivation. Write it in **Traditional Chinese** — it is an internal record.
- You created this file, so `git add _doc/vX.Y.md` is fine and does not violate the rule above.
- Note the distinction from session-handoff: `_doc/vX.Y.md` is the versioned design record; day-to-day work records use `_doc/YYYY-MM-DD_slug.md`.
