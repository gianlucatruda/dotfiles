---
name: gt-hunk-review
description: Review a live Hunk diff with inline comments and highlights. Use when the user has Hunk open or asks to annotate a diff in Hunk.
---

# Review with Hunk

The user owns the interactive Hunk window. Do not run `hunk diff`, `hunk show`, or other interactive Hunk commands.

First run `hunk skill path`, then read the returned `SKILL.md`. It is bundled with the installed Hunk version and defines the current session commands.

- Use `hunk session review --repo . --json` before reading raw patches.
- Use `--include-patch` only for files that need it.
- Navigate before adding a note.
- Add concise inline comments for important intent, risks, or follow-ups.
- Use highlights only to point to an exact expression; pair them with a comment when the explanation must remain.
- If no live session exists, ask the user to run `hunk diff` and keep it open.
