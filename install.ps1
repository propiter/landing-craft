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
# OpenCode/Cursor reject Claude's `tools:` string frontmatter — strip Claude-only keys, mark agents.
function Oc-Transform($file, $destDir, $kind) {
  $fm = 0; $out = New-Object System.Collections.Generic.List[string]
  foreach ($line in (Get-Content -LiteralPath $file)) {
    if ($line -match '^---\s*$') {
      $out.Add($line); $fm++
      if ($fm -eq 1 -and $kind -eq 'agent') { $out.Add('mode: subagent') }
      continue
    }
    if ($fm -eq 1 -and $line -match '^(tools|model|effort|argument-hint):') { continue }
    $out.Add($line)
  }
  Set-Content -LiteralPath (Join-Path $destDir (Split-Path $file -Leaf)) -Value $out
}
function Install-Target($src, $base, $skillsSub, $agentSub, $cmdSub, $transform) {
  foreach ($d in $skillsSub, $agentSub, $cmdSub) { New-Item -ItemType Directory -Force -Path (Join-Path $base $d) | Out-Null }
  Copy-Skills $src (Join-Path $base $skillsSub)
  $ad = Join-Path $base $agentSub; $cd = Join-Path $base $cmdSub
  if ($transform) {
    foreach ($f in (Get-ChildItem (Join-Path $src 'agents/landing-*.md')))  { Oc-Transform $f.FullName $ad 'agent' }
    foreach ($f in (Get-ChildItem (Join-Path $src 'commands/landing*.md'))) { Oc-Transform $f.FullName $cd 'command' }
  } else {
    Copy-Item -Force (Join-Path $src 'agents/landing-*.md')  $ad
    Copy-Item -Force (Join-Path $src 'commands/landing*.md') $cd
  }
}

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("landing-craft-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
  Say "Fetching landing-craft…"
  if (Get-Command git -ErrorAction SilentlyContinue) {
    git clone --depth 1 --branch $Branch $Repo (Join-Path $tmp 'landing-craft') 2>$null | Out-Null
    $src = Join-Path $tmp 'landing-craft'
  } else {
    Say "git not found - downloading zip"
    $zip = Join-Path $tmp 'lc.zip'; Invoke-WebRequest -Uri "$Repo/archive/refs/heads/$Branch.zip" -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $tmp -Force; $src = Join-Path $tmp "landing-craft-$Branch"
  }

  if ($WithImpecc -eq '1' -and (Get-Command git -ErrorAction SilentlyContinue)) {
    Say "Fetching Impeccable aesthetic engine… (the slow step — a few seconds)"
    try {
      git clone --depth 1 https://github.com/pbakaus/impeccable.git (Join-Path $tmp 'imp') 2>$null | Out-Null
      $impSrc = Join-Path $tmp 'imp/.agents/skills/impeccable'
      if (Test-Path $impSrc) { Copy-Item -Recurse -Force $impSrc (Join-Path $src 'skills') }
    } catch {}
  }
  $skillCount = (Get-ChildItem -Directory (Join-Path $src 'skills')).Count
  $impLabel = if (Test-Path (Join-Path $src 'skills/impeccable')) { ' + impeccable' } else { '' }
  $installed = @()

  Say "Installing $skillCount skills, sub-agents & commands to your tools…"

  # Claude Code (also feeds OpenCode, which reads ~/.claude/skills/)
  Install-Target $src $ClaudeDir 'skills' 'agents' 'commands' $false
  $installed += 'Claude'

  # OpenCode (skills free via ~/.claude/skills; mirror agents + commands)
  if ((Test-Path $OpencodeDir) -or (Get-Command opencode -ErrorAction SilentlyContinue)) {
    Install-Target $src $OpencodeDir 'skills' 'agent' 'command' $true; $installed += 'OpenCode'
  }
  # Cursor (best-effort)
  if ((Test-Path $CursorDir) -or (Get-Command cursor -ErrorAction SilentlyContinue)) {
    Install-Target $src $CursorDir 'skills' 'agents' 'commands' $true; $installed += 'Cursor'
  }

  Say "Installed $skillCount skills + sub-agents & commands to: $($installed -join ', ')"
  Say "  commands -> /landing  /landing-new  /landing-build  /landing-review  /landing-ship"
  Write-Host ""
  # ── Optional Firecrawl setup ──────────────────────────────────────────────
  # `irm … | iex` pipes the script through a non-interactive host — only prompt when we
  # have an interactive session ($Host.UI is available and UserInteractive is true).
  $fcUrl = ''; $fcKey = ''
  $isInteractive = [Environment]::UserInteractive -and $Host.UI -and $Host.UI.RawUI
  if ($isInteractive) {
    Say ""
    Say "── Firecrawl (optional) ──────────────────────────────────────────────────────"
    Say "  Self-hosted Firecrawl enables deep market research. Both fields are optional."
    $fcUrl = ($Host.UI.Prompt('landing-craft', 'Firecrawl URL (optional, press Enter to skip):', 'URL'))['URL']
    $fcKey = ($Host.UI.Prompt('landing-craft', 'Firecrawl API key (optional, press Enter to skip):', 'Key'))['Key']
  } else {
    Say "  (Non-interactive install — Firecrawl setup skipped. Set FIRECRAWL_URL in your env or ~/.claude/settings.json later.)"
  }

  if ($fcUrl) {
    # Helper: restrict a credential file's ACL to the current user only (it may hold the API key).
    function Restrict-Acl($path) {
      if (Test-Path $path) {
        try { icacls $path /inheritance:r /grant:r "$($env:USERNAME):(R,W)" 2>$null | Out-Null } catch {}
      }
    }
    # Helper: safely merge FIRECRAWL_* into a settings JSON file using Node, Python, or raw JSON.
    function Merge-FcSettings($settingsPath, $url, $key) {
      $dir = Split-Path $settingsPath
      if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
      if (Get-Command node -ErrorAction SilentlyContinue) {
        node -e "const fs=require('fs'),a=process.argv,p=a[1];let c={};try{c=JSON.parse(fs.readFileSync(p,'utf8'))}catch(e){}c.env=c.env||{};c.env.FIRECRAWL_URL=a[2];if(a[3])c.env.FIRECRAWL_API_KEY=a[3];fs.writeFileSync(p,JSON.stringify(c,null,2)+'\n');" -- $settingsPath $url $key 2>$null
        return
      }
      if (Get-Command python3 -ErrorAction SilentlyContinue) {
        $pyScript = @"
import json, sys
p = sys.argv[1]; url = sys.argv[2]; key = sys.argv[3]
try:
    with open(p) as f: cfg = json.load(f)
except: cfg = {}
cfg.setdefault('env', {})['FIRECRAWL_URL'] = url
if key: cfg['env']['FIRECRAWL_API_KEY'] = key
with open(p, 'w') as f: json.dump(cfg, f, indent=2); f.write('\n')
"@
        python3 -c $pyScript $settingsPath $url $key 2>$null
        return
      }
      # Fallback: only write if file is absent or empty.
      if (-not (Test-Path $settingsPath) -or (Get-Item $settingsPath).Length -eq 0) {
        if ($key) {
          Set-Content $settingsPath (@{env=@{FIRECRAWL_URL=$url;FIRECRAWL_API_KEY=$key}} | ConvertTo-Json -Depth 3)
        } else {
          Set-Content $settingsPath (@{env=@{FIRECRAWL_URL=$url}} | ConvertTo-Json -Depth 3)
        }
      } else {
        Say "  Note: could not auto-merge into $settingsPath (no node/python3). Add FIRECRAWL_URL manually."
      }
    }

    # Persist to ~/.claude/settings.json for Claude Code.
    $claudeSettings = Join-Path $ClaudeDir 'settings.json'
    Merge-FcSettings $claudeSettings $fcUrl $fcKey
    Restrict-Acl $claudeSettings
    Say "  Firecrawl URL written to ~/.claude/settings.json"

    # Also persist for OpenCode — it does NOT read ~/.claude/settings.json.
    if ((Test-Path $OpencodeDir) -or (Get-Command opencode -ErrorAction SilentlyContinue)) {
      $ocCfg = Join-Path $OpencodeDir 'config.json'
      Merge-FcSettings $ocCfg $fcUrl $fcKey
      Restrict-Acl $ocCfg
      # Plain env file fallback for OpenCode versions that source it.
      $ocEnv = Join-Path $OpencodeDir 'env'
      if (Test-Path $ocEnv) {
        $lines = Get-Content $ocEnv | Where-Object { $_ -notmatch '^FIRECRAWL_URL=' -and $_ -notmatch '^FIRECRAWL_API_KEY=' }
        Set-Content $ocEnv $lines
      }
      Add-Content $ocEnv "FIRECRAWL_URL=$fcUrl"
      if ($fcKey) { Add-Content $ocEnv "FIRECRAWL_API_KEY=$fcKey" }
      Restrict-Acl $ocEnv
      Say "  Firecrawl URL written to OpenCode config (~/.config/opencode/)"
    }
  }

  Say "Done. Reload your tool (Claude: /reload-plugins; OpenCode: restart), then try:  /landing `"<your product>`""
  Say ""
  Say "*  Landing Craft is open source. If it saves you time, a star helps others find it:"
  Say "    https://github.com/propiter/landing-craft"
}
finally { Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue }
