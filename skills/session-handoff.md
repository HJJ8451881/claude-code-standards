---
name: session-handoff
description: Work-record and session-continuity conventions — what to read when picking work up, what to write when putting it down, and whether a fact belongs in memory or in _doc. Always consult this skill before writing or reading any such record; the filename convention, the section skeleton, and the rule about marking things 未驗證 are not guessable.
---

# Work records and session continuity

Work here routinely spans several sessions and several days. The record is not paperwork — it is the only input the next session gets.

## Picking work up

When asked to pick up prior progress, read in this order:

1. The project's memory index (`MEMORY.md`) — facts, paths, measured numbers, and refuted hypotheses live there.
2. The two or three newest files in `_doc/` — what changed recently and why.
3. The project's own `CLAUDE.md`, if it has one.

Then summarize in a few lines: where it was left, what is currently blocked, what you suggest next. Do not replay the file contents.

**Memory records what was true when written.** Before relying on a path, port, or parameter from it, confirm it still holds. If it doesn't, correct the memory then and there rather than working from the stale value.

## Putting work down

Filename `_doc/YYYY-MM-DD_slug.md`, slug in English kebab-case describing the change (e.g. `retry-backoff-fix`, `cert-rotation`). Several records on one day get distinct slugs, not numeric suffixes.

`_doc/vX.Y.md` is reserved for the versioned design docs `git-helper` writes — never mix the two. Test reports go to `_doc/xxx_test_report_vX.Y.md`.

Skeleton (write the record itself in Traditional Chinese — it is an internal note):

```markdown
# One-line title

日期：YYYY-MM-DD ｜ 影響機器：**which host** (only for multi-host work)

## 為什麼
Trigger, symptoms, and the diagnosis at the time. Include hypotheses that were refuted along the way.

## 做了什麼
Which files changed; key parameters as a table. Destructive steps get a rollback.

## 驗證
What was actually run and what came back. If it wasn't verified, write 未驗證.

## 待辦 / 已放棄
Abandoned directions need their reason, or they get proposed again next time.
```

## Hard rules

- **Unverified means write 未驗證.** "Shipped but not verified end-to-end" is a legitimate and necessary state — never round it up to done.
- **Correct wrong diagnoses inside the record.** When an earlier record's conclusion is overturned, mark it explicitly and give the new evidence. A wrong record costs more than no record.
- **Passwords, tokens, and private keys are always `<REDACTED>`.** If a value genuinely must be kept, put it in a separate credentials appendix, `chmod 600`, out of git, never converted to PDF.
- **Facts go to memory, narrative goes to `_doc/`.** "Which model a service uses" is a fact (memory); "why it was swapped today and how that was verified" is narrative (`_doc/`). Don't duplicate — have the record cite the memory by name.
- After writing the record, update the project's `MEMORY.md` index.

## When to offer

After finishing a batch of edits, after a test round, or when wrapping up a session, offer to write the record. If asked to just write it, don't ask about the format again.
