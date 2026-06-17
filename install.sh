#!/usr/bin/env bash
#
# landing-craft installer — sets up the WHOLE stack in one command.
# Copies landing-craft + its bundled skills (motion-craft, marketing-strategy, brand-voice,
# seo-geo, design-review-loop) into ~/.claude, and fetches Impeccable (optional aesthetic engine).
#
#   curl -fsSL https://raw.githubusercontent.com/propiter/landing-craft/main/install.sh | bash
#
# Idempotent (re-run to update). No sudo, no global npm, nothing runs in the background.
#
set -euo pipefail

REPO="${LANDING_CRAFT_REPO:-https://github.com/propiter/landing-craft}"
BRANCH="${LANDING_CRAFT_BRANCH:-main}"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
WITH_IMPECCABLE="${LANDING_CRAFT_IMPECCABLE:-1}"   # set to 0 to skip the third-party aesthetic engine

say() { printf '\033[1m[landing-craft]\033[0m %s\n' "$1"; }

say "Installing the stack into $CLAUDE_DIR"
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

# Bundled skills (landing-craft + all its dependencies) — copy each cleanly.
for dir in "$SRC"/skills/*/; do
  name="$(basename "$dir")"
  rm -rf "$CLAUDE_DIR/skills/$name"
  cp -R "$dir" "$CLAUDE_DIR/skills/$name"
done
SKILL_COUNT="$(ls -d "$SRC"/skills/*/ | wc -l | tr -d ' ')"

# landing-craft sub-agents + slash-commands.
cp "$SRC"/agents/landing-*.md  "$CLAUDE_DIR/agents/"
cp "$SRC"/commands/landing*.md "$CLAUDE_DIR/commands/"

# Optional: Impeccable (third-party, Apache-2.0) — the aesthetic engine. Fetched from source so it
# stays current; soft-fails so the rest of the stack always installs.
if [ "$WITH_IMPECCABLE" = "1" ] && command -v git >/dev/null 2>&1; then
  if git clone --depth 1 https://github.com/pbakaus/impeccable.git "$TMP/imp" >/dev/null 2>&1 \
     && [ -d "$TMP/imp/.agents/skills/impeccable" ]; then
    rm -rf "$CLAUDE_DIR/skills/impeccable"
    cp -R "$TMP/imp/.agents/skills/impeccable" "$CLAUDE_DIR/skills/impeccable"
    say "+ Impeccable aesthetic engine (Apache-2.0, by Paul Bakaus)"
  else
    say "(Impeccable optional — skipped; the design/polish agents fall back to built-in craft rules)"
  fi
fi

say "Installed: $SKILL_COUNT skills + landing-craft sub-agents & commands"
say "  skills   → landing-craft · motion-craft · marketing-strategy · brand-voice · seo-geo · design-review-loop${WITH_IMPECCABLE:+ · impeccable}"
say "  commands → /landing  /landing-new  /landing-build  /landing-review  /landing-ship"
echo
say "Done. In Claude Code run /reload-plugins (or restart it), then try:  /landing \"<your product>\""
