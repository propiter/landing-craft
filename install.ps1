#!/usr/bin/env pwsh
# landing-craft installer (Windows / PowerShell) — the WHOLE stack, one command, for
# Claude Code · OpenCode · Cursor. Single source, multiple placements (no content duplication).
#
#   irm https://raw.githubusercontent.com/propiter/landing-craft/main/install.ps1 | iex
#
# `irm`/`iex` are built into PowerShell — nothing extra is installed. Auto-detects your AI tools.
# Idempotent. No admin rights, nothing runs in the background.

$ErrorActionPreference = 'Stop'

$Repo       = if ($env:LANDING_CRAFT_REPO)       { $env:LANDING_CRAFT_REPO }       else { 'https://github.com/propiter/landing-craft' }
$Branch     = if ($env:LANDING_CRAFT_BRANCH)     { $env:LANDING_CRAFT_BRANCH }     else { 'main' }
$WithImpecc = if ($env:LANDING_CRAFT_IMPECCABLE) { $env:LANDING_CRAFT_IMPECCABLE } else { '1' }
$Home0      = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
$ClaudeDir  = if ($env:CLAUDE_CONFIG_DIR)   { $env:CLAUDE_CONFIG_DIR }   else { Join-Path $Home0 '.claude' }
$OpencodeDir= if ($env:OPENCODE_CONFIG_DIR) { $env:OPENCODE_CONFIG_DIR } else { Join-Path $Home0 '.config/opencode' }
$CursorDir  = if ($env:CURSOR_CONFIG_DIR)   { $env:CURSOR_CONFIG_DIR }   else { Join-Path $Home0 '.cursor' }

function Say($m) { Write-Host "[landing-craft] $m" -ForegroundColor Cyan }
function Copy-Skills($src, $destSkills) {
  foreach ($s in (Get-ChildItem -Directory (Join-Path $src 'skills'))) {
    $dest = Join-Path $destSkills $s.Name
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse -Force $s.FullName $destSkills
  }
}
function Install-Target($src, $base, $skillsSub, $agentSub, $cmdSub) {
  foreach ($d in $skillsSub, $agentSub, $cmdSub) { New-Item -ItemType Directory -Force -Path (Join-Path $base $d) | Out-Null }
  Copy-Skills $src (Join-Path $base $skillsSub)
  Copy-Item -Force (Join-Path $src 'agents/landing-*.md')  (Join-Path $base $agentSub)
  Copy-Item -Force (Join-Path $src 'commands/landing*.md') (Join-Path $base $cmdSub)
}

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("landing-craft-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
  if (Get-Command git -ErrorAction SilentlyContinue) {
    git clone --depth 1 --branch $Branch $Repo (Join-Path $tmp 'landing-craft') 2>$null | Out-Null
    $src = Join-Path $tmp 'landing-craft'
  } else {
    Say "git not found - downloading zip"
    $zip = Join-Path $tmp 'lc.zip'; Invoke-WebRequest -Uri "$Repo/archive/refs/heads/$Branch.zip" -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $tmp -Force; $src = Join-Path $tmp "landing-craft-$Branch"
  }

  if ($WithImpecc -eq '1' -and (Get-Command git -ErrorAction SilentlyContinue)) {
    try {
      git clone --depth 1 https://github.com/pbakaus/impeccable.git (Join-Path $tmp 'imp') 2>$null | Out-Null
      $impSrc = Join-Path $tmp 'imp/.agents/skills/impeccable'
      if (Test-Path $impSrc) { Copy-Item -Recurse -Force $impSrc (Join-Path $src 'skills') }
    } catch {}
  }
  $skillCount = (Get-ChildItem -Directory (Join-Path $src 'skills')).Count
  $impLabel = if (Test-Path (Join-Path $src 'skills/impeccable')) { ' + impeccable' } else { '' }
  $installed = @()

  # Claude Code (also feeds OpenCode, which reads ~/.claude/skills/)
  Install-Target $src $ClaudeDir 'skills' 'agents' 'commands'
  $installed += 'Claude'

  # OpenCode (skills free via ~/.claude/skills; mirror agents + commands)
  if ((Test-Path $OpencodeDir) -or (Get-Command opencode -ErrorAction SilentlyContinue)) {
    Install-Target $src $OpencodeDir 'skills' 'agent' 'command'; $installed += 'OpenCode'
  }
  # Cursor (best-effort)
  if ((Test-Path $CursorDir) -or (Get-Command cursor -ErrorAction SilentlyContinue)) {
    Install-Target $src $CursorDir 'skills' 'agents' 'commands'; $installed += 'Cursor'
  }

  Say "Installed $skillCount skills + sub-agents & commands to: $($installed -join ', ')"
  Say "  commands -> /landing  /landing-new  /landing-build  /landing-review  /landing-ship"
  Write-Host ""
  Say "Done. Reload your tool (Claude: /reload-plugins; OpenCode: restart), then try:  /landing `"<your product>`""
}
finally { Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue }
