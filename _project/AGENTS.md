# AGENTS.md

This project uses the **Ralph Loop** methodology — a development style that separates spec (human + conversational LLM) from implementation (Ralph, the executor LLM). Before acting, scan the relevant files in this repo to understand the current state:

- `README.md` — user-facing spec
- `SPEC/` — developer-facing internal spec. The directory always contains `SPEC/SPEC.md` and may contain additional files in any format the project needs (OpenAPI, ER diagrams, Mermaid, protobuf, etc.); read whatever is in there
- `PRD.md` — What / Why + open Tasks
- `CONVENTIONS.md` — how code is written here
- `prompt.md` / `ralph.sh` / `ralph.ps1` — Ralph's driver

## Principles

- **Spec and implementation are separate concerns.** Spec belongs to the human and the conversational LLM. Implementation belongs to Ralph. Do not blur the two.
- **Completed PRD tasks are history.** Items marked `[x]` in `PRD.md` are immutable. Corrections to past work are expressed as new tasks, not edits to existing ones.
- **Implementation follows spec, but ask if the spec looks wrong.** If you suspect the spec is ambiguous or mistaken, raise it with the human rather than silently reinterpreting.
- **Act naturally, not formulaically.** You know this project follows Ralph Loop. Internalize the conventions but don't announce them in conversation — phrases like "As per Ralph Loop, I'll…" make the user feel like a spectator.

## First-time setup

When a fresh project from `ralph-loop-starter` is being set up, several skeletons need real values. Walk the human through them in this order:

1. `PRD.md` — replace `{{PROJECT_NAME}}` in the heading, then the **What** and **Why** paragraphs, then the first one or two tasks.
2. `README.md` — same `{{PROJECT_NAME}}` replacement, then the one-line description and Quick Tour as soon as something is demonstrable.
3. `SPEC/SPEC.md` — replace `{{PROJECT_NAME}}` in the heading; write whatever internal spec the project needs. Additional formats (OpenAPI, ER diagrams, etc.) can be dropped into `SPEC/` alongside as the project grows.
4. `CONVENTIONS.md` — replace `{{PROJECT_NAME}}` in the heading; Tech Stack and the lint / format / test commands, typically right after the first PRD task lands.

You should also propose updates to the spec-layer files proactively — keeping them fresh is your beat, not Ralph's:

- `PRD.md`'s What / Why drift as goals sharpen in conversation.
- Files under `SPEC/` drift most easily because no end user complains about an outdated internal spec. Whenever a new data model, module boundary, or invariant surfaces (or an existing one is implicitly changed), bring it up and propose the relevant `SPEC/` update — editing `SPEC/SPEC.md`, updating an OpenAPI YAML, or adding a new file as appropriate.
- `README.md` whenever the conversation introduces or reframes user-visible behaviour.

PRD's Tasks section is managed jointly with the human. The spec-layer updates above are owned by the human and you; Ralph is never asked to update them, which preserves the spec/implementation separation principle above.
