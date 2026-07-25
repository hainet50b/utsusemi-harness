#!/usr/bin/env pwsh
# ralph.ps1 — Ralph one-shot runner (PowerShell).
#
# Usage:
#   ./ralph.ps1 [guidance...]
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

[CmdletBinding()]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Guidance
)

$ErrorActionPreference = 'Stop'

$PromptFile = 'prompt.md'
$RalphCmd = if ($env:RALPH_CMD) { $env:RALPH_CMD } else { 'claude --dangerously-skip-permissions -p' }

if (-not (Test-Path -LiteralPath $PromptFile)) {
    Write-Error "error: $PromptFile not found in $(Get-Location)."
    exit 1
}

$Parts = $RalphCmd.Trim() -split '\s+'
$Exe = $Parts[0]
$CmdArgs = if ($Parts.Count -gt 1) { $Parts[1..($Parts.Count - 1)] } else { @() }

if (-not (Get-Command $Exe -ErrorAction SilentlyContinue)) {
    Write-Error "error: '$Exe' not found on PATH."
    exit 1
}

$PromptContent = Get-Content -LiteralPath $PromptFile -Raw

if ($Guidance -and $Guidance.Count -gt 0) {
    $PromptContent += "`n`n## Guidance from the invoker`n`n" + ($Guidance -join ' ')
    Write-Host "=== Ralph run (guided) ==="
}
else {
    Write-Host "=== Ralph run ==="
}
Write-Host ""

$PromptContent | & $Exe @CmdArgs
exit $LASTEXITCODE
