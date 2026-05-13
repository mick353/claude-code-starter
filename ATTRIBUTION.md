# Attribution

## Primary source

This starter pack distills patterns from [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code), specifically:

- [`the-shortform-guide.md`](https://github.com/affaan-m/everything-claude-code/blob/main/the-shortform-guide.md) (MIT)
- [`the-longform-guide.md`](https://github.com/affaan-m/everything-claude-code/blob/main/the-longform-guide.md) (MIT)

That repo is MIT-licensed, which is what makes this distillation possible.

## What was kept

Patterns from those guides that are present in this repo, in some form:

| Pattern | Source | Where it lives here |
|---|---|---|
| Rules folder taxonomy (security/style/testing/git/perf) | shortform | `claude/rules/` |
| Subagent roster (planner/reviewer/tdd-guide/etc.) | shortform | `claude/agents/` |
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

## What was deliberately left out

- **The 48 agents and 182 skills.** Most are boilerplate or hyper-narrow (e.g., separate skills for django-tdd, django-security, django-patterns, django-verification). A starter pack should be lean.
- **The "instinct" / "continuous-learning-v2" branding.** Underneath the marketing, it's a Stop hook that saves patterns to a file. The pattern is mentioned in `docs/memory-persistence.md` without the rebrand.
- **Cross-harness adapters** (Cursor, OpenCode, Codex). Useful only if you actually use those harnesses; orthogonal to the core ideas.
- **The Tkinter dashboard, AgentShield, ECC Tools GitHub App.** Adjacent products, not core patterns.
- **"Anthropic Hackathon Winner" framing and the heavy marketing tone.** Doesn't help you ship better code.
- **Unverified performance claims** (e.g., "mgrep ~50% token reduction"). Mentioned skeptically in `docs/context-economics.md` rather than presented as fact.
- **Multiple conflicting install paths** (plugin + manual + npm). This repo has exactly one: copy the files you want.

## What was added

- **Critical commentary.** Where the source claim is shaky or context-dependent, this repo says so.
- **A clear "philosophy" doc** stating the one principle everything else follows from.
- **Trade-off discussion** in each doc — when *not* to use a pattern.
- **Smaller agent definitions** focused on what they should *not* do, not just what they should.

## Other references

Patterns and ideas in the docs also draw on:

- Anthropic's [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code)
- Anthropic's ["Demystifying evals for AI agents"](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — for the pass@k framing
- Boris Cherny (Anthropic) on parallel terminal instances — relayed through the source longform guide
- The general body of practice around git worktrees, tmux, and CLI-first development

If you spot something here that you recognize from your own work and want credited (or removed), open an issue.
