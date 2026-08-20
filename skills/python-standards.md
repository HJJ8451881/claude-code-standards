---
name: python-standards
description: Personal Python development standards covering type hints, logging, exception handling, testing, and file splitting. Consult before creating or editing .py files.
---

# Python development standards

## Types and variables

- Production code requires complete type hints on function definitions. Illustrative snippets in conversation don't.
- No global variables. Use class attributes, closures, or dependency injection instead.

## Logging and errors

- Use `logging`, never `print()` for debugging.
- Wrap all external API and network calls in try/except and log the failure.

## Testing

- Every feature needs tests that verify business logic. Never hardcode return values just to make a test pass.
- If the repo root has a `test.sh`, run tests through it rather than calling pytest directly.

## File structure

- When a single file exceeds 1,000 lines, propose a split. Don't perform the split unprompted.
- If the repo has a `_doc/` directory, put design documents there using versioned filenames (`v1.1.md`).
