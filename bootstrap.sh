#!/usr/bin/env bash
#
# bootstrap.sh — scaffold this starter pack into a target repo.
#
# Designed for Claude Code in the Claude app (mobile/desktop), where each
# session attaches to a single GitHub repo. This script copies the contents
# of `claude/` into a target repo's `.claude/` folder, drops in a starter
# CLAUDE.md, and commits everything. After running it, the target repo has
# the full starter pack baked in and Claude Code will pick it up on every
# future session attached to that repo.
#
# Usage from inside a Claude Code session attached to *this* repo
# (claude-code-starter):
#
#   bash bootstrap.sh <target-repo-url> [project-name]
#
# Example:
#   bash bootstrap.sh https://github.com/mick353/widget-api.git widget-api
#
# What it does:
#   1. Clones <target-repo-url> into a temp directory
#   2. Copies claude/ → <target>/.claude/
#   3. Copies claude/CLAUDE.template.md → <target>/CLAUDE.md (if absent)
#   4. Commits with a clear message
#   5. Pushes to the target repo's default branch
#
# What it does NOT do:
#   - Overwrite an existing .claude/ folder in the target (it bails instead)
#   - Overwrite an existing CLAUDE.md (it leaves it alone, only adds .claude/)
#   - Push if there's nothing to commit
#
# Requirements:
#   - git available
#   - The Claude Code session has push access to the target repo
#     (true for any repo on the account you're working under)

set -euo pipefail

TARGET_URL="${1:-}"
PROJECT_NAME="${2:-}"

if [ -z "$TARGET_URL" ]; then
  echo "Usage: bash bootstrap.sh <target-repo-url> [project-name]" >&2
  echo "" >&2
  echo "Example:" >&2
  echo "  bash bootstrap.sh https://github.com/mick353/widget-api.git widget-api" >&2
  exit 1
fi

# Derive a sensible project name if one wasn't given
if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME=$(basename "$TARGET_URL" .git)
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "→ Cloning $TARGET_URL ..."
git clone --depth 1 "$TARGET_URL" "$TMP_DIR/target"
cd "$TMP_DIR/target"

# Refuse to clobber an existing .claude/ — let the user resolve it
if [ -d ".claude" ]; then
  echo "" >&2
  echo "✗ Target repo already has a .claude/ folder." >&2
  echo "  Refusing to overwrite. Inspect and merge manually:" >&2
  echo "  $TMP_DIR/target/.claude" >&2
  exit 2
fi

echo "→ Copying claude/ → .claude/ ..."
cp -r "$SCRIPT_DIR/claude" ".claude"

# Drop the template inside .claude (it shouldn't be auto-loaded from there)
# and place a top-level CLAUDE.md only if one doesn't already exist.
if [ -f ".claude/CLAUDE.template.md" ] && [ ! -f "CLAUDE.md" ]; then
  echo "→ Creating CLAUDE.md from template ..."
  cp ".claude/CLAUDE.template.md" "CLAUDE.md"
  # Best-effort substitution of the project name placeholder
  if command -v sed >/dev/null 2>&1; then
    sed -i.bak "s/<PROJECT NAME>/$PROJECT_NAME/g" "CLAUDE.md" && rm -f "CLAUDE.md.bak"
  fi
fi

# Stage and commit
git add .claude CLAUDE.md 2>/dev/null || git add .claude
if git diff --cached --quiet; then
  echo "→ Nothing to commit (target already had the config?)."
  exit 0
fi

git -c user.name="claude-code-starter bootstrap" \
    -c user.email="bootstrap@local" \
    commit -m "scaffold: add Claude Code starter config (.claude/, CLAUDE.md)"

# Determine default branch (main / master / other) and push to it
DEFAULT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
echo "→ Pushing to origin/$DEFAULT_BRANCH ..."
git push origin "$DEFAULT_BRANCH"

echo ""
echo "✓ Done."
echo ""
echo "Next steps:"
echo "  1. In your Claude app, start a new Claude Code session"
echo "  2. Select the repo: $TARGET_URL"
echo "  3. Edit CLAUDE.md to fill in the stack/conventions for $PROJECT_NAME"
echo "  4. Start working — the rules, agents, skills, and hooks load automatically"
