# Attribution

## Primary source

This starter pack draws on [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code), specifically the two guide documents that introduce the core patterns:

- [`the-shortform-guide.md`](https://github.com/affaan-m/everything-claude-code/blob/main/the-shortform-guide.md) (MIT)
- [`the-longform-guide.md`](https://github.com/affaan-m/everything-claude-code/blob/main/the-longform-guide.md) (MIT)

That repo is MIT-licensed and broader in scope than this one — it packages a wide range of agents, skills, hooks, and adapters across multiple AI coding harnesses. This pack is a deliberately narrower, opinionated subset focused on the patterns I rely on in daily use. Credit for surfacing many of the underlying ideas belongs there.

## Patterns kept

Concepts from the source guides that are present here in some form, with notes on what I changed:

| Pattern | Source | Where it lives here |
|---|---|---|
| Rules folder taxonomy (security/style/testing/git/perf) | shortform | `claude/rules/` |
| Subagent roster (planner/reviewer/tdd-guide/etc.) | shortform | `claude/agents/` — trimmed to 5, with sharper non-goals per agent |
| MCP context economics — keep <10 enabled, <80 tools | shortform | `docs/context-economics.md` |
| Model selection table (Haiku/Sonnet/Opus by task) | longform | `docs/model-selection.md` |
| Session memory file pattern (`.claude/sessions/`) | longform | `docs/memory-persistence.md`, `claude/skills/strategic-compact/` |
| `claude --system-prompt` mode-specific aliases | longform | `claude/contexts/`, `docs/memory-persistence.md` |
| Memory persistence hooks (PreCompact/Stop/SessionStart) | longform | `docs/memory-persistence.md`, `claude/hooks/` |
| `pass@k` vs `pass^k` distinction | longform | `docs/evals.md` |
| Git worktrees for parallel Claude instances | longform | `docs/parallelization.md` |
| Cascade method (left-to-right tab discipline) | longform | `docs/parallelization.md` |
| Iterative retrieval for subagents (≤3 cycles) | longform | `docs/subagent-orchestration.md`, `claude/skills/iterative-retrieval/` |
| Sequential phase orchestration with `/clear` between | longform | `docs/subagent-orchestration.md` |
| MCP → CLI + skill replacement strategy | longform | `docs/context-economics.md` |
| Search-before-coding workflow | shortform mentions | `claude/skills/search-first/` |
| TDD workflow as a skill | shortform | `claude/skills/tdd-workflow/` |

## Patterns deliberately not carried over

This is the editorial half — what *didn't* make the cut and why. The choices reflect this repo's lean-by-design philosophy; reasonable people can reasonably disagree.

- **The full agent and skill rosters.** The source ships dozens of each, including narrow per-framework variants (e.g., separate skills for django-tdd, django-security, django-patterns). This repo keeps a small generalist set on the view that a tight roster is easier to reason about than a deep menu.
- **Continuous-learning hook patterns.** The underlying mechanism — a Stop hook that records reusable patterns to a file — is mentioned in `docs/memory-persistence.md`, but without a standalone skill. Adoption is easy enough to skip the abstraction.
- **Cross-harness adapters** (Cursor, OpenCode, Codex). Genuinely useful if you use those harnesses; orthogonal to this repo's scope, which is Claude Code only.
- **Adjacent tooling.** A Tkinter dashboard, marketplace-distributed plugins, and a paid GitHub App. All reasonable but outside the "config-pack" scope.
- **Specific token-saving benchmark numbers.** Several tools (e.g., `mgrep`) are claimed to reduce token use by specific percentages on internal benchmarks. The general direction (smarter retrieval reduces context cost) is sound; the specific multipliers vary by workflow. This repo treats such numbers as directional rather than load-bearing — see `docs/context-economics.md` for the methodological note.
- **Multiple install paths** (plugin marketplace + manual + npm). This repo has exactly one: the `bootstrap.sh` script for project-level use, with optional manual copy for user-level use.

## What's new here

- **A stated philosophy.** `docs/philosophy.md` makes the underlying principle explicit so trade-off decisions in later docs are anchored to it.
- **Per-pattern reasoning, including when *not* to use each.** Each doc and skill includes an anti-pattern section. This is implicit in the source guides; this repo makes it explicit.
- **Agent definitions written around non-goals.** Each agent file starts with what the agent does *not* do. This produces tighter, more reliable delegation.
- **A bootstrap script for the Claude app workflow.** Most public configs target the CLI; the app's per-session-repo model means user-level install doesn't apply, so this pack scaffolds at project level via `bootstrap.sh`.

## Other references

Patterns and ideas in the docs also draw on:

- Anthropic's [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code)
- Anthropic's ["Demystifying evals for AI agents"](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — for the pass@k / pass^k framing
- Boris Cherny (Anthropic) on parallel terminal instances — relayed via the source longform guide
- The general body of practice around git worktrees, tmux, and CLI-first development

If you recognise something here from your own work that should be credited or removed, open an issue.
