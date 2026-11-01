---
name: gt-shepherd
description: Pair inside a Herdr space through Neovim, Hunk, and Shell. Use for /gt-shepherd or requests for shepherd mode. Stay active until stopped, including after compaction. Requires HERDR_ENV=1.
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

`gt-shepherd mode active. Skill: <skill dir>. Root: <project root>. View: <agent:...>. Hunk base: <ref> because <reason>. Panes: agent <id>, hunk <id>, nvim <id>, shell <id>.`

If you lose these rules, read `<skill dir>/SKILL.md` again. Then rerun the Start steps.

## Start

Run `<skill dir>/scripts/shepherd-layout` with no arguments. Report its returned view.
Add `--root <dir>` only for another project or worktree.
The helper checks Herdr context, finds owned panes, and creates the default view.
It handles routine setup. Do not inspect scripts or read tool skills before starting.
Use `--help` when a command fails or its options matter.

Fresh sessions show `agent:shell`, including when the repository has changes.
Resume preserves the current view, manual widths, focus, and custom arrangements.
The helper creates and starts tools only when needed.
Hidden tools keep running in a shelf owned by the agent tab.
The shelf label is `shepherd:shelf:<agent tab id>`. Never focus it.
Other tabs have separate tools and shelves.

Run helpers with absolute paths:

- `shepherd-layout` starts, resumes, reports, and changes views.
- `shepherd-nvim` reads and drives the shared editor.

The first shown tool splits the agent pane. Invoking this skill authorizes that split.
The helper never moves the agent pane or rearranges unrelated panes.
It names a new single-tab space after the project folder and its tab `shepherd`.
Existing names stay unchanged on resume.

Herdr, Hunk, and Neovim use local sockets. Request socket access when sandboxed.
A socket error does not mean the tool stopped. Do not start another copy.
For other Herdr work, use its skill or read `herdr --skill`.

## Views

Two columns have equal widths. Three columns have equal thirds.
Changing tools preserves widths. Changing column count restores equal widths.
Tools appear left to right as Neovim, Hunk, Shell, after the agent.

| View | Purpose | Toggle target |
|---|---|---|
| `agent:shell` | Default. Commands, tests, builds, and servers. | `agent:hunk:shell` |
| `agent:nvim` | Source inspection and explanation. | `agent:nvim:shell` |
| `agent:hunk` | Review a change or PR. | `agent:nvim:hunk` |
| `agent:hunk:shell` | Commands and their diff effects. | `agent:shell` |
| `agent:nvim:shell` | Source edits and commands. | `agent:nvim` |
| `agent:nvim:hunk` | Source edits and diff inspection. | `agent:hunk` |

Toggle twice restores the view. Cycle follows each three-row group in table order.
Human choices remain until the task changes or the human requests another view.

### Select views deliberately

Use the view that serves the user's current task.

- Review requests select `agent:hunk`. An empty diff is a valid review result.
- Source inspection selects `agent:nvim`. Show the relevant file with `shepherd-nvim show`.
- Editing with commands uses `agent:nvim:shell`.
- Editing with diff inspection uses `agent:nvim:hunk`.
- File changes update Hunk without changing the view.
- Initialization and resume never replace a recognized view.
- Do not switch repeatedly within one task or undo the human's choice.
- The helper blocks view changes while the human types in Neovim.
- State each switch and its reason in chat.

### Commands

- Start or resume: `shepherd-layout`. This replaces the old `auto` command.
- Select: `shepherd-layout <view>`.
- Review with a chosen base: `shepherd-layout agent:hunk --base <ref>`.
- Inspect: `shepherd-layout status`. It changes nothing and never waits for Hunk registration.
- Toggle: `shepherd-layout toggle`. Herdr key: `prefix+m`.
- Cycle: `shepherd-layout cycle`. Herdr key: `prefix+t`.

The Herdr prefix is `Ctrl+h`. `prefix+c` creates spaces. `prefix+Shift+c` creates tabs.
New spaces inherit the directory. Space and tab creation skip name prompts.
Creating a space opens a shell. Invoke this skill there to start Shepherd.

## Hunk setup

Shell startup does not launch Hunk, fetch Git refs, inspect PRs, or load Hunk guidance.
First use starts Hunk automatically, using the branch upstream or `HEAD` when none exists.
Pass `--base <ref>` for reviews that need another comparison.
The helper validates the base and tool roots before changing panes.
Its report distinguishes file counts, `not-started`, and `unknown`.
Unknown never means an empty diff and never selects a view.

Before the first Hunk review action, run `hunk skill path` and read the returned file.
Read it once when needed, including after losing those rules during compaction.
Skip it for shell work and routine layout commands.

## Choose the Hunk base

Show the diff the user cares about now. Choose the base from context.

| Context | Base |
|---|---|
| Review of an open PR | `git merge-base <PR head> origin/<PR base branch>`. This matches GitHub. |
| Feature branch, also with pushed commits | Merge-base with the branch target. This shows the whole piece of work. |
| Long-lived branch that never merges | Its upstream, such as `origin/work`. This shows unpushed and uncommitted work. |
| Unclear | The open PR base, else `origin/HEAD`. |

- For branch or PR reviews, fetch the required refs once before choosing the base.
- Find an open PR and its base with `gh pr view --json number,baseRefName,headRefName`.
- Find the trunk with `origin/HEAD`. If it is unset, run `git remote set-head origin --auto`.
- If a base ref is missing, the clone may fetch only one branch.
  Check `git config --get-all remote.origin.fetch`.
- State the base and the reason in chat. Example: `Hunk shows work against origin/work: unpushed changes.`
- When the context changes, restart Hunk. `hunk session reload` stops watch mode.
  Quit it with `herdr pane send-keys <hunk pane> q`. Then select the view with `--base <base>`.
  When the task moves to another worktree, also quit Neovim. Check its `unsaved` list first.
  Then add `--root <worktree>`. The script fails while a tool runs in the old root.
  Quitting drops Hunk threads. Ask first when open threads exist.
  State the new base and the reason in chat.

Invoking this skill authorises you to start Hunk in the Hunk pane.
This overrides the Hunk rule that reserves interactive launch for the user.
Do not close panes you did not create.

## Resolve "this" and "that"

If the message or recent chat names the object, use that object.
Otherwise read live state before you answer:

- Neovim, when running: `shepherd-nvim read`. Use the selection first, then cursor line and scope.
- Hunk: `hunk session context --repo <root> --json`. Use it when the user mentions the diff, a comment, or a review.

If Hunk has not started, select `agent:hunk` before reading its session.
Read unsaved text with `shepherd-nvim buffer <file>` when Neovim runs.
Disk can differ from the editor.
Read state again on each request. The human moves between requests.

## Show, do not describe

Put the code in front of the human. If the tool is on the shelf, show it first.

- Neovim: `shepherd-nvim show <file> <line>`. It fails while the human types.
  Then wait, or ask before you use `--force`. Never open tabs or splits.
- Hunk: `hunk session navigate --repo <root> --file <path> --new-line <n>`.
- When reviewing completed edits, show Hunk. Its watch picks up file changes.
- To review another branch or PR, check it out in its own worktree. Then choose its base.
- Use Hunk highlights to point at exact expressions. Clear your stale highlights.

## Hunk comments

While Hunk runs, read comments before each action:
`hunk session comment list --repo <root> --type all --json`.
A user comment is new when no agent reply follows it in its thread.
Treat new comments as requests. Handle them before other work.

- Reply only inside the thread: `hunk session comment add --repo <root> --reply-to <note-id> --summary <text>`.
- Read comments again to verify the reply parent.
- Do not start new comment threads. Exception: the user asks you to annotate.

## Edit files

If Neovim has not started, edit on disk. Skip editor RPC and `checktime`.
Otherwise, the human can type at any time. Do not edit concurrently.

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
