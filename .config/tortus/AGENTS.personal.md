# Personal instructions

Gianluca is Staff Research Engineer in AI/ML at TORTUS.
These instructions apply only to the TORTUS monorepo.
Never log or expose PHI, secrets, prompts, transcripts, or raw sensitive errors.

## Machines

- Identify the host with `scutil --get LocalHostName` before Docker or GUI work.
- `gianluca-macbook` is the main MacBook. It uses Docker Desktop.
- `TORTUS-Mac-Studio-2023` is Stu, the headless office Mac Studio. It uses Colima.
- Confirm unfamiliar hostnames before machine-specific operations. Continue independent work.

On Stu:

- Never launch Docker Desktop or GUI apps.
- Check `colima status`. If stopped, run `colima start`.
- Enable Colima login startup only when requested: `brew services start colima`.
- `/var/run/docker.sock` points to Docker Desktop. Do not replace it.
- Export the Colima socket for Docker CLI and SDK commands:

```sh
export DOCKER_HOST="unix://$HOME/.config/colima/default/docker.sock"
```

- Confirm `docker info` succeeds before `pnpm dev setup` or worktree setup.
- Distinguish a stopped runtime from sandbox access failures.

## Shared coordination

- Use `tmp/shared/...` project paths for shared files. Never use the symlink target.
- Keep the shell working directory inside the worktree. Never `cd` into `tmp/shared`.
- Never redirect shell output into `tmp/shared`. Use file tools or `gt-agent-log`.
- Use `tmp/shared/agents/tmp/` for files shared across worktrees.
- Use local `tmp/` for worktree-local files.
- Do not modify shared files outside `tmp/shared/agents/` without explicit user authorisation.
- Create handovers only when requested. Store them in `tmp/shared/agents/handovers/`.
- Name handovers `YYYY-MM-DD_HH-MM_HANDOVER.md` in local time.

Sandbox permissions still apply to writes through symlinks.
If one tool cannot follow a symlink, try another through the same path.
Request approval for the same project-path operation when required.

## Logging

Use `gt-agent-log` for `tmp/shared/agents/logs/LOG.txt`.
Run `gt-agent-log --help` for the entry format and model ID rules.

- For tasks over 20 seconds, log before and after. Skip simple questions.
- Before each append, run `gt-agent-log tail tmp/shared/agents/logs/LOG.txt`.
- Run `gt-agent-log name` once per session. Use that name for every entry.
- Give subagents your name with a sequential suffix, for example `amberlynx58s001`.
- Start entries state the task, scope, and code or network use.
- Finish entries state the result, changed files, validation, and blockers.
- Never edit, truncate, rename, or recreate the log.
- Report a missing log. Continue independent work.

```sh
gt-agent-log add tmp/shared/agents/logs/LOG.txt --agent amberlynx58 --model claude-opus-5-5 'Started KAI-123 review.'
```

## Papercuts

Record repeatable workflow problems with the `gt-papercut` skill.

## Tooling boundaries

- Find the canonical source before proposing tooling changes.
- Change synced tooling only when the user explicitly requests that change.
- Never rewrite helpers or bypass guards to complete another task.
- Report helper restrictions and request an authorised path.
- Report the exact operation performed. Disclose every tooling change.

## Worktrees

- Use `gt-tortus-worktree` for every lifecycle operation. Never call `git worktree` directly.
- Never reproduce its lifecycle steps manually.
- Run `gt-tortus-worktree status` before work that writes repository files.
- Give each writing agent one exclusive worktree.
- Never modify another writing agent's worktree.
- Keep `main` clean for integration and review.
- Use `dev` for short human-led work and `fix` for hotfixes.
- Use one active branch per persistent worktree.
- Use `<ISSUE>-<description>` for other worktrees.
- Report failures. Never remove partial work automatically.
- Release clean persistent worktrees before reuse.
- Remove named worktrees after merge or abandonment.

```sh
gt-tortus-worktree status
gt-tortus-worktree init
gt-tortus-worktree new KAI-123-short-description
gt-tortus-worktree release dev
gt-tortus-worktree remove KAI-123-short-description
```

## Shared Postgres

All worktrees share the existing databases. Prefer database-free checks.
Never create per-worktree databases or Compose stacks.
Only one worktree may run `api:serve` or `kairos-api:serve` against shared databases.

Before starting API services:

1. Read `tmp/shared/agents/database-owner.txt`. If not empty, another worktree owns the services. Stop.
2. Run `mkdir tmp/shared/agents/database-owner.lock`. If it fails, stop.
3. Read the ownership file again. If not empty, remove your lock and stop.
4. Write `<worktree> | <agent> | <ISO datetime>` to the ownership file.

Hold the lock while the server runs.
Only the owner may stop the server or release ownership.
To release, confirm no server remains. Clear the ownership file. Remove the lock.
Never remove another agent's lock or assume a lock is stale.

## Kairos

Kairos is an experimental pre-launch project. It contains no PHI.
It is not a medical device.
Root Grade IIa and medical-device rules do not apply to routine Kairos changes.
Do not raise compliance or PHI blockers for routine Kairos work.

Testing overrides repository Red/Green/Refactor defaults:

- Do not follow red/green TDD.
- Use essential integration tests or manual testing.
- Add at most two tests per piece of work.
- Avoid broad unit coverage and brittle exact-output tests.
- For one API spec, use `pnpm nx test kairos-api -- --testFile=<spec-path> --no-tui`.
- Put `NX_WORKSPACE_DATA_DIRECTORY`, `NX_CACHE_DIRECTORY`, and `UV_CACHE_DIR` in task-specific `/private/tmp` directories.
- Inspect Nx environment loading before diagnosing missing credentials.
- Missing shell variables do not prove missing application credentials.
- Edit watched files only between simulation rounds. Edits restart the API.

Keep code compact, simple, and easy for humans to read.
Follow `docs/conventions/code-style/technical-writing.md` for comments, docstrings, and documentation.
