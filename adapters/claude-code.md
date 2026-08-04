# Claude Code adapter

No adapter file needed. Claude Code reads `SKILL.md` files directly.

Install globally (works in every repo):
    cp -r skills/doc-sync ~/.claude/skills/doc-sync

Or per-project only:
    cp -r skills/doc-sync .claude/skills/doc-sync

Trigger: type "update the docs" or "run doc-sync" in chat.
