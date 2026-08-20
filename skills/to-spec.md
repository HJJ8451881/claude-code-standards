---
name: to-spec
description: Turn an already-agreed conversation into a written spec — no interview, just synthesis — saved as local markdown. Use after a grilling session has converged, or when asked to turn a discussion into a spec document, including for client engagements where the spec doubles as the quote and scope-of-work attachment.
disable-model-invocation: true
---

# Conversation to spec

Adapted from `mattpocock/skills` (`skills/engineering/to-spec`, MIT). Two deliberate
deviations from upstream, both noted below: **no issue tracker** (local markdown instead)
and **no triage label**.

Take the current conversation and codebase understanding and produce a spec. **Do NOT
interview the user** — synthesise what you already know. If the decisions were never
actually settled, stop and run `grilling` first; do not paper over gaps with plausible
guesses.

## Process

1. **Explore the repo first** to understand the current state, if you haven't already.
   Use the project's existing vocabulary throughout — its domain glossary, its naming, and
   any architecture decisions already recorded in `_doc/`. Read the project's memory for
   facts (measured numbers, topology, paths); this skill is procedure only.

2. **Sketch the test seams.** Prefer existing seams to new ones, and use the highest seam
   possible. If new seams are needed, propose them at the highest point you can. The fewer
   seams across the codebase, the better — the ideal number is one.
   **Check that the seams match expectations before writing.**

3. **Write the spec** using the template below and save it to
   `_doc/spec_<slug>.md` (slug in English kebab-case). State the path afterward.

## Hard rules

- **No interview.** This skill only synthesises. Re-opening settled decisions wastes the
  grilling that produced them.
- **No file paths or code snippets in the spec.** They go stale fast.
  *One exception*: if a prototype produced a snippet that encodes a decision more precisely
  than prose can (state machine, reducer, schema, type shape), inline it inside the
  relevant decision and note it came from a prototype. Trim to the decision-rich part, not
  a working demo.
- **A spec is not a work record and not a design record.** `_doc/YYYY-MM-DD_slug.md` is the
  work record (為什麼／做了什麼／驗證) and `_doc/vX.Y.md` belongs to `git-helper`. Never
  write a spec into either, and never let a spec silently become one.
- Say plainly which decisions are still open rather than inventing them. An honest "not yet
  decided" section is worth more than a confident guess in a document a client will hold
  you to.

<spec-template>

## Problem Statement

The problem the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list. Each one in the format:

1. As an <actor>, I want a <feature>, so that <benefit>

Example:

1. As a mobile bank customer, I want to see the balance on my accounts, so that I can make
   better informed decisions about my spending

Be extremely extensive — cover every aspect of the feature.

## Implementation Decisions

The decisions that were made. May include: modules to be built or modified, the interfaces
of those modules, technical clarifications, architectural decisions, schema changes, API
contracts, specific interactions.

No specific file paths or code snippets (see hard rules).

## Testing Decisions

Include: what makes a good test here (test external behaviour, not implementation details),
which modules will be tested, and prior art — similar tests already in the codebase.

## Out of Scope

What this spec deliberately does not cover.

## Further Notes

Anything else. Include open questions and assumptions that need confirming.

</spec-template>
