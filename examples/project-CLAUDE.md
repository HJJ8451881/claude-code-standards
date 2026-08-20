# Project: example-service

> This is an illustrative project-level `CLAUDE.md`, not copied from any real project — it
> shows the pattern: the global `CLAUDE.md` carries cross-project defaults and routes to
> `skills/`; a project's own `CLAUDE.md` only adds what's specific to *this* repo. Anything
> that would be true for every project belongs in the global file instead, or it just gets
> copy-pasted and drifts.

## What this project is

A small internal API service with a Postgres-backed job queue and a background worker.
Two runtime pieces: `api/` (FastAPI) and `worker/` (a polling consumer) — they deploy and
scale independently, which is why they're separate top-level packages instead of one app.

## Environment

- Conda env: `example-service` (`~/miniconda3/envs/example-service/bin/python`).
- Local dev needs Postgres running; `docker compose up db` starts just that piece.
- Tests run via `./test.sh`, same convention as the global standard — this project has no
  exception to it.

## Conventions specific to this repo

- Queue job payloads are versioned (`schema_version` field). Never change a payload shape
  without bumping it — the worker and API deploy independently, so there will always be a
  window with two versions in flight.
- `worker/` has no HTTP surface and no request-scoped logging context; log lines must carry
  the job ID explicitly since there's nothing else to correlate them by.
- This project predates the `_doc/YYYY-MM-DD_slug.md` convention — older history lives in
  `CHANGELOG.md` instead. Don't back-fill it; just use the new convention going forward.

## Out of scope for AI-driven changes

Schema migrations touching the `jobs` table go through manual review even when the diff
looks mechanical — a past migration silently dropped an index under load and the fix cost
more than the migration saved. Everything else in this repo follows the normal workflow.
