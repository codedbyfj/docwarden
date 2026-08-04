#!/usr/bin/env bash
# Verifies every adapter still points at skills/doc-sync/SKILL.md instead of
# having its own copy of the rules pasted in (which would drift over time).
# Run this in CI or before committing changes to the doc-sync package.

set -euo pipefail

CANONICAL="skills/doc-sync/SKILL.md"
FAIL=0

if [ ! -f "$CANONICAL" ]; then
  echo "Missing canonical file: $CANONICAL"
  exit 1
fi

ADAPTERS=(
  ".agents/rules/doc-sync.md"
  ".opencode/command/doc-sync.md"
  ".github/prompts/doc-sync.prompt.md"
  ".cursor/commands/doc-sync.md"
  ".antigravity/workflows/doc-sync.md"
)

for f in "${ADAPTERS[@]}"; do
  if [ ! -f "$f" ]; then
    echo "MISSING adapter: $f"
    FAIL=1
    continue
  fi
  if ! grep -q "skills/doc-sync/SKILL.md" "$f"; then
    echo "DRIFT: $f no longer references the canonical file"
    FAIL=1
  fi
done

if [ "$FAIL" -eq 0 ]; then
  echo "All adapters point at $CANONICAL. No drift."
else
  echo "Fix the files above so they reference $CANONICAL instead of duplicating rules."
fi

exit $FAIL
