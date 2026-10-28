---
name: gt-hunk-review
description: Review a live Hunk diff with inline comments and highlights. Use when the user has Hunk open or asks to annotate a diff in Hunk.
---

# Review with Hunk

The user owns the interactive Hunk window. Do not run `hunk diff`, `hunk show`, or other interactive Hunk commands. Exception: in `gt-shepherd` mode, start Hunk in the separate Hunk pane and follow its comment rules.

First run `hunk skill path`, then read the returned `SKILL.md`. It is bundled with the installed Hunk version and defines the current session commands.

- Use `hunk session review --repo . --json` before reading raw patches.
- Use `--include-patch` only for files that need it.
- Navigate before adding a note.
- Add concise inline comments for important intent, risks, or follow-ups.
- Use highlights only to point to an exact expression; pair them with a comment when the explanation must remain.
- If no live session exists, ask the user to open the PR diff against trunk:

```bash
hunk diff "$(git merge-base HEAD origin/HEAD)" --watch --agent-notes
```

- `origin/HEAD` names the trunk, such as `origin/main`. If it is unset, run `git remote set-head origin --auto`.
- The diff includes commits and working changes since the branch left trunk.
