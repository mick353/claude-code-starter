# <PROJECT NAME>

<one-line description of what this project is>

## Stack

- **Runtime:** <e.g. Node 22, Python 3.12, Go 1.23>
- **Framework:** <e.g. Next.js 15 App Router, FastAPI, Gin>
- **Database:** <e.g. PostgreSQL via Supabase, SQLite, ...>
- **Deploy:** <e.g. Vercel, Railway, Fly.io>
- **Testing:** <e.g. Vitest, Pytest, go test>

## Where things are

- Source: `src/`
- Tests: `<co-located | tests/ | __tests__/>`
- Rules: `.claude/rules/` (Claude must follow)
- Subagents: `.claude/agents/`
- Skills: `.claude/skills/`
- Session memory: `.claude/sessions/` (latest first)

## Rules Claude must follow

See `.claude/rules/`. The categories are:

- `coding-style.md` — file size, immutability, naming
- `testing.md` — TDD workflow, coverage targets
- `security.md` — secrets, input validation, auth
- `git-workflow.md` — commit format, PR process
- `performance.md` — model selection, MCP discipline

These are loaded into Claude on every session. Keep them tight.

## Conventions specific to this project

- <e.g. "Never run migrations without explicit approval">
- <e.g. "All API routes return `{ data, error }` envelope">
- <e.g. "No direct Supabase queries from UI components — go through `lib/db/`">

Add only conventions Claude *must* enforce on every turn. Anything more specific belongs in the relevant rules file.

## How to start a new session

1. Check `.claude/sessions/` for the most recent entry. If it's relevant, ask Claude to load it.
2. Pick the right model:
   - Routine work → Sonnet (default)
   - Architecture, hard bugs, security → Opus
   - File search, simple edits → Haiku
3. State the objective in one sentence before any code.

## How to end a session

Ask Claude to write a summary to `.claude/sessions/YYYY-MM-DD-<topic>.md` with:
- Goal
- What worked (with evidence)
- What was tried but failed
- What's still open
- Files touched
- Decisions made

Edit the summary before saving. Don't trust auto-summary blindly.

## Subagents available

- `planner` — break a feature into steps before implementing
- `code-reviewer` — review code you just wrote
- `security-reviewer` — find vulnerabilities in a change
- `tdd-guide` — write tests first
- `refactor-cleaner` — find dead code

Definitions in `.claude/agents/`.

---

*This file is a routing layer, not a knowledge base. Keep it under 150 lines. Detailed rules and standards belong in `.claude/rules/`.*
