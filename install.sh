#!/usr/bin/env bash
#
# landing-craft installer — copies the skill, sub-agents, and slash-commands into ~/.claude.
#
#   curl -fsSL https://raw.githubusercontent.com/propiter/landing-craft/main/install.sh | bash
#
# Idempotent (re-run to update). No sudo, no global npm, nothing runs in the background.
#
set -euo pipefail

REPO="${LANDING_CRAFT_REPO:-https://github.com/propiter/landing-craft}"
BRANCH="${LANDING_CRAFT_BRANCH:-main}"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

say() { printf '\033[1m[landing-craft]\033[0m %s\n' "$1"; }

say "Installing into $CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if command -v git >/dev/null 2>&1; then
  git clone --depth 1 --branch "$BRANCH" "$REPO" "$TMP/landing-craft" >/dev/null 2>&1
  SRC="$TMP/landing-craft"
else
  say "git not found — downloading tarball"
  curl -fsSL "$REPO/archive/refs/heads/$BRANCH.tar.gz" -o "$TMP/lc.tar.gz"
  tar -xzf "$TMP/lc.tar.gz" -C "$TMP"
  SRC="$TMP/landing-craft-$BRANCH"
fi

# Copy the skill (with its references), the 8 sub-agents, and the 4 slash-commands.
cp -R "$SRC/skills/landing-craft" "$CLAUDE_DIR/skills/"
cp "$SRC"/agents/landing-*.md     "$CLAUDE_DIR/agents/"
cp "$SRC"/commands/landing*.md    "$CLAUDE_DIR/commands/"

say "Installed:"
say "  skill    → skills/landing-craft"
say "  agents   → $(ls "$SRC"/agents/landing-*.md | wc -l | tr -d ' ') sub-agents"
say "  commands → /landing  /landing-new  /landing-build  /landing-review  /landing-ship"
echo
say "Done. In Claude Code, try:  /landing-new \"<your product>\""
