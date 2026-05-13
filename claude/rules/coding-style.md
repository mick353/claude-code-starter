# Coding Style

Always-on rules. Apply unless explicitly overridden by the project.

## File size

- **Functions:** prefer ≤ 40 lines. Past 60, look for a split.
- **Files:** prefer ≤ 300 lines. Past 500, refactor unless there's a strong reason (generated code, large config).

Long files compound badly with Claude — they consume context every time they're read and increase the chance of subtle changes in unrelated parts.

## Immutability and side effects

- Prefer immutable data structures by default. `const`, `readonly`, `tuple`, `frozen`, etc.
- Pure functions where possible. If a function mutates, name it accordingly (`updateX`, not `getX`).
- Mutation is fine when it's the right call (perf, idiomatic). Make it explicit, not accidental.

## Naming

- **Booleans** start with `is`, `has`, `should`, `can`. `isReady` not `ready`.
- **Functions** use verbs. `parseConfig`, not `config`.
- **Files** match their primary export's casing convention for the language (PascalCase for TS components, snake_case for Python modules, etc.).
- **No abbreviations** for non-obvious cases. `userRepository` over `userRepo` unless the abbreviation is truly idiomatic.

## What does *not* go in source

- Hardcoded secrets, API keys, tokens. Ever.
- `console.log`, `print`, `dbg!` in production paths. Use a logger.
- Commented-out code. Delete it; git remembers.
- TODOs without an owner and a date. `// TODO(jane, 2026-06): handle empty list` not `// TODO`.

## Imports and exports

- Named exports preferred over default exports (better autocomplete, easier refactor).
- One feature per file when it can fit; co-locate small utilities.
- Don't barrel-export from deep trees. `index.ts` files that re-export everything obscure dependencies.

## Comments

- Comment **why**, not what. Code shows what.
- Function-level docstrings for any function with non-obvious contract or invariants.
- No comments that restate the next line.

## Errors

- Throw structured errors, not strings. `throw new ValidationError(...)` not `throw "bad input"`.
- Catch narrowly. `catch (e: ValidationError)` over `catch (e)` when the language supports it.
- Don't swallow exceptions silently. If you really must, comment why.

## When this rule conflicts with itself

The project's own conventions (in `CLAUDE.md` or a project rules file) win over these defaults. State the conflict in your output, then follow the project rule.
