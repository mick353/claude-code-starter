---
name: iterative-retrieval
description: When a subagent's first answer is incomplete, ask sharper follow-ups instead of doing the analysis in the orchestrator. Use during sequential phase work or whenever you've delegated a search/research task.
auto-load: false
---

# Iterative Retrieval

A pattern for working with subagents that don't have your semantic context.

## The problem this solves

Subagents save context by returning summaries. But the orchestrator (the main Claude conversation) has *purpose* the subagent doesn't see. When you delegate "find all uses of `validateToken`," the subagent returns 47 file:line matches. What you actually wanted was "which of those will break if `validateToken` becomes async."

Two options most people take, both bad:

1. **Trust the first return** — proceed with incomplete information.
2. **Pull the content into orchestrator context to analyze** — defeats the purpose of delegating.

Better: **ask the subagent a sharper follow-up** and let it do the analysis it now has the framing for.

## The pattern

Cap the loop at **3 cycles**. If you can't get useful output in 3 rounds, the question or the agent is wrong.

```
Cycle 1
  Orchestrator → Subagent: "<initial query>"
  Subagent → Orchestrator: <result>
  Orchestrator evaluates: is this enough to proceed?

Cycle 2 (if needed)
  Orchestrator → Subagent: "<refined query, building on result>"
  Subagent → Orchestrator: <refined result>
  Orchestrator evaluates again.

Cycle 3 (if still needed)
  Final attempt with the most specific phrasing you can produce.
  If still inadequate, abandon delegation — do it yourself with full context.
```

## What "evaluation" looks like

After receiving a subagent return, ask yourself:

- **Did it answer the question I asked?** (If no, re-prompt.)
- **Did it answer the question I *meant* to ask?** (If no, refine the prompt.)
- **Is the answer specific enough to act on?** (If no, ask for the next layer of detail.)

Don't accept "47 results" when you actually need "the 12 results that have property X."

## Worked example

Task: refactor `validateToken` to be async.

```
Cycle 1
  → "Find all uses of validateToken"
  ← 47 file:line matches across the codebase

Evaluation: I need to know which calls await it (or are in async context).
A bare match list doesn't tell me that.

Cycle 2
  → "For the 47 callers of validateToken, classify each as:
     (a) inside an async function and uses await on the result
     (b) inside an async function but does NOT await (will need fix)
     (c) inside a sync function (will need outer change)
     Return as a markdown table with file:line, classification, and a 1-line note."
  ← Table: 12 in (a), 9 in (b), 26 in (c)

Evaluation: Now I can plan. (b) and (c) are the work; (a) is fine.
Proceed.
```

The orchestrator never read the 47 callers. The subagent did the read and the classification, and returned the actionable structure.

## How to phrase good follow-ups

- **State what you have.** "You returned 47 matches."
- **State what you actually need.** "I need to know which need code changes when X becomes async."
- **Specify the format.** "Return as a table with columns: ..., max 50 rows."
- **Constrain the work.** "Don't read whole files; just the function body containing the call."

## When to abandon delegation

- The subagent has already failed the same query twice with different phrasings.
- The question genuinely needs orchestrator-level context (e.g., the answer depends on the full conversation history).
- You're spending more orchestrator tokens prompting the subagent than you'd spend just doing the work.

In those cases, do it yourself with `Read`/`Grep`. Subagent delegation is a tool, not an obligation.

## Anti-patterns

- **Re-asking the same question with politer wording.** That doesn't change the inputs.
- **Accepting partial answers and silently doing the rest in your head.** Either delegate the rest, or do all of it yourself — don't split the analysis between two contexts that don't share state.
- **Letting subagent results pile up unread.** If you've delegated three retrievals and haven't synthesized them, you've just moved the bottleneck to yourself.

## Output

When using this skill explicitly, narrate the cycles:

```
[Cycle 1] Asked: ...
[Cycle 1] Got: ...
[Cycle 1] Insufficient because: ...
[Cycle 2] Asked: ...
[Cycle 2] Got: ...
[Cycle 2] Sufficient. Proceeding.
```

This is verbose but makes the loop visible, which is the point. After you've used the pattern enough that it's instinctive, you can drop the narration.
