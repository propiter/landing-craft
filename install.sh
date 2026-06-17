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

# ── fetch source ────────────────────────────────────────────────────────────
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
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
  if git clone --depth 1 https://github.com/pbakaus/impeccable.git "$TMP/imp" >/dev/null 2>&1 \
     && [ -d "$TMP/imp/.agents/skills/impeccable" ]; then
    cp -R "$TMP/imp/.agents/skills/impeccable" "$SRC/skills/impeccable"
  fi
fi
SKILL_COUNT="$(ls -d "$SRC"/skills/*/ | wc -l | tr -d ' ')"
IMP_LABEL=""; [ -d "$SRC/skills/impeccable" ] && IMP_LABEL=" + impeccable"
INSTALLED=""

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
  cp "$SRC"/agents/landing-*.md  "$OPENCODE_DIR/agent/"
  cp "$SRC"/commands/landing*.md "$OPENCODE_DIR/command/"
  INSTALLED="$INSTALLED OpenCode(~/.config/opencode)"
fi

# ── Cursor (best-effort: skills as rules + agents) ──────────────────────────
if [ -d "$CURSOR_DIR" ] || command -v cursor >/dev/null 2>&1; then
  mkdir -p "$CURSOR_DIR/skills" "$CURSOR_DIR/agents" "$CURSOR_DIR/commands"
  copy_skills "$CURSOR_DIR/skills"
  cp "$SRC"/agents/landing-*.md  "$CURSOR_DIR/agents/"  2>/dev/null || true
  cp "$SRC"/commands/landing*.md "$CURSOR_DIR/commands/" 2>/dev/null || true
  INSTALLED="$INSTALLED Cursor(~/.cursor)"
fi

say "Installed $SKILL_COUNT skills + landing-craft sub-agents & commands to:$INSTALLED"
say "  skills   → landing-craft + motion-craft + marketing-strategy + brand-voice + seo-geo + design-review-loop${IMP_LABEL}"
say "  commands → /landing  /landing-new  /landing-build  /landing-review  /landing-ship"
echo
say "Done. In your tool, reload (Claude: /reload-plugins, OpenCode: restart), then try:  /landing \"<your product>\""
