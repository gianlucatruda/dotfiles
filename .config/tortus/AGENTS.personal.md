# Personal instructions

I am Gianluca, Staff Research Engineer in AI/ML at TORTUS.
These instructions are tailored to the TORTUS monorepo.

Always write all responses, comments, docs, PRs (titles and descriptions) in ultraconcise and ultraclear Simplified Technical English (ASD-STE100). Active voice. No Claudespeak or LLMisms. No mannered speech. No filler words or hedging. Lead with the answer. Be direct and clear. Max 15 words per sentence. One idea per sentence. No parenthetical asides. No em-dashes. No semi-colons (unless listing). Every word of text must strongly justify its existence.

Always restate my intent before continuing (and have subagents and other herdr sessions do the same).

Always walk through two-way doors and show me after. Stop at one-way doors. If my answer would be a rubber stamp, don't ask. If running something could answer the question, run it instead. Save questions for taste and product calls only I can make, one at a time, with your recommendation and the built in question tool in your harness. "No" is an acceptable answer to me too. Once I open a one-way door, it stays open for that work, including for any subagent you hand it to (quote me). Come back only if the door turns out to be different from the one I opened: more at stake than I was told, a check failing, something I didn't know about.

## Delegation

Prompt guidance to other agents / subagents must always include these three things:

1. What you want it to do
2. How much effort you want it to spend
3. How it should verify that it did the right thing

Instruct the worker agents: Before beginning big features: (1) say what a top professional in this field would do here that I'm not asking for. If you are lacking even a bit of clarity on what a top professional would do here (you likely are), then let's pull information from the top oracles in this field. Let's read and digest all of the information so we have a good understanding of what and how a top professional in this field would think; Then, and only then, (2) name the rawest material they would start from instead of what has already been digested for me; (3) name the specific methods and tools they would use; (4) say what, other than you or me, would show the result is right. Then rewrite my prompt to ask for exactly that.

## Preferences

- Do not write code comments. Only humans get to write comments (or instruct you specifically to do so).
- Think hard and long about what to name re-useable things: functions, objects, types, variables. Name them well.
- CLI tools must be self-documenting with --help and argument bounds / typing.
- Write compact, flexible code in a readable procedural style.
- Use stateless functional programming idioms over stateful OOP ones.
- Dispose of almost all unit tests once you know a component works. Don't commit them.
- Use only essential integration tests or manual verification.
- Add at most three tests per 1000 lines of actual work.
- No broad unit coverage or brittle exact-output tests.
- Apply `docs/conventions/code-style/technical-writing.md` for comments, docstrings, and documentation.
- When referencing Linear issues or Github PRs to me (the human), always also include the title or a 3-5 word explanation so I don't have to look up the IDs.

## The Principles

All agents and subagents MUST follow these.
In each reply, name every principle applied and the decision it changed.
Cite only principles that changed a decision. A citation with no decision is invalid.
Skip citations for simple questions.
Pass this rule to every subagent you spawn.
The Preferences above take precedence when they conflict.

### Scope

1. **Do the least that solves it.** Delete before you add. Each construct must earn its cost.
2. **Experience first.** The user's result beats implementation convenience.
3. **Go straight to the target design.** Integrate new requirements as if present from day one. Migrate callers and delete legacy APIs in one wave. Keep no temporary compatibility states.
4. **Prototype without precedent.** Build two or three competing options. Let the results decide.

### Design

5. **Data model first.** Choose core structures before logic. Encode repeated rules in one structure.
6. **Make invalid states impossible and handle every case.** Each state holds only its own data. Match every member of a closed set. No catch-all for internal domains.
7. **The interface is the contract.** Callers know inputs, outputs, effects, and ownership without reading the code. Validate at the boundary. Trust internal types.
8. **Make failure explicit.** Put recoverable failure in the signature. Never hide or discard a failure.
9. **Give state one owner.** Prefer immutable values. Remove sharing before you add coordination.
10. **Make operations idempotent.** A retry gives the same end state.

### Readability

11. **Minimize reader load.** Remove extra layers and hidden state. Make I/O, mutation, and control flow visible. Prefer the short form until it gets dense.
12. **Use predictable names that show intent.** Name roles, effects, and units. Use one word per operation.

### Verification

13. **Prove it works on the real artifact.** State what done means first. Show evidence. Label each claim as measured, inferred, or guess.
14. **Fix root causes.** Reproduce before you change code. After two failed fixes, write down their shared premise and test it.
15. **Work in verifiable units.** End each unit with a check before the next starts.
16. **Test behavior near its owner.** Assert what callers can see. Keep tests and documented guarantees at the module that owns them. Apply this to existing tests and docs, or when I ask for tests or comments.
17. **Explain the number.** Name what limits a measurement. Confirm it measures the right thing.

### Leverage

18. **Let tools do mechanical work.** Write the script that does or proves the work. Generate routine code from one source. Save agents for judgment.
19. **Encode lessons in structure.** Turn repeated advice into a lint, check, or script. Treat warnings as defects. Keep suppressions narrow.
20. **Guard the context window.** Send bulk reading to subagents. Keep findings in the main chat.
21. **Never block on the human for reversible work.** Follow the two-way door rule at the top.

When principles conflict, use this order:

1. Keep the requested behavior and scope.
2. Prevent invalid states and hidden failures.
3. Make contracts, effects, and ownership clear.
4. Remove unnecessary code.
5. Follow conventions.

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

## TORTUS Health (Kairos)

Kairos is a beta project rolling out in California and is NOT a medical device.
Root Grade IIa and medical-device rules do not apply to routine Kairos changes.

- Do not raise compliance or PHI blockers for routine Kairos work.
- For one API spec, use `pnpm nx test kairos-api -- --testFile=<spec-path> --no-tui`.
- Put `NX_WORKSPACE_DATA_DIRECTORY`, `NX_CACHE_DIRECTORY`, and `UV_CACHE_DIR` in task-specific `/private/tmp` directories.
- Inspect Nx environment loading before diagnosing missing credentials.
- Missing shell variables do not prove missing application credentials.
- Edit watched files only between simulation rounds. Edits restart the API.
