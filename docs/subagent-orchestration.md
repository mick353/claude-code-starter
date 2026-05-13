# Subagent Orchestration

Subagents exist to save context. The orchestrator (your main Claude) delegates a narrow task, the subagent does the work in its own context, and returns a summary. The orchestrator's context stays clean.

This is a real win when it works. It also has a specific, predictable failure mode that many users hit and don't recognize.

## The context-negotiation problem

The orchestrator has *semantic* context the subagent does not. The orchestrator knows *why* it's asking. The subagent only sees the literal query.

**Example.** You're refactoring an auth flow. The orchestrator delegates: *"Find all uses of `validateToken`."* The subagent dutifully returns 47 file:line matches.

The orchestrator wanted to know *which of those calls would break if `validateToken` becomes async*. The subagent had no way to know that. The 47 matches now sit in the orchestrator's context, half of them irrelevant, and the orchestrator now has to do the analysis itself — but it's missing the *content* of the call sites because the subagent only returned paths.

You spent context to save context, and got worse output.

## The fix: iterative retrieval

The orchestrator evaluates the return, asks follow-up questions if the answer is incomplete, and re-delegates with sharper scope. Cap the loop at 3 cycles to prevent runaway.

```
1. Orchestrator → Subagent:  "Find all uses of validateToken"
2. Subagent → Orchestrator:  47 file:line matches
3. Orchestrator → Subagent:  "For each, is it called inside an async
                              context, and does it await the result?
                              Return a table."
4. Subagent → Orchestrator:  Table of 47 with two columns answered
5. Orchestrator filters:     Now has the 12 that need updating
```

Two delegation rounds, ~3k tokens, vs. either:
- Doing the analysis itself (10k+ tokens of file content in main context), or
- Trusting the first return and acting on incomplete information.

A skill (`claude/skills/iterative-retrieval/`) bakes this in.

## Sequential phase orchestration

For multi-step work — the dominant pattern for any non-trivial feature — use explicit phases. Each phase is one subagent doing one job, producing one output file, which is the input to the next phase.

```
Phase 1  RESEARCH    explorer agent       → research-summary.md
Phase 2  PLAN        planner agent        → plan.md
Phase 3  IMPLEMENT   tdd-guide agent      → code changes
Phase 4  REVIEW      code-reviewer agent  → review.md
Phase 5  VERIFY      build-error-resolver → done, or back to Phase 3
```

Rules that make this work:

- **Each agent has one input and one output.** No "and also do Y."
- **Outputs are files.** Don't pass long strings between turns. Files are debuggable, resumable, and don't bloat the orchestrator's context.
- **Use `/clear` between phases.** The orchestrator does not need the research notes during implementation; it needs the plan.
- **Don't skip phases.** Especially not the plan phase. The 60 seconds you save skipping planning costs 30 minutes in Phase 4.

## Designing a good subagent

A good subagent definition is mostly about *what it should not do*.

```yaml
---
name: explorer
description: Locate files, definitions, and call sites. Retrieval only.
tools: ["Read", "Grep", "Glob"]
model: haiku
---

You find things. You return file paths, line numbers, and minimal
context (the matched line plus 1-2 lines if needed for disambiguation).

You do NOT:
- analyze why the code is the way it is
- suggest refactors
- read full files unless explicitly asked
- return more than 50 results without asking which subset matters

If the request is ambiguous, ask one clarifying question before searching.
```

That's the entire definition. Short, clear, scoped. Compare with what happens when an agent has 30 tools, vague responsibilities, and a 1,500-word system prompt: the orchestrator now has to negotiate with what is essentially another generalist Claude. You've added latency and cost without adding capability.

## When *not* to use subagents

- **The task fits in 5k tokens of main-context work.** Just do it. The delegation overhead exceeds the savings.
- **The task requires the orchestrator's semantic context.** If you find yourself writing a 600-word delegation prompt to convey *what you actually want*, stop and do it yourself.
- **You're delegating because you're unsure.** Subagents amplify the orchestrator's specificity. They do not substitute for it. If you don't know what you want, the subagent won't either.

## A reasonable starter roster

Five agents covers most needs. Adding more is a coordination cost; only do it when an existing agent is genuinely stretched.

| Agent | When to delegate |
|---|---|
| `planner` | "Break this feature into steps before I start" |
| `code-reviewer` | "Read what I just wrote and find issues" |
| `security-reviewer` | "Find security issues in this change" |
| `tdd-guide` | "Write tests first for this feature" |
| `refactor-cleaner` | "Find dead code / loose .md files / etc." |

Definitions for each are in `claude/agents/`.

## The mental model

Treat subagents as **specialists you'd hire on a contract basis**. You wouldn't hand a contractor a 90-minute meeting; you'd write a one-page brief, set a deliverable, and review the output. Same here. The brief is the description and prompt. The deliverable is the output file. The review is the orchestrator's evaluation. If the deliverable is wrong, you re-brief — you don't try to fix it in the orchestrator's head.
