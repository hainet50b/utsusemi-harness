# AGENTS.md

This project uses the **Ralph Loop** methodology — a development style that separates spec (human + conversational LLM) from implementation (Ralph, the executor LLM). Before acting, scan the relevant files in this repo to understand the current state:

- `README.md` — user-facing reference (snapshot, not a contract)
- `SPEC/` — developer-facing internal reference (snapshot, not a contract). The directory always contains `SPEC/SPEC.md` and may contain additional files in any format the project needs (OpenAPI, ER diagrams, Mermaid, protobuf, etc.); read whatever is in there
- `PRD.md` — What / Why + open Tasks
- `CONVENTIONS.md` — how code is written here
- `prompt.md` / `ralph.sh` / `ralph.ps1` — Ralph's run contract and one-shot runner

## Principles

- **Spec and implementation are separate concerns.** Spec belongs to the human and the conversational LLM. Implementation belongs to Ralph. Do not blur the two — in conversation, never implement PRD tasks yourself; delegate them (see **Running Ralph** below).
- **Completed PRD tasks are history.** Items marked `[x]` in `PRD.md` are immutable. Corrections to past work are expressed as new tasks, not edits to existing ones.
- **Spec is a reference, not a contract.** Spec files (`README.md`, `SPEC/`) record the understanding at the time they were written; the codebase and current tooling are the ground truth. When the implementation context offers a clearly better option than the spec describes, take the better option — and surface the divergence so the spec can catch up. Never conform to a stale spec just because it is written down. The exceptions: `PRD.md`'s What / Why and open Tasks are the project's binding intent; `CONVENTIONS.md`'s lint / format / test commands remain each run's pass gate; and files under `SPEC/contracts/` are interface contracts — promises to parties outside this repo — that bind the interfaces they describe (implementation internals stay free). A desired deviation from a contract is escalated as a new PRD task, never taken autonomously.
- **Act naturally, not formulaically.** You know this project follows Ralph Loop. Internalize the conventions but don't announce them in conversation — phrases like "As per Ralph Loop, I'll…" make the user feel like a spectator.

## Running Ralph

When the human asks for implementation (or says to "run Ralph"), kick the runner instead of writing the code yourself:

- Run `./ralph.sh` (or `.\ralph.ps1` on Windows) — in the background if your harness supports it, so the spec conversation can continue in parallel.
- One run = one working set: Ralph selects a coherent group of open `PRD.md` tasks, lands them commit by commit, reports, and exits.
- Ralph picks the working set itself; to steer it, pass guidance as arguments: `./ralph.sh "focus on the parser tasks"`. Guidance selects among open tasks, never adds scope.
- While a run is in flight, do not edit `PRD.md` — Ralph is checking tasks off in it. Hold new tasks until the run completes.
- Relay the substance of Ralph's report to the human and decide together whether to kick the next run.

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
- Review Ralph's recent commits for `Spec-Drift:` trailers; fold confirmed divergences back into `SPEC/` / `README.md`. Spec trails implementation here — that is expected, not a failure.

PRD's Tasks section is managed jointly with the human. The spec-layer updates above are owned by the human and you; Ralph is never asked to update them, which preserves the spec/implementation separation principle above.
