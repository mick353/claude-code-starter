# Model Selection

Picking the right model per task is the single biggest cost-and-latency lever you have. Most users default to one model for everything, which either overpays (running Opus on file searches) or underdelivers (running Haiku on architecture decisions).

## The matrix

These are starting points, not laws. Adjust based on your workload.
Claude Code should use this matrix to select or recommend the appropriate model, depending on what the current environment supports.

| Task type | Model | Why |
|---|---|---|
| File exploration / grep / "where is X defined" | Haiku | Fast, cheap, good enough for retrieval |
| Single-file edits with clear instructions | Haiku | Low-risk, well-defined output |
| Multi-file feature work | Sonnet | Best balance of quality and cost |
| Routine refactors | Sonnet | Needs to hold a few files in mind |
| Bug investigation (after symptom is known) | Sonnet | Hypothesis-driven, finite scope |
| Code review (PRs, security, style) | Sonnet | Catches nuance, handles full context |
| Architecture / system design | Opus | Deep reasoning, multi-step trade-offs |
| Cross-cutting refactors (5+ files, structural) | Opus | Whole-system mental model |
| Unfamiliar bug, root cause unclear | Opus | Needs to hold many possibilities open |
| Security-critical code | Opus | Cost of missing a bug exceeds the model premium |
| Doc generation from existing code | Haiku | Mostly transformation, structure is given |

Default to **Sonnet for ~80% of coding work**. Drop to Haiku when the task is mechanical. Upgrade to Opus when the first Sonnet attempt failed, the scope is structural, or the cost of being wrong is high.

## How to actually do this

Three mechanisms, in order of usefulness:

### 1. Subagents pinned to a model

In a subagent definition (`~/.claude/agents/<name>.md`), set the `model:` field in the frontmatter:

```yaml
---
name: explorer
description: Find files, definitions, and usage patterns
tools: ["Read", "Grep", "Glob"]
model: haiku
---

You are a fast retrieval agent. Return file paths and line numbers,
not full content. Do not analyze. Do not opine. Find and report.
```

```yaml
---
name: architect
description: Design decisions, system structure, trade-off analysis
tools: ["Read", "Grep", "Glob", "Bash"]
model: opus
---

You are a senior architect. Reason through trade-offs explicitly.
Surface alternatives. State assumptions. ...
```

The orchestrator (your main Claude) then delegates to the right model implicitly by choosing the right subagent.

### 2. Mode aliases

Run different defaults for different sessions:

```bash
alias c-fast='claude --model claude-haiku-4-5'
alias c='claude --model claude-sonnet-4-6'
alias c-big='claude --model claude-opus-4-7'
```

(Use whatever the current model strings are at the time you set this up — they change.)

### 3. In-session model switching

Use `/model` to switch mid-conversation if you realize you've under- or over-spec'd. This is more expensive than starting in the right place but recovers gracefully.

## What not to do

- **Don't always run Opus "to be safe."** Opus is roughly 5x the cost of Sonnet for typical coding work. If you're getting good results with Sonnet, the marginal value of Opus is often negative once you factor in latency.
- **Don't run Haiku for architecture.** It's fast and capable, but the cost of an architectural decision is months of code, not minutes of generation. Spend the model premium where it matters.
- **Don't switch models constantly within a single task.** Context-switching has a cost. Pick once, run, evaluate.

## A note on cost vs. value

People often optimize model cost in isolation. The real equation is:

```
total cost = (model cost per token) × (tokens used)
           + (your time) × (rework probability)
           + (downstream cost of bugs introduced)
```

Cheap models that need three tries are not actually cheap. Expensive models that one-shot are not actually expensive. Optimize the whole expression.

A practical heuristic: **if you've reset more than twice on a task with Sonnet, jump to Opus and re-plan**. If you're three sub-tasks deep into Opus and everything is going smoothly, switch to Sonnet for the next chunk.

## Pricing changes

Anthropic's pricing changes. Check [the pricing page](https://www.anthropic.com/pricing) when you're making cost-sensitive decisions. The relative ordering (Haiku < Sonnet < Opus) is stable; the absolute numbers and the size of the gaps are not.
