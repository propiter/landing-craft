#!/usr/bin/env bash
#
# landing-craft installer — the WHOLE stack, in one command, for Claude Code · OpenCode · Cursor.
#
#   curl -fsSL https://raw.githubusercontent.com/propiter/landing-craft/main/install.sh | bash
#
# Single source, multiple placements (no content duplication). Auto-detects which AI tools you
# have and installs to each. Idempotent. No sudo, no global npm, nothing runs in the background.
#
set -euo pipefail

REPO="${LANDING_CRAFT_REPO:-https://github.com/propiter/landing-craft}"
BRANCH="${LANDING_CRAFT_BRANCH:-main}"
WITH_IMPECCABLE="${LANDING_CRAFT_IMPECCABLE:-1}"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
OPENCODE_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
CURSOR_DIR="${CURSOR_CONFIG_DIR:-$HOME/.cursor}"

say()  { printf '\033[1m[landing-craft]\033[0m %s\n' "$1"; }
copy_skills()  { for d in "$SRC"/skills/*/; do n="$(basename "$d")"; rm -rf "${1:?}/${n:?}"; cp -R "$d" "$1/$n"; done; }
# OpenCode/Cursor reject Claude's `tools:` string frontmatter — strip Claude-only keys and mark
# agents `mode: subagent`. (Claude itself gets the files verbatim; only these targets transform.)
oc_transform() {  # $1 src file, $2 dest dir, $3 = agent|command
  awk -v k="$3" 'BEGIN{fm=0}
    /^---[[:space:]]*$/{print;fm++;if(fm==1&&k=="agent")print "mode: subagent";next}
    fm==1&&/^(tools|model|effort|argument-hint):/{next}
    {print}' "$1" > "$2/$(basename "$1")"; }

# ── fetch source ────────────────────────────────────────────────────────────
TMP="$(mktemp -d)"; trap 'rm -rf "${TMP:?}"' EXIT
say "Fetching landing-craft…"
if command -v git >/dev/null 2>&1; then
  git clone --depth 1 --branch "$BRANCH" "$REPO" "$TMP/landing-craft" >/dev/null 2>&1
  SRC="$TMP/landing-craft"
else
  say "git not found — downloading tarball"
  curl -fsSL "$REPO/archive/refs/heads/$BRANCH.tar.gz" -o "$TMP/lc.tar.gz"
  tar -xzf "$TMP/lc.tar.gz" -C "$TMP"; SRC="$TMP/landing-craft-$BRANCH"
fi

# Optional Impeccable (third-party, Apache-2.0) fetched into the source skills/ so every target gets it.
if [ "$WITH_IMPECCABLE" = "1" ] && command -v git >/dev/null 2>&1; then
  say "Fetching Impeccable aesthetic engine… (the slow step — a few seconds, set LANDING_CRAFT_IMPECCABLE=0 to skip)"
  if git clone --depth 1 https://github.com/pbakaus/impeccable.git "$TMP/imp" >/dev/null 2>&1 \
     && [ -d "$TMP/imp/.agents/skills/impeccable" ]; then
    cp -R "$TMP/imp/.agents/skills/impeccable" "$SRC/skills/impeccable"
  fi
fi
SKILL_DIRS=("$SRC"/skills/*/); SKILL_COUNT="${#SKILL_DIRS[@]}"
IMP_LABEL=""; [ -d "$SRC/skills/impeccable" ] && IMP_LABEL=" + impeccable"
INSTALLED=""

say "Installing $SKILL_COUNT skills, sub-agents & commands to your tools…"

# ── Claude Code (also feeds OpenCode, which reads ~/.claude/skills/) ─────────
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands"
copy_skills "$CLAUDE_DIR/skills"
cp "$SRC"/agents/landing-*.md  "$CLAUDE_DIR/agents/"
cp "$SRC"/commands/landing*.md "$CLAUDE_DIR/commands/"
INSTALLED="$INSTALLED Claude(~/.claude)"

# ── OpenCode (skills come free via ~/.claude/skills; mirror agents + commands) ──
if [ -d "$OPENCODE_DIR" ] || command -v opencode >/dev/null 2>&1; then
  mkdir -p "$OPENCODE_DIR/skills" "$OPENCODE_DIR/agent" "$OPENCODE_DIR/command"
  copy_skills "$OPENCODE_DIR/skills"
  for f in "$SRC"/agents/landing-*.md;  do oc_transform "$f" "$OPENCODE_DIR/agent"   agent;   done
  for f in "$SRC"/commands/landing*.md; do oc_transform "$f" "$OPENCODE_DIR/command" command; done
  INSTALLED="$INSTALLED OpenCode(~/.config/opencode)"
fi

# ── Cursor (best-effort: skills as rules + agents) ──────────────────────────
if [ -d "$CURSOR_DIR" ] || command -v cursor >/dev/null 2>&1; then
  mkdir -p "$CURSOR_DIR/skills" "$CURSOR_DIR/agents" "$CURSOR_DIR/commands"
  copy_skills "$CURSOR_DIR/skills"
  for f in "$SRC"/agents/landing-*.md;  do oc_transform "$f" "$CURSOR_DIR/agents"   agent;   done
  for f in "$SRC"/commands/landing*.md; do oc_transform "$f" "$CURSOR_DIR/commands" command; done
  INSTALLED="$INSTALLED Cursor(~/.cursor)"
fi

say "Installed $SKILL_COUNT skills + landing-craft sub-agents & commands to:$INSTALLED"
say "  skills   → landing-craft + motion-craft + marketing-strategy + brand-voice + seo-geo + design-review-loop${IMP_LABEL}"
say "  commands → /landing  /landing-new  /landing-build  /landing-review  /landing-ship"
echo

# ── Optional Firecrawl setup ─────────────────────────────────────────────────
# Only ASK when FIRECRAWL_URL is NOT already configured anywhere we look. (`curl … | bash`
# has no usable stdin, so we read from /dev/tty when a real terminal is attached.)
_profile="$HOME/.profile"
case "${SHELL##*/}" in
  zsh)  _profile="$HOME/.zshrc" ;;
  bash) _profile="$HOME/.bashrc" ;;
esac

_fc_found=""
if [ -n "${FIRECRAWL_URL:-}" ]; then
  _fc_found="shell env"
elif [ -f "$CLAUDE_DIR/settings.json" ] && grep -q 'FIRECRAWL_URL' "$CLAUDE_DIR/settings.json" 2>/dev/null; then
  _fc_found="$HOME/.claude/settings.json"
elif grep -q '^export FIRECRAWL_URL=' "$_profile" 2>/dev/null; then
  _fc_found="$_profile"
fi

_fc_url="" _fc_key=""
if [ -n "$_fc_found" ]; then
  say ""
  say "  Firecrawl already configured (found in $_fc_found) — skipping."
elif [ -t 0 ] || [ -e /dev/tty ]; then
  _tty="/dev/tty"
  say ""
  say "── Firecrawl (optional) ─────────────────────────────────────────────────────"
  say "  Self-hosted Firecrawl enables deep market research. Both fields are optional."
  printf '[landing-craft] Firecrawl URL (optional, press Enter to skip): '
  read -r _fc_url <"$_tty" || _fc_url=""
  printf '[landing-craft] Firecrawl API key (optional, press Enter to skip): '
  read -r _fc_key <"$_tty" || _fc_key=""
else
  say "  (Non-interactive install — Firecrawl setup skipped. Set FIRECRAWL_URL in your shell env later.)"
fi

if [ -n "$_fc_url" ]; then
  # These files may hold FIRECRAWL_API_KEY (a secret) → create them owner-only (0600).
  umask 077
  # Persist to ~/.claude/settings.json (Claude Code) using node or python3 for safe JSON merge.
  _claude_settings="$CLAUDE_DIR/settings.json"
  _merge_fc() {
    local _settings="$1" _url="$2" _key="$3"
    if command -v node >/dev/null 2>&1; then
      node -e "const fs=require('fs'),a=process.argv,p=a[1];let c={};try{c=JSON.parse(fs.readFileSync(p,'utf8'))}catch(e){}c.env=c.env||{};c.env.FIRECRAWL_URL=a[2];if(a[3])c.env.FIRECRAWL_API_KEY=a[3];fs.writeFileSync(p,JSON.stringify(c,null,2)+'\n');" -- "$_settings" "$_url" "$_key" 2>/dev/null && return 0
    fi
    if command -v python3 >/dev/null 2>&1; then
      # Write a tiny temp script so we never touch stdin (safe under curl|bash).
      _py="$(mktemp /tmp/lcfc_XXXXXX.py)"
      cat > "$_py" <<'PYEOF'
import json, sys
p, url, key = sys.argv[1], sys.argv[2], sys.argv[3]
try:
    with open(p) as f: cfg = json.load(f)
except Exception: cfg = {}
cfg.setdefault('env', {})['FIRECRAWL_URL'] = url
if key: cfg['env']['FIRECRAWL_API_KEY'] = key
with open(p, 'w') as f: json.dump(cfg, f, indent=2); f.write('\n')
PYEOF
      python3 "$_py" "$_settings" "$_url" "$_key" 2>/dev/null; _rc=$?; rm -f "$_py"
      [ "$_rc" = "0" ] && return 0
    fi
    # Fallback: naive append (only if file doesn't exist or is empty)
    if [ ! -s "$_settings" ]; then
      if [ -n "$_key" ]; then
        printf '{"env":{"FIRECRAWL_URL":"%s","FIRECRAWL_API_KEY":"%s"}}\n' "$_url" "$_key" > "$_settings"
      else
        printf '{"env":{"FIRECRAWL_URL":"%s"}}\n' "$_url" > "$_settings"
      fi
    else
      say "  Note: could not auto-merge into $_settings (no node/python3). Add FIRECRAWL_URL manually."
    fi
  }
  mkdir -p "$CLAUDE_DIR"; chmod 700 "$CLAUDE_DIR" 2>/dev/null
  _merge_fc "$_claude_settings" "$_fc_url" "$_fc_key"
  chmod 600 "$_claude_settings" 2>/dev/null   # tighten if the file pre-existed at 0644
  say "  Firecrawl written to ~/.claude/settings.json (Claude Code)"

  # OpenCode + every other shell tool: export it from the shell profile. OpenCode INHERITS the
  # shell env — it does NOT read ~/.claude/settings.json, and its config.json REJECTS an `env`
  # key (writing one there breaks OpenCode). The shell profile is the correct, universal home.
  if ! grep -q '^export FIRECRAWL_URL=' "$_profile" 2>/dev/null; then
    {
      printf '\n# Firecrawl (landing-craft) — read by OpenCode + shell tools\n'
      printf 'export FIRECRAWL_URL="%s"\n' "$_fc_url"
      if [ -n "$_fc_key" ]; then printf 'export FIRECRAWL_API_KEY="%s"\n' "$_fc_key"; fi
    } >> "$_profile"
    say "  Firecrawl exported in $_profile (open a new terminal to load it)"
  fi
fi

say "Done. In your tool, reload (Claude: /reload-plugins, OpenCode: restart), then try:  /landing \"<your product>\""
say ""
say "⭐  Landing Craft is open source. If it saves you time, a star helps others find it:"
say "    https://github.com/propiter/landing-craft"
