---
name: gt-shepherd
description: Pair with the human inside a Herdr space through Neovim, Hunk, and a shell pane. Use when the user runs /gt-shepherd or asks for shepherd mode. The mode stays on until the user ends it, also after compaction. Requires HERDR_ENV=1.
---

# Shepherd a Herdr space

You own this Herdr space. The human is an engineer who pairs with you in it.
You work in shared tools, not only in chat.
The human can inspect your work, take control, or ask for help at any time.

- Neovim: shared edits. One window, one tab, opened from the project root.
- Hunk: diff review and decisions. The base depends on context.
- Shell: commands the human should see, such as tests, builds, and servers.

## Stay in the mode

Shepherd mode stays on until the user says to stop.
It stays on after compaction, summaries, and context resets.
Put this line in every summary, with real values:

`gt-shepherd mode active. Skill: <skill dir>. Root: <project root>. Layout: <develop|review>, slot <tool>. Hunk base: <ref> because <reason>. Panes: agent <id>, hunk <id>, nvim <id>, shell <id>.`

If you lose these rules, read `<skill dir>/SKILL.md` again. Then rerun the Start steps.

## Start

1. Check `test "${HERDR_ENV:-}" = 1`. If it fails, say so and stop.
2. Load Hunk rules. Run `hunk skill path` and read the returned file.
3. Choose the Hunk base. See below.
4. Run `shepherd-layout develop --base <base>`.
5. Report the layout and the Hunk base in chat.

Two helpers live in this skill's `scripts/` directory. Run them with absolute paths.

- `shepherd-layout` sets up, shows, and changes the panes. Read its `--help` once.
- `shepherd-nvim` reads and drives Neovim. Read its `--help` once.

`shepherd-layout` is idempotent. Rerun it after compaction or when panes look wrong.
It creates missing panes and starts tools only in panes at a shell prompt.
It never moves your pane. Its first shown tool splits your pane once.
Invoking this skill asks for that split.

Herdr, Hunk, and Neovim talk through local sockets.
In a sandbox, request access to these sockets.
A socket error does not mean the tool stopped. Do not start a second copy.
For other Herdr work, use the `herdr` skill if present. Otherwise read `herdr --skill`.

## Layout

Two layouts exist. Each has one slot that shows one tool at a time.
Hidden tools wait in the tab labelled `shepherd:shelf`. They keep running. Never focus that tab.

| Layout | Columns | Slot tools | The human is |
|---|---|---|---|
| `develop`, mode 1 | Agent, Neovim, slot | Hunk or Shell | building: editing, developing, testing |
| `review`, mode 2 | Agent, slot | Hunk or Neovim | reading: reviewing, learning |

| Layout and slot | Use it to |
|---|---|
| `develop hunk` | Edit code and watch the diff grow. This is the default. |
| `develop shell` | Edit code and run tests, builds, or servers. |
| `review hunk` | Read a whole diff or PR. Discuss it in Hunk threads. |
| `review nvim` | Read source in depth. Explain code or walk a call path. |

### Switch proactively

Show the tool that best serves the next step. Do not wait for a request.

- Before you run a command the human should watch, show `develop shell`.
- After a command, show `develop hunk` again when the diff is the next topic.
- When the human starts to review a PR or a finished change, show `review hunk`.
- When you explain code that is not in the diff, show `review nvim`.
- When the human starts to edit or asks for changes, show `develop hunk`.
- Do not switch while the human types in Neovim. Check `shepherd-nvim read` first.
- Do not switch back and forth within one step. One switch per change of task.
- State each switch and its reason in chat. Example: `Switched to review hunk to read the PR.`
- If the human switches back, keep their choice for the current task.

### Commands

- Set: `shepherd-layout <layout> <slot>`. Example: `shepherd-layout develop shell`.
- Toggle the layout: `shepherd-layout toggle`. Next slot tool: `shepherd-layout cycle`.
- Check: `shepherd-layout status`. The human can switch with Herdr keys.
  `prefix+m` toggles the layout. `prefix+t` cycles the slot.
  Run `status` before you rely on the current layout.
- Never move or split your own pane unless the user directly asks you to.

## Choose the Hunk base

Show the diff the user cares about now. Choose the base from context.

| Context | Base |
|---|---|
| Review of an open PR | `git merge-base <PR head> origin/<PR base branch>`. This matches GitHub. |
| Feature branch, also with pushed commits | Merge-base with the branch target. This shows the whole piece of work. |
| Long-lived branch that never merges | Its upstream, such as `origin/work`. This shows unpushed and uncommitted work. |
| Unclear | The open PR base, else `origin/HEAD`. |

- Run `git fetch --quiet origin` first.
- Find an open PR and its base with `gh pr view --json number,baseRefName,headRefName`.
- Find the trunk with `origin/HEAD`. If it is unset, run `git remote set-head origin --auto`.
- If a base ref is missing, the clone may fetch only one branch.
  Check `git config --get-all remote.origin.fetch`.
- State the base and the reason in chat. Example: `Hunk shows work against origin/work: unpushed changes.`
- When the context changes, restart Hunk. `hunk session reload` stops watch mode.
  Quit it with `herdr pane send-keys <hunk pane> q`. Then run `shepherd-layout <layout> <slot> --base <base>`.
  Quitting drops Hunk threads. Ask first when open threads exist.
  State the new base and the reason in chat.

Invoking this skill authorises you to start Hunk in the Hunk pane.
This overrides the Hunk rule that reserves interactive launch for the user.
Do not close panes you did not create.

## Resolve "this" and "that"

If the message or recent chat names the object, use that object.
Otherwise read live state before you answer:

- Neovim: `shepherd-nvim read`. Use the selection first, then the cursor line and scope.
- Hunk: `hunk session context --repo <root> --json`. Use it when the user mentions the diff, a comment, or a review.

Read unsaved text with `shepherd-nvim buffer <file>`. Disk can differ from the editor.
Read state again on each request. The human moves between requests.

## Show, do not describe

Put the code in front of the human. If the tool is on the shelf, show it first.

- Neovim: `shepherd-nvim show <file> <line>`. It fails while the human types.
  Then wait, or ask before you use `--force`. Never open tabs or splits.
- Hunk: `hunk session navigate --repo <root> --file <path> --new-line <n>`.
- After you change code, show the change in Hunk. The watch picks up edits.
- To review another branch or PR, check it out in its own worktree. Then choose its base.
- Use Hunk highlights to point at exact expressions. Clear your stale highlights.

## Hunk comments

Before each action, read all comments: `hunk session comment list --repo <root> --type all --json`.
A user comment is new when no agent reply follows it in its thread.
Treat new comments as requests. Handle them before other work.

- Reply only inside the thread: `hunk session comment add --repo <root> --reply-to <note-id> --summary <text>`.
- Read comments again to verify the reply parent.
- Do not start new comment threads. Exception: the user asks you to annotate.

## Edit files

The human can type in Neovim at any time. Do not edit concurrently.

1. Run `shepherd-nvim read`. Check `mode` and `unsaved`.
2. If the human is in insert mode, wait or ask.
3. If the target file has unsaved edits, ask before you change it.
4. Edit on disk with your own tools.
5. Run `shepherd-nvim checktime`. Neovim then reloads the clean buffers.

## Command receivers

Shell pane commands and Neovim RPC run outside your tool sandbox.
They get no separate harness approval.

- Apply the approval rules of your own tools to every pane command.
- Never use a pane or Neovim to bypass a sandbox or an approval.
- Use only `shepherd-nvim` commands for Neovim. No raw `--remote-expr`, `--remote-send`, or `:!`.
- Before you send to the shell pane, check it for a foreground job.
- Read results with `herdr pane read <id> --source recent-unwrapped`.
- Use your own tools for quick reads. Use the pane for output the human should see.

## Exchange of controls

Use the aviation handover. One party has control of a tool at a time.

- To hand over, show and focus the tool. Say `You have controls: <tool>.`
- When the human says `I have controls`, do not send input to that tool.
- When the human says `You have controls`, reply `I have controls: <tool>.` Then act.
- If the human asks you to act while they have controls, confirm the handover first.
- Read state at any time. Reading does not take control.

## Workers

Invoking this skill authorises worker agents in new tabs of this space.

- Give each writing worker its own worktree. Use the repository's worktree tool if one exists.
- Readers can share your checkout.
- Pass workers the repository instructions, verification needs, and the user's authorisations.
- Collect worker results. Show the combined result in Neovim and Hunk.

## Report in chat

Keep chat short. In each reply, state the context you used and the effects you made.

- Context: `You seem to be looking at outer() in src/app.lua:42.`
- Shown: `I opened src/app.lua:42 in Neovim to show the retry loop.`
- Written: `I explained the timeout default in a Hunk reply on src/app.lua:42.`
- Ran: `I ran the unit tests in the shell pane. 2 failed.`

Name each object you used. Do not report actions you did not take.
