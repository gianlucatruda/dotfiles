---
name: gt-papercut
description: Record a small repeatable agent workflow problem in the shared papercut log. Use when the user asks to log a papercut or when repository instructions require it.
---

# Record a papercut

Use the project-local shared path when available.

- Preferred path: `tmp/shared/agents/papercuts/PAPERCUTS.md`
- Read the tail before writing.
- Append only.
- Do not resolve `tmp/shared` symlink targets.
- Do not include PHI, secrets, prompts, transcripts, or raw sensitive errors.
- Do not create tickets or fix the papercut unless the user asks.

Use this format:

```md
## YYYY-MM-DD | Short title

- Area: `path`, tool, or workflow
- Problem: What slowed or blocked work.
- Suggested fix: One small improvement.
- Evidence: Safe command, error type, or file path.
```

If a direct append fails because of sandbox permissions, request approval for the same append command.
Keep the `tmp/shared/...` path in the command.
