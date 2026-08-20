---
name: handover-docs
description: Producing and reviewing handover documents, operations and installation manuals, onboarding guides, and SOPs — the interview question set, chapter skeleton, writing rules, and PDF/Word output.
---

# Handover documents and operations manuals

## Interview before writing

A handover document earns its keep on **what only the user knows and the machine cannot tell you**. Technical detail can be read off the systems; this cannot. Ask one question at a time and wait for the answer — never dump ten at once.

**People and accounts**
- Whose account holds the domain, at which registrar, and is auto-renew on? (No renewal means everything external goes dark.)
- Whose email logs into the cloud services in use? What happens when that person leaves?
- What is the admin account called, who else has it, and where is the password kept — is there a password manager?
- Who is taking over? Who gets called when it breaks? Is there out-of-hours coverage?

**Physical and environment**
- Where is the hardware physically? How does someone power-cycle it by hand?
- Is there a UPS? What happens on a power cut?
- Are there spares? How fast can one be swapped in?
- Who are the users, how many, and when are they on it?

**Service level**
- How fast must service come back (RTO)? How much data loss is tolerable (RPO)?
- Is there off-site backup? A local git repo or a same-machine copy **is not off-site** — say so plainly.

Push vague answers toward something actionable, but stop when told it's not worth the detail or that's just how it was designed. Record it as current state plus known risk and move on.

## Two document sets

- `docs/` — the **task-oriented** manual, numbered: architecture and ports / installation / configuration / reverse proxy and TLS / certificates / users and permissions / client connectivity / external tunnel / streaming / maintenance, backup, upgrade / troubleshooting / local customizations / known issues and TODO / first-day guide / glossary. The README carries the quick reference (port table, service table, "I just want to do X").
- `_doc/` — the **event-oriented** change log; see `session-handoff`.

Both need updating after a change, especially the known-issues chapter.

## Writing rules

- **Every command states which host it runs on.** In a multi-host setup this is the most common source of error.
- Destructive commands carry a rollback.
- List the vendor default and the actual on-site value side by side, with the on-site value governing.
- Passwords and tokens are always `<REDACTED>`. If a value must be retained, isolate it in a credentials appendix: `chmod 600`, gitignored, never converted to PDF, never in the build list.
- Known issues need a fix and a suggested order of work, and must mark which items were recorded but not executed.
- Embed configuration files at build time via an include mechanism rather than pasting copies — pasted copies go stale silently.

## PDF and Word output

Use a build script; do not convert by hand. Known traps: HTML converts to docx cleanly only via ODT as an intermediate; images must be base64-embedded or the docx comes out with no images; image width must be set as an `<img>` attribute because the CSS width is ignored.

## SOP interviews

The same interview method drives operational SOPs. The point is to extract **why it's done this way**, not just the steps — that is where a training document earns its value. Expand with 5W1H and keep probing for the need under the stated request.
