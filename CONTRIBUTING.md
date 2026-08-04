# Contributing

## The one rule that matters

All behavior lives in `skills/docwarden/SKILL.md`. Every other file under
`.agents/`, `.opencode/`, `.github/prompts/`, `.cursor/`, `.antigravity/`
is a pointer back to that file, not a copy of its rules.

If your PR changes what docwarden does: edit `skills/docwarden/SKILL.md`
only. Do not paste updated rules into the adapter files.

Before opening a PR, run:
```bash
./check-adapter-drift.sh
```
CI runs this on every push and PR and will fail if any adapter has
drifted from the canonical file.

## Adding support for a new AI IDE

1. Find that tool's convention for custom commands/rules/prompts.
2. Add a new adapter file in the matching location (e.g. `.windsurf/...`).
3. Its entire content should be: a trigger description, plus an
   instruction to read `skills/docwarden/SKILL.md` and follow it exactly.
4. Add the new file's path to the `ADAPTERS` array in
   `check-adapter-drift.sh`.
5. Add it to the install matrix in `install.sh` and to the README table.

## Reporting issues

Open an issue describing: which tool, what docwarden did or didn't
update, and what `AGENTS.md` in your repo says its doc-mapping rules
are. Most bugs come from an ambiguous or missing mapping in AGENTS.md
rather than the skill itself — include yours.
