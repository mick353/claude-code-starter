# Parallelization

Running multiple Claude Code instances at once is powerful and easy to misuse. The temptation is to fan out — five terminals, five agents, "look how much I'm getting done." In practice this usually produces less work, of worse quality, with merge conflicts.

The right framing is the opposite: **the minimum number of parallel instances needed for the current work.** Adding an instance is a cost. It only pays off when the marginal task is genuinely independent.

## When parallel actually helps

- **Truly independent work streams** — frontend feature in repo A, backend bugfix in repo B.
- **Research running alongside execution** — main instance implements; second instance answers "how does library X handle Y?" without polluting the implementation context.
- **Long-running operations in the background** — let one instance run a slow test suite while another keeps moving.
- **Parallel exploration of design alternatives** — same problem, three approaches, three worktrees, compare results.

## When parallel hurts

- **Same files, different instances.** Merge conflicts you'll spend longer resolving than you saved.
- **Tasks that share state or sequence dependencies.** "Build the API, then the UI, then the migration" doesn't parallelize.
- **You don't have a clear plan for each instance.** Spawning an instance to "help" without a defined scope is just splitting attention.
- **Cognitive overhead exceeds work output.** Past 3-4 active instances, most people lose track of which one is doing what.

## Git worktrees: the only sane way

If two instances might touch overlapping files, give each a worktree:

```bash
# In your project's root:
git worktree add ../project-feature-a feature-a
git worktree add ../project-feature-b feature-b
git worktree add ../project-refactor refactor

# Now run separate Claude instances in each:
cd ../project-feature-a && claude
cd ../project-feature-b && claude
```

Each worktree is an independent checkout pointing at the same `.git`. Branches stay isolated. Commits in one don't surprise another. When you're done, merge the branches and `git worktree remove`.

Without worktrees, two Claude instances on the same checkout will fight over the working tree. Don't do that.

## The cascade method

A simple discipline for running 2-4 instances in tabs:

- **New tasks open in a new tab to the right.**
- **Work the tabs left-to-right** — oldest task gets attention first.
- **Cap at 3-4 active tabs.** Past that, your head is the bottleneck, not the model.
- **Close tabs when done.** Don't let zombie tabs accumulate.

The point isn't the specific shape — it's having *any* discipline. Without one, parallel sessions become a tab graveyard.

## A useful starting pattern: two instances

For most non-trivial work, two instances is the sweet spot:

- **Instance A — implementation.** Lives in the worktree. Edits files. Runs tests. Commits.
- **Instance B — research / questions.** Has read access but doesn't edit. Used for "where is X used?", "what does library Y do here?", "is there a precedent for this pattern in our code?".

This separation keeps the implementation instance's context clean. Asking research questions in the implementation instance dilutes its working memory and degrades subsequent edits.

## The practical sequence

```
1. Define what work each instance will do, in writing.
2. Make worktrees if they'll touch overlapping files.
3. Name each Claude session (`/rename <name>`) so you don't lose track.
4. Start work. Resist the urge to spawn a fourth instance "in case."
5. Merge / commit / close in left-to-right order.
```

## Honest cost accounting

Running three Opus instances in parallel costs three times as much as one. They're not "free" parallelism. Cheap models in parallel can be a real win on cost-time trade-offs; expensive models in parallel often aren't.

A reasonable default: parallel Sonnet for execution, single Opus for hard problems, Haiku in background for retrieval and watch tasks. Mixing models across instances is fine as long as each instance has the model right for its task.
