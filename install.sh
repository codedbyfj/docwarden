#!/usr/bin/env bash
# Installs docwarden.
#
# Usage:
#   ./install.sh claude-code        # installs globally to ~/.claude/skills
#   ./install.sh project /path/to/repo   # copies all adapters into a repo
#
# Or via curl, once the repo is public:
#   curl -fsSL https://raw.githubusercontent.com/codedbyfj/docwarden/main/install.sh | bash -s -- claude-code

set -euo pipefail

MODE="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$MODE" in
  claude-code)
    mkdir -p "$HOME/.claude/skills"
    cp -r "$SCRIPT_DIR/skills/docwarden" "$HOME/.claude/skills/docwarden"
    echo "Installed globally to ~/.claude/skills/docwarden"
    echo "Trigger with: \"update the docs\" or \"run docwarden\" in any repo."
    ;;
  project)
    TARGET="${2:-}"
    if [ -z "$TARGET" ] || [ ! -d "$TARGET" ]; then
      echo "Usage: ./install.sh project /path/to/your/repo"
      exit 1
    fi
    cp -r "$SCRIPT_DIR/skills" "$TARGET/"
    cp -r "$SCRIPT_DIR/.agents" "$TARGET/" 2>/dev/null || true
    cp -r "$SCRIPT_DIR/.opencode" "$TARGET/" 2>/dev/null || true
    mkdir -p "$TARGET/.github" && cp -r "$SCRIPT_DIR/.github/prompts" "$TARGET/.github/" 2>/dev/null || true
    cp -r "$SCRIPT_DIR/.cursor" "$TARGET/" 2>/dev/null || true
    cp -r "$SCRIPT_DIR/.antigravity" "$TARGET/" 2>/dev/null || true
    echo "Installed adapters for every supported tool into $TARGET"
    echo "Trigger with: \"update the docs\" or \"run docwarden\" in whichever tool you use there."
    ;;
  *)
    echo "Usage:"
    echo "  ./install.sh claude-code             install globally for Claude Code"
    echo "  ./install.sh project /path/to/repo   install every adapter into a project"
    exit 1
    ;;
esac
