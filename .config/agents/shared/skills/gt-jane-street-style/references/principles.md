# Transferable coding principles

Use these principles with the project rules and the host-language idioms. They apply to static, gradual, dynamic, managed, and systems languages.

## Select the enforcement mechanism

Use the strongest simple mechanism that the language and project already support:

| Capability | Useful mechanisms |
| --- | --- |
| Strong static types | Algebraic data types, enums, sealed types, newtypes, exhaustive matching, result types |
| Gradual types | Tagged unions, typed records, protocols, strict checking, runtime boundary validation |
| C and similar systems code | Opaque structs, enums, tagged unions, constructors, status values, explicit ownership |
| Dynamic languages | Validated constructors, closed constants, explicit result shapes, assertions at trusted boundaries, focused tests |

Do not simulate a richer type system with fragile conventions. If a guarantee cannot be encoded, make it visible in the API, validate it at the boundary, and test it.

## 1. Treat the interface as the contract

**Rule:** A caller must understand the operation, valid input, output, failure modes, ownership, and effects without reading the implementation. Export only what callers need.

**Why:** A narrow contract reduces coupling. It lets the implementation change without spreading knowledge of its internal state.

**Judgment:** Do not add an interface layer for a private, stable detail. Add a boundary when it protects an invariant, supports multiple implementations, or separates ownership.

**C example:** Hide storage so callers cannot bypass cache invariants.

```c
/* Before: callers can change capacity without rebuilding entries. */
typedef struct {
    CacheEntry *entries;
    size_t capacity;
} Cache;

/* After: the header exposes the contract, not the representation. */
typedef struct Cache Cache;

/* Return NULL if allocation fails. */
Cache *cache_create(size_t capacity);
bool cache_contains(const Cache *cache, Key key);
void cache_destroy(Cache *cache);
```

## 2. Make invalid states hard to express

**Rule:** Model each valid state with only the data that belongs to it. Replace flag combinations, sentinel values, and string states with closed alternatives or validated values.

**Why:** One precise construction removes repeated checks. Invalid combinations fail at construction or during static analysis instead of deep in the program.

**Judgment:** Encode important, stable invariants. Do not build a complex type model for a local condition that one clear check handles better.

**Python example:** Each job state now has exactly its required data.

```python
from dataclasses import dataclass
from typing import TypeAlias

# Before: "running" with a result and an error is valid to Python.
@dataclass(frozen=True)
class LegacyJob:
    state: str
    result: bytes | None = None
    error: str | None = None

# After: invalid field combinations have no normal constructor.
@dataclass(frozen=True)
class Running:
    pass


@dataclass(frozen=True)
class Succeeded:
    result: bytes


@dataclass(frozen=True)
class Failed:
    error: str

JobState: TypeAlias = Running | Succeeded | Failed
```

## 3. Make expected failure explicit

**Rule:** Put recoverable failure in the function contract. Use the host language's normal result, option, status, error return, or documented exception mechanism. Never hide or discard failure.

**Why:** A visible failure path lets callers make a deliberate choice. It also distinguishes expected outcomes from broken invariants and process failures.

**Judgment:** `None` is good for one obvious absence. Use a richer error when callers need the cause. In exception-oriented languages, a precise exception can be clearer than a custom result wrapper.

**C example:** The status states why parsing failed. `port` is valid only on success.

```c
typedef enum {
    PARSE_PORT_OK,
    PARSE_PORT_EMPTY,
    PARSE_PORT_NOT_A_NUMBER,
    PARSE_PORT_OUT_OF_RANGE
} ParsePortStatus;

ParsePortStatus parse_port(const char *text, uint16_t *port);

bool configure_port(Config *config, const char *text)
{
    uint16_t port;
    ParsePortStatus status = parse_port(text, &port);
    if (status != PARSE_PORT_OK) {
        log_invalid_port(status);
        return false;
    }

    config->port = port;
    return true;
}
```

## 4. Prefer values with clear ownership

**Rule:** Prefer immutable inputs and returned results. If mutation is useful, keep it local, give it one clear owner, and do not surprise the caller.

**Why:** Shared mutation creates temporal coupling. A reader must know who can change a value and when. Owned local mutation keeps that reasoning inside one scope.

**Judgment:** Mutation is often the clearest tool for builders, buffers, caches, and hot loops. The problem is unclear ownership, not mutation itself.

**Python example:** The function no longer changes the caller's list.

```python
# Before: callers lose their original order.
def sorted_tags(tags: list[str]) -> list[str]:
    tags.sort(key=str.casefold)
    return tags

# After: input ownership stays with the caller.
def sorted_tags(tags: list[str]) -> list[str]:
    return sorted(tags, key=str.casefold)
```

## 5. Require every construct to earn its cost

**Rule:** Remove dead code, unused parameters, pass-through wrappers, speculative options, and abstractions with no clear purpose.

**Why:** Each construct adds a name, contract, and change point. Code that adds no information makes the real design harder to see.

**Judgment:** Keep a small helper when its name explains intent, when it isolates policy or effects, or when its boundary makes testing useful. Count concepts, not lines or callers.

**Python example:** The wrapper and unused option add no meaning.

```python
# Before
def format_user_name(user: User, options: dict[str, object] | None = None) -> str:
    return user.name.strip()

def display_name(user: User) -> str:
    return format_user_name(user, options=None)

# After
def display_name(user: User) -> str:
    return user.name.strip()
```

## 6. Use brevity to improve reading speed

**Rule:** Remove ceremony and repetition when the shorter form preserves meaning. Stop before the code becomes compressed or indirect.

**Why:** Readers can understand one direct expression faster than control flow that only reconstructs that expression. Dense code has the opposite effect.

**Judgment:** Prefer a named intermediate when it states a domain concept, exposes units, or makes a complex condition reviewable. Avoid nested expressions and code golf.

**C example:** The branches only convert a Boolean expression back into a Boolean.

```c
/* Before */
bool job_is_ready(const Job *job)
{
    if (job->state == JOB_READY) {
        return true;
    } else {
        return false;
    }
}

/* After */
bool job_is_ready(const Job *job)
{
    return job->state == JOB_READY;
}
```

## 7. Make control flow and effects explicit

**Rule:** A reader must see where I/O, mutation, allocation, retries, locking, and failure can occur. Prefer direct calls and typed functions over magic, hidden work, implicit coercion, or clever indirection.

**Why:** Hidden effects break local reasoning. Clever mechanisms also make debugging and change impact harder to predict.

**Judgment:** Abstraction can hide mechanics, but its name and contract must reveal the effect that matters to the caller.

**C example:** The macro can evaluate an argument more than once. The function cannot.

```c
/* Before: CLAMP(next_value(), 0, 10) can call next_value more than once. */
#define CLAMP(value, low, high) \
    ((value) < (low) ? (low) : ((value) > (high) ? (high) : (value)))

/* After: evaluation and accepted types are explicit. */
static inline int clamp_int(int value, int low, int high)
{
    if (value < low) return low;
    if (value > high) return high;
    return value;
}
```

## 8. Handle the full input domain

**Rule:** Define behaviour for every valid input. Match every member of a closed set. Do not use a catch-all that hides a new case.

**Why:** Exhaustive code turns model changes into visible work. Partial code delays the discovery until runtime, often far from the cause.

**Judgment:** A catch-all is correct for a genuinely open external domain. For a closed internal domain, list the cases and make impossible inputs fail loudly.

**C example:** No `default` means a strict compiler can report a new enum member. The final abort still handles invalid integer values.

```c
const char *method_name(HttpMethod method)
{
    switch (method) {
    case HTTP_GET:
        return "GET";
    case HTTP_POST:
        return "POST";
    }

    abort();
}
```

## 9. Use predictable, intent-revealing names

**Rule:** Follow the host language's casing and vocabulary. Name domain roles, effects, units, and failure behaviour. Use the same word for the same operation.

**Why:** Predictable names reduce search and memory cost. Intent names survive representation changes; type-encoded names do not.

**Judgment:** Short names are good in a small, conventional scope. Longer names are useful at wide or ambiguous boundaries. Avoid noise such as `data`, `object`, `manager`, and container type names when they add no distinction.

**Python example:** The new names state roles and lookup structure.

```python
# Before
user_list = load_users()
user_dict = {user_object.id: user_object for user_object in user_list}

# After
users = load_users()
users_by_id = {user.id: user for user in users}
```

## 10. Derive mechanical code from one source

**Rule:** Generate routine equality, ordering, hashing, representation, validation, and serialization when an established project mechanism can do it correctly.

**Why:** Hand-written copies drift when the data model changes. One source of truth makes the routine behaviour complete and consistent.

**Judgment:** Do not add a generator or dependency for a trivial stable type. Generated code must remain reviewable, reproducible, and compatible with the required wire format.

**Python example:** The data declaration now owns construction, comparison, and representation.

```python
from dataclasses import dataclass

# Before
class Point:
    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y

    def __eq__(self, other: object) -> bool:
        return type(other) is Point and (self.x, self.y) == (other.x, other.y)

    def __repr__(self) -> str:
        return f"Point(x={self.x!r}, y={self.y!r})"

# After
@dataclass
class Point:
    x: int
    y: int
```

## 11. Keep automated checks strict and useful

**Rule:** Treat compiler, type-checker, linter, formatter, sanitizer, and test findings as defects or explicit decisions. Fix the cause. Keep suppressions narrow and justified.

**Why:** A clean signal makes new warnings visible. A noisy baseline teaches maintainers to ignore the tool that could catch a real defect.

**Judgment:** Do not enable a repository-wide rule and repair unrelated history during a focused change. Apply the strongest existing checks to changed code. Propose broader strictness as separate work.

**C example:** Match the index type to the collection size instead of suppressing a signedness warning.

```c
/* Before */
for (int index = 0; index < item_count; ++index) {
    process(items[index]);
}

/* After: item_count is size_t. */
for (size_t index = 0; index < item_count; ++index) {
    process(items[index]);
}
```

## 12. Keep examples and contracts near their owner

**Rule:** Document public guarantees, constraints, effects, ownership, and failure. Test important behaviour with small examples near the owning module or component. Do not comment on mechanics that the code already states.

**Why:** Contracts and examples answer different questions. The contract tells callers what they can rely on. Tests show that the important cases remain true.

**Judgment:** Follow the project's test layout. “Near” means easy to discover and maintained by the same owner; it does not require the same source file.

**Python example:** The contract states the boundary case. The table makes that case visible.

```python
import re

import pytest


def slugify(text: str) -> str:
    """Join lowercase ASCII words with hyphens. Return "" if there are no words."""
    words = re.findall(r"[A-Za-z0-9]+", text)
    return "-".join(word.lower() for word in words)

@pytest.mark.parametrize(
    ("text", "expected"),
    [
        ("Hello, world!", "hello-world"),
        ("  two   spaces  ", "two-spaces"),
        ("***", ""),
    ],
)
def test_slugify(text: str, expected: str) -> None:
    assert slugify(text) == expected
```

## Apply the principles together

Start with the data model and boundaries. A precise state model can remove defensive checks, error branches, mutation, and tests for impossible combinations. Then simplify the remaining control flow and names.

Use this final test: after the change, can a reader state the valid states, failure paths, effects, and ownership with less effort? If not, the refactor did not improve the design.
