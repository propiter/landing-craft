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
copy_skills()  { for d in "$SRC"/skills/*/; do n="$(basename "$d")"; rm -rf "$1/$n"; cp -R "$d" "$1/$n"; done; }
# OpenCode/Cursor reject Claude's `tools:` string frontmatter — strip Claude-only keys and mark
# agents `mode: subagent`. (Claude itself gets the files verbatim; only these targets transform.)
oc_transform() {  # $1 src file, $2 dest dir, $3 = agent|command
  awk -v k="$3" 'BEGIN{fm=0}
    /^---[[:space:]]*$/{print;fm++;if(fm==1&&k=="agent")print "mode: subagent";next}
    fm==1&&/^(tools|model|effort|argument-hint):/{next}
    {print}' "$1" > "$2/$(basename "$1")"; }

# ── fetch source ────────────────────────────────────────────────────────────
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
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
SKILL_COUNT="$(ls -d "$SRC"/skills/*/ | wc -l | tr -d ' ')"
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
say "Done. In your tool, reload (Claude: /reload-plugins, OpenCode: restart), then try:  /landing \"<your product>\""
