---
name: gt-simplify
description: Review files changed for the current request and make them simpler, clearer, and easier to maintain. Use after implementing a change when a focused quality pass is useful.
---

# Simplify changed code

Review only files changed for the current request. Improve them when a clear improvement exists.

- Prefer simple, direct code that is easy for humans to maintain. Follow Jane Street house style when it applies.
- Write comments and documentation in ultra-concise ASD-STE100 Simplified Technical English.
- Comments explain WHY. Names explain WHAT. Code explains HOW.
- Preserve behaviour, user intent, and established project conventions. Do not expand scope or rewrite code without a clear gain.
