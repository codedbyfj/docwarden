#!/usr/bin/env bash
# Verifies every adapter still points at skills/docwarden/SKILL.md instead of
# having its own copy of the rules pasted in (which would drift over time).
# Run this in CI or before committing changes to the docwarden package.

set -euo pipefail

CANONICAL="skills/docwarden/SKILL.md"
FAIL=0

if [ ! -f "$CANONICAL" ]; then
  echo "Missing canonical file: $CANONICAL"
  exit 1
fi

ADAPTERS=(
  ".agents/rules/docwarden.md"
  ".opencode/command/docwarden.md"
  ".github/prompts/docwarden.prompt.md"
  ".cursor/commands/docwarden.md"
  ".antigravity/workflows/docwarden.md"
  "commands/docwarden.md"
)

for f in "${ADAPTERS[@]}"; do
  if [ ! -f "$f" ]; then
    echo "MISSING adapter: $f"
    FAIL=1
    continue
  fi
  if ! grep -q "skills/docwarden/SKILL.md" "$f"; then
    echo "DRIFT: $f no longer references the canonical file"
    FAIL=1
  fi
done

if [ "$FAIL" -eq 0 ]; then
  echo "All adapters point at $CANONICAL. No drift."
else
  echo "Fix the files above so they reference $CANONICAL instead of duplicating rules."
fi

# The plugin manifests are metadata, not rule pointers, so they can't
# reference $CANONICAL. Check they still share the canonical description
# marker instead of letting name/description drift apart over time.
# ponytail: grep marker beats JSON parsing (no jq dep); a changed marker
# that keeps the "Bootstraps AGENTS.md" fragment still slips through, fine for metadata.
MANIFESTS=(
  "plugin.json"
  ".claude-plugin/plugin.json"
  ".codex-plugin/plugin.json"
  ".devin-plugin/plugin.json"
)

for f in "${MANIFESTS[@]}"; do
  if [ ! -f "$f" ]; then
    echo "MISSING manifest: $f"
    FAIL=1
    continue
  fi
  if ! grep -q "Bootstraps AGENTS.md" "$f"; then
    echo "DRIFT: $f no longer matches the canonical plugin description"
    FAIL=1
  fi
done

exit $FAIL
