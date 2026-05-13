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

Claude must treat these as project rules and consult them whenever relevant. Keep them tight.

## Conventions specific to this project

- <e.g. "Never run migrations without explicit approval">
- <e.g. "All API routes return `{ data, error }` envelope">
- <e.g. "No direct Supabase queries from UI components — go through `lib/db/`">

Add only conventions Claude *must* enforce on every turn. Anything more specific belongs in the relevant rules file.

## Layman operator protection

The user may not use CLI tools directly and may not know repository internals.

Claude must therefore:

- Explain technical risks in plain English before taking risky action.
- Identify when a request may affect architecture, dependencies, schema, security, tests, CI, or deployment.
- Avoid assuming the user knows which files are safe to edit.
- Prefer small, reviewable changes over broad rewrites.
- Ask before destructive or wide-scope changes, including deleting files, changing schemas, adding dependencies, rewriting history, or modifying CI/deployment config.
- Never require the user to manually run shell commands unless absolutely necessary.
- When commands are needed, explain what they do and why.
- At the end of each task, report what changed, which files changed, what checks ran, whether the task is complete, and any remaining risks.

## First prompt after bootstrap

After this starter config is added to a new repo, the first Claude Code session should begin with:

```text
Read CLAUDE.md and inspect .claude/rules/. Then inspect this repo at a high level and tell me:
1. what stack you detect,
2. what build, lint, typecheck, and test commands appear to exist,
3. what files or folders look like the main source and test areas,
4. what project-specific placeholders in CLAUDE.md still need filling in,
5. any immediate risks before development starts.

Do not modify files yet.
```

Claude should answer this as an orientation report before implementation work begins.

## How to start a new session

1. Check `.claude/sessions/` for the most recent entry. If it's relevant, ask Claude to load it.
2. Pick the right model:
   - Routine work → Sonnet (default)
   - Architecture, hard bugs, security → Opus
   - File search, simple edits → Haiku
3. Confirm the project’s build, lint, typecheck, and test commands from repo evidence such as README files, package files, CI config, `pyproject.toml`, `Cargo.toml`, `go.mod`, or equivalent.
4. State the objective in one sentence before any code.

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
