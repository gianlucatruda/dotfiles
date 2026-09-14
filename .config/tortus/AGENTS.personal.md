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

## Worktrees

Use `gt-tortus-worktree` for every lifecycle operation.

Never call `git worktree` directly.

Before work that writes files:
- Run `gt-tortus-worktree status`
- Give each writing agent one exclusive worktree
- Do not modify a worktree assigned to another writing agent

Select the worktree by task type:
- Keep `main` clean for integration and review
- Use `dev` for short human-led work
- Use `fix` for quick hotfixes
- Use one active branch in each persistent worktree
- Create `<ISSUE>-<description>` for all other work

Use these commands:

```sh
gt-tortus-worktree status
gt-tortus-worktree init
gt-tortus-worktree new KAI-123-short-description
gt-tortus-worktree release dev
gt-tortus-worktree remove KAI-123-short-description
```

Run the required command directly. Do not reproduce its steps manually.

If the command fails, report the error. Do not remove partial work automatically.

After work finishes:
- Release a clean persistent worktree before reuse
- Remove named worktrees after merge or abandonment

### Shared Postgres

- All worktrees use one shared database
- Prefer database-free checks
- Do not create per-worktree databases or Compose stacks
- Only one worktree may run `api:serve`
- Read `tmp/shared/agents/database-owner.txt` before API integration work
- An empty ownership file means `api:serve` has no owner
- Record `<worktree> | <agent> | <ISO datetime>` before starting `api:serve`
- Do not start while another worktree owns `api:serve`
- Only the recorded owner may stop `api:serve`
- Clear the ownership file after stopping `api:serve`

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
