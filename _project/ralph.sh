#!/usr/bin/env bash
# ralph.sh — Ralph one-shot runner.
#
# Usage:
#   ./ralph.sh [guidance...]
#
# Behavior:
#   - Invokes the agent CLI once with prompt.md as the prompt; Ralph lands
#     one working set of PRD tasks and exits. There is no loop.
#   - Arguments (optional) are appended as a "Guidance from the invoker"
#     section, steering which tasks Ralph selects.
#
# Environment:
#   RALPH_CMD — agent command that reads the prompt on stdin; split on
#               whitespace. Default: claude --dangerously-skip-permissions -p

set -euo pipefail

PROMPT_FILE="prompt.md"
RALPH_CMD=${RALPH_CMD:-"claude --dangerously-skip-permissions -p"}

if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "error: $PROMPT_FILE not found in $(pwd)." >&2
  exit 1
fi

read -r -a cmd <<< "$RALPH_CMD"
command -v "${cmd[0]}" >/dev/null 2>&1 || { echo "error: '${cmd[0]}' not found on PATH." >&2; exit 1; }

prompt=$(cat "$PROMPT_FILE")

if (( $# > 0 )); then
  prompt+=$'\n\n## Guidance from the invoker\n\n'"$*"
  echo "=== Ralph run (guided) ==="
else
  echo "=== Ralph run ==="
fi
echo ""

printf '%s\n' "$prompt" | "${cmd[@]}"
