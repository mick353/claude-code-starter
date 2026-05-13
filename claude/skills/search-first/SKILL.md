---
name: search-first
description: Research and ground before implementation. Use when starting any task in unfamiliar code or against external APIs you haven't used recently.
auto-load: false
---

# Search-First

The cheapest bug to fix is the one you don't write because you knew the right approach before you started. This skill is a discipline: do the research, then code.

## When to use

- Touching code you haven't touched in a while
- Using an external API or library you don't have current knowledge of
- Implementing a pattern you suspect already exists in the codebase
- The task description mentions a library/version/feature whose details might have changed

## When *not* to use

- Mechanical changes (rename, format, simple refactor)
- You wrote this code last week and have full context
- Throwaway scripts where the cost of being wrong is low

## The flow

### 1. Map the codebase area

Before writing or even planning, find:

- **Where similar things already exist.** `grep` for keywords from the task in `src/`. If something close exists, use it as a model.
- **Where the change will land.** Which files? Which modules? Read them.
- **What conventions apply.** Is there a `.claude/rules/` or `CONTRIBUTING.md` with relevant guidance?

Tools: `Grep`, `Glob`, `Read`. Keep returns minimal — file paths and a few lines, not whole files.

### 2. Verify external knowledge

If the task uses a library, framework feature, or API:

- **Check the version** in `package.json` (or equivalent). Don't assume the latest.
- **Check the actual docs** for that version when behavior depends on it. APIs change.
- For a current-state question (does X still work? has Y deprecated?), use web search if available.

Don't trust your memory on library APIs that have version-specific behavior. The cost of being wrong is real.

### 3. Identify the smallest meaningful query

Frame the task as a specific question you can answer. Examples:

- "Where is user state currently stored, and is there a hook for it?"
- "Does this codebase already have an email validator? What does it accept?"
- "How does the Stripe webhook handler authenticate requests in this project?"

A specific question yields a specific answer in 1-2 minutes. A vague question yields a long exploration.

### 4. Decide before coding

Before writing any implementation, you should be able to state:

- **Files I will touch:** ...
- **Files I will create:** ...
- **Existing patterns I'll follow:** ...
- **Anything I'm uncertain about:** ...

If the last item is empty, you might not have searched enough. If the first three are empty, search more before coding.

## What this skill enforces

- **No speculative coding.** Don't write a function based on what you imagine the API surface is.
- **No "I'll figure it out as I go" on unfamiliar territory.** That mode burns context on rework.
- **Cite as you go.** When you find a relevant file or doc, note it: "found existing email validator at `src/lib/email.ts`, returns `{ valid, normalized }`." Future-you and reviewers will appreciate it.

## Anti-patterns

- **Searching forever.** Set a budget — usually 5-10 minutes of reading is enough to ground a feature. If you're past 30 minutes of search and haven't written code, stop and write what you know.
- **Searching in the wrong direction.** If three searches return nothing useful, your query terms are probably wrong. Ask the user "I'm looking for X — what should I be searching for?" rather than continuing to flail.
- **Trusting cached knowledge.** "I know this API" is exactly when libraries surprise you with a 2.0 breaking change. Verify when in doubt.

## Output format

Before any implementation, produce a short brief:

```
## Context
- This task is: <one line>
- Relevant existing code: <files with one-line descriptions>
- Conventions to follow: <pointer to rules or example>
- External APIs / libraries used: <name, version, key facts>

## Approach
- <2-4 sentences on what you plan to do>

## Open questions
- <anything that still needs an answer before coding>
```

Then implement. The brief is the receipt that shows the search actually happened.
