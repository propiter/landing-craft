#!/usr/bin/env pwsh
# landing-craft installer (Windows / PowerShell) — copies the skill, sub-agents and slash-commands
# into your Claude config folder.
#
#   irm https://raw.githubusercontent.com/propiter/landing-craft/main/install.ps1 | iex
#
# `irm` and `iex` are built into PowerShell — nothing extra is installed. This script only COPIES
# files into ~/.claude (it uses git if present, else downloads a zip with built-in tools).
# Idempotent (re-run to update). No admin rights, nothing runs in the background.

$ErrorActionPreference = 'Stop'

$Repo      = if ($env:LANDING_CRAFT_REPO)   { $env:LANDING_CRAFT_REPO }   else { 'https://github.com/propiter/landing-craft' }
$Branch    = if ($env:LANDING_CRAFT_BRANCH) { $env:LANDING_CRAFT_BRANCH } else { 'main' }
$Home0     = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
$ClaudeDir = if ($env:CLAUDE_CONFIG_DIR)    { $env:CLAUDE_CONFIG_DIR }    else { Join-Path $Home0 '.claude' }

function Say($m) { Write-Host "[landing-craft] $m" -ForegroundColor Cyan }

Say "Installing into $ClaudeDir"
foreach ($d in 'skills','agents','commands') {
  New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir $d) | Out-Null
}

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("landing-craft-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
  if (Get-Command git -ErrorAction SilentlyContinue) {
    git clone --depth 1 --branch $Branch $Repo (Join-Path $tmp 'landing-craft') 2>$null | Out-Null
    $src = Join-Path $tmp 'landing-craft'
  } else {
    Say "git not found - downloading zip"
    $zip = Join-Path $tmp 'lc.zip'
    Invoke-WebRequest -Uri "$Repo/archive/refs/heads/$Branch.zip" -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $tmp -Force
    $src = Join-Path $tmp "landing-craft-$Branch"
  }

  # Skill (with its references) — replace cleanly. Forward slashes work on Windows and Linux pwsh.
  $skillDest = Join-Path $ClaudeDir 'skills/landing-craft'
  if (Test-Path $skillDest) { Remove-Item -Recurse -Force $skillDest }
  Copy-Item -Recurse -Force (Join-Path $src 'skills/landing-craft') (Join-Path $ClaudeDir 'skills')

  # Sub-agents + slash-commands.
  Copy-Item -Force (Join-Path $src 'agents/landing-*.md')  (Join-Path $ClaudeDir 'agents')
  Copy-Item -Force (Join-Path $src 'commands/landing*.md') (Join-Path $ClaudeDir 'commands')

  $nAgents   = (Get-ChildItem (Join-Path $ClaudeDir 'agents/landing-*.md')).Count
  $nCommands = (Get-ChildItem (Join-Path $ClaudeDir 'commands/landing*.md')).Count
  Say "Installed: skill + $nAgents sub-agents + $nCommands commands"
  Say "  commands -> /landing  /landing-new  /landing-build  /landing-review  /landing-ship"
  Write-Host ""
  Say "Done. In Claude Code run /reload-plugins (or restart it), then try:  /landing `"<your product>`""
}
finally {
  Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
