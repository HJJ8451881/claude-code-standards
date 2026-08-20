# Personal preferences

- Keep answers concise and command-first: lead with the command or code, put the explanation after it.
- Write code that reads like the surrounding code: match its comment density, naming, and idiom.
- When a repo contains two contradictory conventions, don't invent a third compromise. Pick one (usually the newer or better-tested one), explain the reasoning, and flag the other for cleanup.
- Say so directly when something is uncertain, information is missing, or a result can't be fully verified. Don't paper over it with "done".

# Environment

I work across an x86 Ubuntu workstation with a consumer GPU (~12 GB VRAM), an ARM64 single-board computer running a Wayland desktop, and an embedded ARM deployment target. Don't assume x86 desktop or a GUI session by default — ask or check.

`~/.local/bin/pip` shadows the active environment's pip on this machine. Always use `python -m pip`.

Python work is usually inside a conda environment. Check which one is active before installing anything.

# Background

Embedded, UAV, and SDR engineering. Assume familiarity with ArduPilot, MAVLink, DroneCAN, systemd, Docker, and Linux administration — skip introductory explanation of these.

# Project conventions

Work records go in the project's `_doc/YYYY-MM-DD_slug.md` (slug in English kebab-case), with 為什麼 / 做了什麼 / 驗證 sections. `_doc/vX.Y.md` is reserved for the versioned design docs that `git-helper` writes — don't mix the two. Before starting work in a project I've touched before, read the newest few `_doc/` entries and that project's memory index.

Skills hold procedure; memory holds facts. Never copy paths, IPs, or measured numbers from memory into a skill — they drift apart silently. A skill that needs a fact should say "look it up in the project's memory".

A hypothesis that testing refuted is worth recording as such, so it doesn't get proposed again.

# Environments

One conda environment per project (illustrative names: `ml-pipeline`, `sitl-sim`, `data-proxy`), invoked by full interpreter path (`/path/to/miniconda3/envs/<env>/bin/python`) rather than the `conda run` wrapper. Shell state doesn't persist between tool calls, so activate or use the full path every time.

Remote hosts are aliased in `~/.ssh/config`, each with a dedicated key. Production hosts get an explicit note in this file (e.g. "carries live users") so a destructive command doesn't land there by accident — staging and production are usually a matched pair, and a change applied to one usually needs to be applied to the other too, so say so explicitly rather than assuming it'll be remembered.

Long-running work (training, simulation, indexing) must start with the tool's background-execution option. Several binaries self-kill when their parent shell exits — this has cost real debugging time before it became a standing rule.
