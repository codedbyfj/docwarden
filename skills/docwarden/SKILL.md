---
name: docwarden
description: Use when the user asks to sync, update, refresh, initialize, or set up project documentation — e.g. "update the docs", "sync docs with latest changes", "run docwarden", "run docwarden", "docs are out of date", "set up docs for this project", "initialize documentation". Handles both first-time setup (no AGENTS.md yet) and ongoing sync against an existing AGENTS.md. Manually triggered, not automatic.
---

# docwarden

Keep this repository's documentation in sync with its implementation.
This skill has two modes, chosen automatically based on repository state:

- **Init mode** — no `AGENTS.md` exists yet. Bootstrap the full
  documentation system from scratch, creating only what the project
  actually needs.
- **Sync mode** — `AGENTS.md` already exists. Enforce its existing rules
  and update only what recent changes affect.

This skill does not invent documentation rules on its own — in sync mode
it enforces whatever `AGENTS.md` already says; in init mode it follows
`references/init-prompt.md` to establish that contract in the first place.

## Step 0 — Decide the mode

Check whether `AGENTS.md` exists at the repository root.

- **Missing → Init mode.** Read `references/init-prompt.md` in this
  skill's folder and follow it exactly to analyze the repo and create
  `AGENTS.md` plus the full 13-file `docs/*` suite. Do not paraphrase or
  reinvent that logic — that file is the canonical initialization
  procedure. Once it completes, stop here for this run; report what was
  created and tell the user to invoke docwarden again after their next
  round of changes to keep things updated.
- **Exists → Sync mode.** Continue to Step 1 below.

## Step 1 — Load the contract (sync mode)

1. Read `AGENTS.md` at the repository root.
2. Note the "which doc file to update for which kind of change" mapping
   defined inside it (e.g. API change -> API.md, schema change ->
   DATABASE.md). Use this repo's own mapping, not a generic one.
3. List existing files under `docs/` to know what's actually there —
   don't assume a file exists just because AGENTS.md mentions it as a
   possible target.

## Step 2 — Determine what changed

1. Run `git status` and `git diff` (or `git log` since the last commit
   that touched `docs/` or `CHANGELOG.md`, whichever is more informative)
   to find what code has changed since docs were last updated.
   - If there's no git history to compare against, ask the user for a
     time range or commit range, or fall back to scanning the whole repo
     for drift against existing docs.
2. Categorize each changed area using the AGENTS.md mapping: new feature,
   API change, schema change, architecture change, UI component change,
   business logic change, deployment change, bug fix.
3. Build a list of (changed area -> doc file) pairs. If the mapping points
   to a doc file that doesn't exist (e.g. it was deleted since init), flag
   it to the user rather than silently creating a new file.

## Step 3 — Update only what's affected

1. For each doc file in the list, open it and update only the sections
   relevant to the actual change. Do not rewrite unrelated sections and
   do not regenerate the whole file from scratch.
2. Always update `CHANGELOG.md` with a dated entry summarizing what
   changed, using whatever category headers AGENTS.md/CHANGELOG.md
   already use (Added/Changed/Fixed/etc.).
3. If a change has no documentation impact, do not touch any file for
   it — but include it in the final report as "no doc update needed"
   with a one-line reason.
4. Never fabricate details. If something can't be determined from the
   code (e.g. business rationale), leave the existing text or mark the
   gap explicitly rather than guessing.
5. Use repository-relative paths (e.g. `src/api.ts`) everywhere you
   reference files — never absolute paths or `file://` URIs.

## Step 4 — Report

End with a short summary, not a wall of diffs:
- Files updated, and what changed in each (one line per file)
- Changes found that needed no doc update, and why
- Any doc file the mapping pointed to that doesn't exist yet — ask
  whether to create it now or skip

## What this skill does NOT do

- It does not run on its own after every commit — it only runs when the
  user invokes it.
- It does not replace a CI check. It fixes drift when called; it doesn't
  prevent drift from happening. Recommend a CI docs-check (see the repo's
  AGENTS.md or ask the user if one exists) as the automatic enforcement
  layer — this skill is the manual/on-demand repair tool.
