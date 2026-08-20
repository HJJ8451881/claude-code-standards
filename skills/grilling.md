---
name: grilling
description: Interview the user relentlessly about a plan, decision, or idea until every design branch is settled — the design-tree/frontier method, the numbered question format, and the rule that facts are the agent's job. Use whenever a plan needs stress-testing before work starts, and before writing a spec for a client engagement.
---

# Grilling: interviewing a plan until nothing is silently assumed

Adapted from `mattpocock/skills` (`skills/productivity/grilling`, MIT). Kept close to
upstream so it stays easy to diff against updates.

Interview the user relentlessly until reaching a shared understanding. Map this as a
**design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are
already settled — the questions that can be asked *now* without guessing at answers not yet
heard. Ask the whole frontier in one round: number each question and give a recommended
answer. Then wait for the answers before the next round.

Format each question like this:

```
❓ **Q1** - **<question title>**: <question body, may be several paragraphs, may offer choices>

➡️ <recommended answer>
```

Each round of answers reshapes the tree: settled decisions push the frontier outward and
unblock questions that depended on them. Recompute the frontier and ask the next round. A
question whose answer depends on another question still open *this* round belongs to a
*later* round, not this one.

## Hard rules

- **Finding facts is the agent's job, never the user's.** When a frontier question needs a
  fact from the environment (filesystem, codebase, tools, a running service), dispatch a
  sub-agent to find it. Never ask the user something that could be looked up.
- **Don't block on a lookup.** A running exploration is an unsettled prerequisite, so only
  the questions downstream of it wait. Ask the rest of the frontier now.
- **The decisions belong to the user.** Put each one to them and wait. A recommended answer
  is a recommendation, not a default to proceed on.
- **Done means the frontier is empty**: every branch visited, nothing left silently
  assumed. **Do not act on the plan until shared understanding is confirmed.**
- Ask the whole frontier at once — this is the one place where a wall of questions is
  correct. Do not drip-feed one question per message.

## Fit with the rest of this setup

- For handover documents / operations manuals / SOPs, use `handover-docs` instead: that
  skill's interview is deliberately **one question at a time**, because it is mining what
  only the user knows. Grilling batches by design. Don't mix the two styles in one session.
- When the grilling converges, `to-spec` turns the agreed understanding into a spec
  document. Do not let `to-spec` re-open settled decisions.
