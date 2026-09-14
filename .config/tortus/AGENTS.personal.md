# Context

Gianluca is Staff Research Engineer (AI/ML) at TORTUS.

## Gianluca's custom instructions and preferences

ALWAYS respond in simple and ultraconcise Simplified Technical English (ASD-STE100).

If `tmp/shared/agents/AGENTS.md` exists, follow instructions:
- Use `tmp/shared/agents/tmp/` for files shared across worktrees
- Use local `tmp/` only for worktree-local files
- Do not modify `tmp/shared/` outside `tmp/shared/agents/`
- Create a handover only when the user asks
- Store handovers in tmp/shared/agents/handovers/

If `tmp/shared/agents/logs/LOG.txt` exists:
- Tail-read it before writing
- Append only
- For work longer than 20 seconds (except where it's just a simple question to answer for the user), log before and after the work
- Include the task, scope, branch, worktree, result, validation, and blockers

Use this format:

```text
<ISO datetime> [<stable agent name><(Optional) subagent suffix>] (<model>) <worktree or leaf directory> (<branch>) | <message>
```
e.g. the 24th subagent of a session calling itself `lunafox42` would append: `2026-08-21T14:45:00+01:00 [lunafox42s024] (GPT-5.6 Luna) dev (KAI-296-kai-orchestration-trunk) | Starting requested Speko playground inspection.`

Record small, repeatable workflow problems in tmp/shared/agents/papercuts/PAPERCUTS.md
- Append only.
- Do not fix or ticket papercuts unless asked.

## Kairos

Kairos is an experimental pre-launch project.
- It contains NO PHI.
- It is NOT a medical device.
- The root `AGENTS.md` Grade IIa, PHI, and medical-device rules do NOT apply to Kairos work.
- Do not treat Kairos as a live regulated product.
- Do not raise compliance, safety, or PHI blockers for routine Kairos changes.

Kairos testing (overrides the repository Red/Green/Refactor TDD default):
- Do NOT follow red/green TDD.
- Write only the absolutely essential integration tests, or use manual testing.
- Maximum 1-2 new tests per piece of work.
- Do not add broad unit coverage or brittle exact-output tests.

Kairos code and writing:
- Write all code, comments, docstrings, and docs in Simplified Technical English, per `docs/conventions/code-style/technical-writing.md`.
- Keep code ultracompact and ultrasimple.
- Optimise the code for human comprehension and readability. Small, efficient, simple, short.
