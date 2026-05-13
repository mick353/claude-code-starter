# Subagents

Five subagents covering the most common delegation patterns. See `docs/subagent-orchestration.md` for the principles; this README is just the menu.

## The roster

| Agent | Use it when |
|---|---|
| `planner` | Before implementing any feature larger than a single function |
| `code-reviewer` | After writing code, before committing |
| `security-reviewer` | Auth, secrets, data handling, anything user-facing |
| `tdd-guide` | Writing new code that you actually want to be correct |
| `refactor-cleaner` | Hunting dead code, stale `.md` files, console.logs |

## Adding more agents

Resist. The cost of a new agent is real:

- The orchestrator now has another option to choose between (decision tax).
- The new agent's description is loaded into context whenever the orchestrator is deciding (token tax).
- Maintenance cost (one more file to keep accurate as your conventions evolve).

A new agent is justified only when:
- An existing agent is genuinely overloaded (e.g., `code-reviewer` covers style + perf + security; if you're a security-heavy shop, splitting `security-reviewer` is real)
- A workflow recurs often enough that ad-hoc delegation is friction
- The work is narrow enough that a model with fewer tools and a tight prompt will outperform the orchestrator

## Anti-patterns

- **Agent per language.** Don't create `python-reviewer`, `typescript-reviewer`, etc. unless the conventions genuinely diverge in a way one prompt can't cover.
- **Agent per framework.** Same reason.
- **"Helper" agents.** An agent named `assistant` or `helper` has no scope and produces fuzzy output.

## Designing your own

Look at the existing agent files. The pattern:

1. **One responsibility** stated in the first sentence
2. **Explicit non-goals** — what this agent does *not* do
3. **Minimal toolset** — only the tools needed
4. **Right model** — Haiku for retrieval, Sonnet for reasoning, Opus for high-stakes
5. **Output format** — what does it return? A summary? A file? Specific format?

Short prompts (200-400 words) usually outperform long ones for narrow agents.
