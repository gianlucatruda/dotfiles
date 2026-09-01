---
name: gt-jane-street-style
description: "Audit or refactor code in any language with a correctness-first style: precise states, explicit failures, small interfaces, exhaustive cases, and clear brevity. Use when the user asks for Jane Street style, tighter code, type-driven design, or stronger invariants. Do not use for a generic review with no correctness, clarity, or simplicity goal."
metadata:
  upstream: https://github.com/zaydiscold/agent-skills/tree/main/skills/jane-street-house-style
---

# Correctness-first code

Apply the durable engineering principles behind the source skill to any language. Use the host language well. Do not impose a language-specific library, toolchain, file layout, naming scheme, or functional style.

Read [references/principles.md](references/principles.md) before an audit or refactor. It defines the principles, judgment rules, and examples.

## Priorities

Use this order when principles conflict:

1. Preserve the requested behaviour and scope.
2. Prevent invalid data, missed cases, and hidden failures.
3. Make intent, ownership, effects, and contracts clear.
4. Remove unnecessary code and ceremony.
5. Follow project and language conventions.

Correctness does not justify needless complexity. Brevity does not justify obscure code. Consistency does not justify a local regression.

## Workflow

1. Read the target code, callers, public contract, and local instructions.
2. Identify material risks against the twelve principles. Start with state models, failure paths, mutation, ownership, and exhaustiveness.
3. Select the smallest coherent change that fixes the root cause. Prefer a boundary or data-model fix when it removes downstream checks.
4. Preserve behaviour. State any necessary behaviour change before implementation.
5. Use existing checks when project instructions permit them. Do not add dependencies or enable repository-wide rules without a clear need and user authority.
6. Report only material findings and changes. Explain the invariant or reading burden that improved.

## Guardrails

- Adapt the mechanism to the language. Static types, runtime validation, ownership rules, tests, and small APIs can enforce the same principle.
- Keep an abstraction when it names a real concept, isolates policy, protects an invariant, or supports useful tests. A single caller is not proof that it is unnecessary.
- Use local mutation when it is clearer or measurably better. Keep its owner and lifetime obvious.
- Use exceptions when they are the host-language convention for the failure and callers have a clear handling boundary. Never swallow them.
- Follow the repository test layout. Keep tests close in ownership and purpose; physical colocation is optional.
- If the code is already clear and safe, say so. Do not manufacture findings or rewrite code to imitate another language.

## Reporting

Classify only real findings:

| Class | Meaning |
| --- | --- |
| Correctness | Can permit invalid data, miss a case, hide failure, or break ownership. |
| Clarity | Makes the contract, effect, data flow, or intent hard to understand. |
| Polish | A small, low-risk consistency improvement. |

Lead with correctness. Group related symptoms under their root cause. Do not require a fixed score or a twelve-row report.
