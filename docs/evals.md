# Evals and Verification Loops

The hardest part of working with Claude Code on real tasks is not generation — it's *knowing whether the output is correct*. Without a verification loop, you can't tell good output from confident-looking failure. With one, you can move much faster because you trust the signal.

## Two patterns

**Checkpoint-based.** At explicit boundaries (after a phase, before a merge), run a defined set of checks. Pass the checkpoint or fix issues before moving on.

**Continuous.** Run a smaller set of checks frequently — every N edits, every N minutes, after every commit. Catches regressions while they're fresh.

You want both. Checkpoints catch big issues at meaningful boundaries; continuous catches drift before it accumulates.

## What a checkpoint looks like

For a feature implementation, after Claude says "done":

1. **Build passes** — `npm run build` (or `cargo build`, `go build`, etc.) exits 0
2. **Type check passes** — `tsc --noEmit`, `mypy`, `pyright`, etc.
3. **Lint passes** — `eslint`, `ruff`, `golangci-lint`
4. **Existing tests pass** — `npm test`
5. **New tests added** — for the new behavior, with assertions, not just smoke tests
6. **Coverage didn't drop** — for the touched files
7. **Manual smoke** — one happy path you ran by hand

This is six commands and a 30-second sanity check. Far cheaper than discovering in PR review that the typecheck was broken from the start.

A small skill (`tdd-workflow`) bakes much of this in. A `quality-gate` script that runs all of the above is also valuable.

## Continuous verification

For continuous, lighter-weight:

- **Hook PostToolUse on Edit** to run formatter and typecheck on the touched file
- **Hook PostToolUse on Edit** to grep for `console.log`, `TODO`, `FIXME` and warn
- **Hook Stop** to summarize what changed and whether tests passed

Examples are in `claude/hooks/hooks.example.json`.

The discipline: **continuous checks must be fast and silent on the success path.** A typecheck that runs in 200ms and only speaks when it fails is great. A check that runs in 8 seconds on every edit is a context-eating distraction.

## pass@k vs pass^k

A useful distinction borrowed from eval research:

- **pass@k** — at least *one* of `k` attempts succeeds. Use when you just need it to work, you'll keep the best output.
- **pass^k** — *all* `k` attempts succeed. Use when consistency matters — the workflow has to be reliable, not occasionally-right.

Illustrative numbers (with a 70% per-attempt success rate):

```
pass@k:  k=1 → 70%   k=3 → 97%   k=5 → 99.8%
pass^k:  k=1 → 70%   k=3 → 34%   k=5 → 17%
```

Same underlying generator, very different outcomes depending on what you're optimizing for.

**When to optimize for pass@k:**
- Generating a function for a one-off use; you'll review and pick the best
- Brainstorming approaches; one good one wins
- Generating tests; redundant tests are not actively harmful

**When to optimize for pass^k:**
- Anything in CI / production
- Skills meant to be reused
- Subagents that other agents call

For pass^k workflows, the goal is to **reduce the variance of each attempt**, not to just retry more. That means tighter prompts, clearer scope, smaller deliverables, and explicit verification baked in.

## Building an eval harness for a recurring task

When you have a task you'll do many times — "review a PR for our coding standards", "extract the API surface from a TypeScript module" — invest in an eval harness:

1. **Collect 10-20 representative examples** with known-good outputs (or accepted/rejected reviews).
2. **Run your current setup** against all of them, log outputs.
3. **Compare** to known-good. Note where it's wrong, where it's right but verbose, where it's right but missing things.
4. **Change one thing** in the setup (the prompt, the agent definition, the model). Re-run.
5. **A/B compare**. Did it get better, worse, or both (better in some, worse in others)?

Two iterations of this typically yield a setup noticeably better than the starting point. Five iterations and you're approaching the ceiling of what prompting alone can do for that task.

The mistake is iterating without a fixed evaluation set. You change a prompt, the next session feels better, you keep that change, but you can't tell whether it actually generalized or just happened to suit that conversation.

## A note on benchmarks others publish

Claims like "this skill produces 50% better code" or "this hook reduces tokens by X%" deserve healthy skepticism. The honest version is usually "in our internal benchmark of N tasks, we observed X." That's useful directional information but not load-bearing.

Build your own evals on your own work. They'll tell you the truth.

## Rapid-feedback minimum

If you do *one* thing in this whole document, do this:

```
After every Claude task that touches code, run:
  npm run lint && npm run typecheck && npm test
(or your project's equivalent)
```

That's it. Three commands, almost always under 30 seconds. They'll catch ~80% of issues before you've moved on, and they'll catch them while Claude still has the context to fix them.
