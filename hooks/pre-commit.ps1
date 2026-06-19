# Pre-commit hook: Update AGENTS.md on version-tagged commits
# Place this in .githooks/pre-commit.ps1 or run manually.
#
# Usage (from repo root):
#   .\.githooks\pre-commit.ps1
#   .\.githooks\pre-commit.ps1 -Model gpt-4o
#   .\.githooks\pre-commit.ps1 -Agent claude
#
# This hook fires ONLY when the last commit message contains "tag."
# (e.g., "tag.v1.2.3: add refund support"). It diffs the current
# branch against main and runs an AI agent to update AGENTS.md.
#
# Skip with: git commit --no-verify

param(
    [ValidateSet("copilot", "claude")]
    [string]$Agent = "copilot",

    [string]$Model = "",  # Copilot: model name | Claude: --model flag value
    [switch]$DryRun       # Preview without writing files
)

$ErrorActionPreference = "Stop"

# ── 1. Check if this is a version-tagged commit ──────────────────────

$lastMsg = git log --format=%s -1 HEAD 2>$null
if (-not $lastMsg) {
    # No HEAD yet (first commit). Skip.
    exit 0
}

if ($lastMsg -notmatch "tag\.") {
    Write-Host "pre-commit: Not a version-tagged commit. Skipping AGENTS.md update."
    exit 0
}

Write-Host "==> Version commit detected: $lastMsg"
Write-Host "==> Updating AGENTS.md..."

# ── 2. Diff current branch against main ─────────────────────────────

$diff = git diff main...HEAD --stat 2>$null
if (-not $diff -or $diff.Trim().Length -eq 0) {
    Write-Host "pre-commit: No diff against main. Skipping."
    exit 0
}

# ── 3. Read current AGENTS.md ───────────────────────────────────────

$agentsMdPath = Join-Path (Get-Location) "AGENTS.md"
if (Test-Path $agentsMdPath) {
    $currentAgentsMd = Get-Content $agentsMdPath -Raw
} else {
    Write-Warning "pre-commit: No AGENTS.md found. Creating one."
    $currentAgentsMd = "# AGENTS.md`n`nEnter project context here."
}

# ── 4. Build the prompt ─────────────────────────────────────────────

$prompt = @"
You are maintaining the AGENTS.md file for this repository.

Below is the git diff (against main) for the current branch, followed by
the current AGENTS.md content.

Update AGENTS.md to reflect the changes. Rules:
- Only modify sections affected by the diff.
- Keep all existing sections that are still accurate.
- Add new sections only if the diff introduces entirely new concepts.
- Keep the file concise (100-150 lines max).
- Do NOT remove anything that still applies.
- Output ONLY the updated AGENTS.md content. No explanations.

## GIT DIFF (main...HEAD)
$diff

## CURRENT AGENTS.md
$currentAgentsMd
"@

# ── 5. Run the agent ────────────────────────────────────────────────

$tempPrompt = New-TemporaryFile
$tempOutput = New-TemporaryFile
Set-Content -Path $tempPrompt -Value $prompt

try {
    switch ($Agent) {
        "copilot" {
            $modelArg = if ($Model) { "--model $Model" } else { "" }

            Write-Host "pre-commit: Running GitHub Copilot${modelArg}..."

            if ($DryRun) {
                Write-Host "[DRY RUN] Would run: gh copilot suggest --shell -p `<prompt-file>`"
                Write-Host "[DRY RUN] Prompt preview:`n$prompt"
                exit 0
            }

            # gh copilot for non-interactive update
            # Pipe the prompt as a file reference
            $result = Get-Content $tempPrompt | gh copilot suggest --shell 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Copilot failed: $result"
                Write-Host "Use --no-verify to skip this hook."
                exit 1
            }
            $updated = $result -join "`n"
        }

        "claude" {
            $modelArg = if ($Model) { "--model $Model" } else { "" }

            Write-Host "pre-commit: Running Claude Code${modelArg}..."

            if ($DryRun) {
                Write-Host "[DRY RUN] Would run: claude --print --permission-mode bypassPermissions -p `<prompt>`"
                Write-Host "[DRY RUN] Prompt preview:`n$prompt"
                exit 0
            }

            $escapedPrompt = $prompt -replace '"', '`"'
            $result = claude --print --permission-mode bypassPermissions -p $escapedPrompt $modelArg 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Claude failed: $result"
                Write-Host "Use --no-verify to skip this hook."
                exit 1
            }
            $updated = $result -join "`n"
        }
    }

    # ── 6. Write updated AGENTS.md ──────────────────────────────────

    if ($updated -and $updated.Trim().Length -gt 0) {
        Set-Content -Path $agentsMdPath -Value $updated -NoNewline
        git add AGENTS.md
        Write-Host "==> AGENTS.md updated and staged."
    } else {
        Write-Warning "pre-commit: Agent produced empty output. AGENTS.md unchanged."
    }

} finally {
    Remove-Item $tempPrompt -Force -ErrorAction SilentlyContinue
    Remove-Item $tempOutput -Force -ErrorAction SilentlyContinue
}
