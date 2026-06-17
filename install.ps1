#!/usr/bin/env pwsh
# landing-craft installer (Windows / PowerShell) — sets up the WHOLE stack in one command.
# Copies landing-craft + its bundled skills (motion-craft, marketing-strategy, brand-voice,
# seo-geo, design-review-loop) into ~/.claude, and fetches Impeccable (optional aesthetic engine).
#
#   irm https://raw.githubusercontent.com/propiter/landing-craft/main/install.ps1 | iex
#
# `irm` and `iex` are built into PowerShell — nothing extra is installed. This script only COPIES
# files into ~/.claude (uses git if present, else downloads a zip with built-in tools).
# Idempotent. No admin rights, nothing runs in the background.

$ErrorActionPreference = 'Stop'

$Repo       = if ($env:LANDING_CRAFT_REPO)       { $env:LANDING_CRAFT_REPO }       else { 'https://github.com/propiter/landing-craft' }
$Branch     = if ($env:LANDING_CRAFT_BRANCH)     { $env:LANDING_CRAFT_BRANCH }     else { 'main' }
$Home0      = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
$ClaudeDir  = if ($env:CLAUDE_CONFIG_DIR)        { $env:CLAUDE_CONFIG_DIR }        else { Join-Path $Home0 '.claude' }
$WithImpecc = if ($env:LANDING_CRAFT_IMPECCABLE) { $env:LANDING_CRAFT_IMPECCABLE } else { '1' }

function Say($m) { Write-Host "[landing-craft] $m" -ForegroundColor Cyan }

Say "Installing the stack into $ClaudeDir"
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

  # Bundled skills (landing-craft + all dependencies) — copy each cleanly.
  $skills = Get-ChildItem -Directory (Join-Path $src 'skills')
  foreach ($s in $skills) {
    $dest = Join-Path $ClaudeDir (Join-Path 'skills' $s.Name)
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse -Force $s.FullName (Join-Path $ClaudeDir 'skills')
  }

  # landing-craft sub-agents + slash-commands.
  Copy-Item -Force (Join-Path $src 'agents/landing-*.md')  (Join-Path $ClaudeDir 'agents')
  Copy-Item -Force (Join-Path $src 'commands/landing*.md') (Join-Path $ClaudeDir 'commands')

  # Optional: Impeccable (third-party, Apache-2.0) — fetched from source so it stays current.
  if ($WithImpecc -eq '1' -and (Get-Command git -ErrorAction SilentlyContinue)) {
    try {
      git clone --depth 1 https://github.com/pbakaus/impeccable.git (Join-Path $tmp 'imp') 2>$null | Out-Null
      $impSrc = Join-Path $tmp 'imp/.agents/skills/impeccable'
      if (Test-Path $impSrc) {
        $impDest = Join-Path $ClaudeDir 'skills/impeccable'
        if (Test-Path $impDest) { Remove-Item -Recurse -Force $impDest }
        Copy-Item -Recurse -Force $impSrc (Join-Path $ClaudeDir 'skills')
        Say "+ Impeccable aesthetic engine (Apache-2.0, by Paul Bakaus)"
      }
    } catch { Say "(Impeccable optional - skipped)" }
  }

  Say "Installed: $($skills.Count) skills + landing-craft sub-agents & commands"
  Say "  skills   -> landing-craft, motion-craft, marketing-strategy, brand-voice, seo-geo, design-review-loop (+ impeccable)"
  Say "  commands -> /landing  /landing-new  /landing-build  /landing-review  /landing-ship"
  Write-Host ""
  Say "Done. In Claude Code run /reload-plugins (or restart it), then try:  /landing `"<your product>`""
}
finally {
  Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
