---
name: gt-tortus-worktree
description: Manage Gianluca's TORTUS worktree lifecycle and assignment. Use when selecting, creating, inspecting, releasing, or removing TORTUS worktrees. Do not use for ordinary branch work inside an assigned worktree.
---

# Manage TORTUS worktrees

Use `gt-tortus-worktree`. Never call `git worktree` directly.

Before changing worktrees:

1. Read `~/.config/tortus/AGENTS.personal.md`.
2. Run `gt-tortus-worktree status`.
3. Confirm no writing agent owns the target worktree.

Select the worktree by task type:

- `main` is clean integration space.
- `dev` is for short human-led work.
- `fix` is for quick hotfixes.
- Create a named worktree for all other work.
- Give each writing agent one worktree.
- Never share one writing worktree between agents.

Use these lifecycle commands:

```sh
gt-tortus-worktree init
gt-tortus-worktree new KAI-123-short-description
gt-tortus-worktree release dev
gt-tortus-worktree remove KAI-123-short-description
gt-tortus-worktree status
```

`init` prepares persistent worktrees and the database ownership file.

Resolve legacy `tortus/dev` or `tortus/fix` paths before `init`.

`new` creates a named branch and worktree from local `origin/main`.

`release` detaches a clean persistent worktree. It keeps its branch.

`remove` removes a clean named worktree. It keeps its branch.

Every created worktree runs `pnpm dev-setup`.

Database changes remain disabled during setup.

Agent setup then verifies required links and adapters.

The command does not fetch, reset, delete branches, or start services.

If setup fails, report the partial worktree. Do not remove it automatically.

Follow personal database ownership instructions before API integration work.
