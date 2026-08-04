# docwarden

[![adapter-drift-check](https://github.com/codedbyfj/docwarden/actions/workflows/ci.yml/badge.svg)](https://github.com/codedbyfj/docwarden/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Keeps `docs/*.md` and `CHANGELOG.md` in sync with your codebase, on
demand, in whichever AI coding tool you use. One skill, one rule set,
works identically across every AI IDE. Same architecture pattern as
`ponytail`: a single canonical file is the source of truth, and every
tool-specific adapter is a thin pointer back to it — never a copy.
That's what prevents the rules from drifting apart as you edit them.

| Tool | Adapter | Status |
|---|---|---|
| Claude Code | `/docwarden` slash command (plugin) + native `SKILL.md` support | ✅ |
| OpenCode | `/docwarden` (`.opencode/command/`) + auto-loads `~/.claude/skills/` | ✅ |
| GitHub Copilot | `/docwarden` (`.github/prompts/`) | ✅ |
| Cursor | `/docwarden` (`.cursor/commands/`) | ✅ |
| Antigravity | `/docwarden` workflow or `agy plugin install` | ✅ |
| Codex | plugin marketplace (`.codex-plugin/`), skill auto-loads | ✅ |
| Devin | plugin install (`.devin-plugin/`) | ✅ |
| Windsurf | not yet added | contributions welcome |

```
doc-sync/
├── skills/doc-sync/SKILL.md         ← canonical source of truth. Edit ONLY this.
├── adapters/claude-code.md          ← install note (Claude Code reads SKILL.md natively)
├── commands/docwarden.md            ← pointer, Claude Code /docwarden slash command
├── .agents/rules/docwarden.md       ← pointer, Codex / CodeWhale rules (no slash cmd)
├── .opencode/command/docwarden.md   ← pointer, OpenCode /docwarden command
├── .github/prompts/docwarden.prompt.md ← pointer, Copilot /docwarden prompt
├── .cursor/commands/docwarden.md    ← pointer, Cursor /docwarden command
├── .antigravity/workflows/docwarden.md ← pointer, Antigravity /docwarden workflow
└── check-adapter-drift.sh           ← run this to confirm no adapter has drifted
```

## Rule: edit one file, not six

All logic — what to read, how to detect changes, which docs to update,
how to report back — lives in `skills/doc-sync/SKILL.md` only. Every
other file just says "go read that file and follow it." If you need to
change the behavior, change it once, then run:

```bash
./check-adapter-drift.sh
```

to confirm every adapter still points at the canonical file instead of
having picked up its own copy of the rules.

## Install

**Claude Code (recommended) — plugin marketplace, no clone needed:**
```
/plugin marketplace add codedbyfj/docwarden
/plugin install docwarden@docwarden
```
Run those two lines inside Claude Code. That's it — no cloning, no
manual copying. Update later with `/plugin marketplace update docwarden`.

**Codex:**
```bash
codex plugin marketplace add codedbyfj/docwarden
codex
```
Then open `/plugins`, select the docwarden marketplace, and install it.

**Devin:**
```bash
devin plugins install codedbyfj/docwarden
```

**Antigravity:**
```bash
agy plugin install https://github.com/codedbyfj/docwarden
```

**Tested vs community:** Claude Code is the maintainer-tested path. Codex,
Devin, and Antigravity installs follow each tool's plugin conventions but
aren't smoke-tested by the maintainer — if one fails, open an issue rather
than assuming the format is right.

**OpenCode:** no plugin-install needed. OpenCode auto-loads skills from
`~/.claude/skills/`, so the Claude Code global install below covers it — or
run `./install.sh project` to drop in the `.opencode/command/` pointer.

**Claude Code, alternative (manual global install):**
```bash
git clone https://github.com/codedbyfj/docwarden.git
cd docwarden
./install.sh claude-code
```

**Any other supported tool**, into one specific project:
```bash
git clone https://github.com/codedbyfj/docwarden.git
cd docwarden
./install.sh project /path/to/your/repo
```

Each tool then discovers its own adapter automatically via its normal
convention (Antigravity workflow, Copilot prompt file, Cursor command,
OpenCode command, or `.agents/rules` for tools converging on that
standard) — no per-tool config needed beyond that copy.

**One-liner, Claude Code global install without cloning:**
```bash
curl -fsSL https://raw.githubusercontent.com/codedbyfj/docwarden/main/install.sh | bash -s -- claude-code
```

## Uninstall

| Install method | Command |
|---|---|
| Claude Code (plugin) | `/plugin remove docwarden` |
| Codex | `codex plugin remove docwarden` |
| Devin | `devin plugins remove docwarden` |
| Antigravity | `agy plugin uninstall docwarden` |
| Manual global (Claude Code) | `rm -rf ~/.claude/skills/doc-sync` |
| `install.sh project` | Delete the copied adapters from the target repo (`skills/doc-sync/`, `.agents/`, `.opencode/`, `.github/prompts/`, `.cursor/`, `.antigravity/` entries) |

## Two modes, one skill

`doc-sync` checks the repo itself and picks the right mode — you never
choose manually:

- **No `AGENTS.md` yet → init mode.** Runs the full initialization
  procedure (`skills/doc-sync/references/init-prompt.md`), analyzing the
  codebase and creating `AGENTS.md` plus only the `docs/*.md` files the
  project actually justifies.
- **`AGENTS.md` already exists → sync mode.** Enforces that file's own
  rules, diffs recent changes, and updates only the docs those changes
affect.

Same trigger phrase for both: "update the docs" / "run doc-sync". First
run on a fresh repo bootstraps everything; every run after that keeps it
current.

## How it's triggered

Manual, everywhere. Type **`/docwarden`** in tools with a slash-command
adapter (Claude Code, OpenCode, Copilot, Cursor, Antigravity), or say
**"update the docs"** / **"run doc-sync"** in any tool — Codex uses the
phrase since it has no repo-scoped slash commands. None of these auto-run
on commit — that
still requires a CI check (see the earlier `docs-check.yml` example) if
you want true zero-touch enforcement. This package is the on-demand
repair tool that all your tools share identically; the CI check is the
guardrail that catches it when nobody runs the repair tool at all.

## How to Use

**With a slash-command adapter installed** (Claude Code, OpenCode, Copilot,
Cursor, Antigravity), type `/docwarden` in the chat input — same command
in every tool, no phrasing to remember. In Codex the skill auto-loads, so
use the natural-language phrase below instead (Codex has no repo-scoped
slash commands).

**Everywhere else**, or without the slash command, trigger it by typing
this in chat:
```
update the docs
```
or:
```
run doc-sync
```

**First run on a repo with no `AGENTS.md`** → init mode. It analyzes the
codebase and creates `AGENTS.md` plus only the `docs/*.md` files the
project actually justifies (see `skills/doc-sync/references/init-prompt.md`
for exactly which files are conditional vs always-created). It ends with
a summary of what was created and what was skipped, and why.

**Every run after that** → sync mode. It reads your `AGENTS.md`'s own
doc-update rules, diffs what changed in the repo, updates only the
affected `docs/*.md` files and `CHANGELOG.md`, and reports:
- files it updated, and what changed in each
- changes it found that needed no doc update, and why
- any doc file its mapping pointed to that doesn't exist yet, asking
  whether to create it

### How to Test Your Setup

1. Make a small code change in a test branch — add a trivial function,
   or touch a file under whatever your `AGENTS.md` maps to `FEATURES.md`
   or `API.md`.
2. Run `update the docs`.
3. Confirm it reports the correct file(s) updated, and that the diff in
   those files is scoped to your change — not a full rewrite.
4. Run it again immediately with no new changes — it should report
   nothing needed updating, not regenerate anything.

### Verify no adapter has drifted

```bash
./check-adapter-drift.sh
```
Run this after editing anything under `skills/doc-sync/`, or before
opening a PR — CI runs it automatically on every push.

## What the skill actually does

See `skills/doc-sync/SKILL.md` for the full logic. Short version: reads
this repo's own `AGENTS.md` for its doc-update mapping, diffs recent
changes, updates only the affected `docs/*.md` files and `CHANGELOG.md`,
never fabricates content, and reports what it did and skipped.

## Contributing

See `CONTRIBUTING.md`. The short version: edit `skills/doc-sync/SKILL.md`
only, run `./check-adapter-drift.sh` before opening a PR, CI enforces it.

## License

MIT — see `LICENSE`.
