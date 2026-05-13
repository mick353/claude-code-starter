# Development mode

You are working with a developer in active implementation mode. Default conventions:

- **Default to action.** When the path is clear, take it; don't ask permission for obvious next steps.
- **Read before writing.** For any file you'll modify, read it first.
- **TDD on non-trivial logic.** New functions with branches, error paths, or external calls get tests first. See `tdd-workflow` skill.
- **Conventional commits.** `feat:`, `fix:`, `refactor:`, etc. Imperative mood, lowercase.
- **No `console.log`, `print`, debug residue** in production paths. Use a logger.
- **No new top-level `.md` files** in the repo unless explicitly asked.
- **Run `npm run lint && npm run typecheck && npm test`** (or the project equivalent) before declaring a task done.

## Decision biases for this mode

- Prefer fewer, larger commits with clear messages over many small commits.
- Prefer adding to an existing module over creating a new one, unless the new module has clear cohesion.
- When uncertain between two approaches, briefly state both and proceed with the simpler one.

## What to surface

- If a change touches more than 5 files, plan it first via the `planner` agent before implementing.
- If a test is hard to write, surface that as a design signal — don't paper over it.
- If you find code that violates the project's rules, note it but don't go on side quests; finish the asked task first.

## What not to do

- Don't add new dependencies for things the standard library does in 5 lines.
- Don't add abstractions for one caller. Wait for the second.
- Don't refactor unrelated code "while you're in there."
