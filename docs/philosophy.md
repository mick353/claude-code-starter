# Philosophy

There is one principle. Everything else follows from it.

## The principle

**Claude's effective intelligence is bounded by the quality of its context, not the size of it.**

Context is finite (200k tokens, often less in practice). Anything you put in context — a system prompt, a tool description, an MCP definition, a hook output, a skill, a rule, a previous turn — competes for the same space. Adding "more" almost never helps; the cost is paid in either compute, latency, or attention dilution. Often all three.

The corollary: **a smaller, sharper setup beats a larger, comprehensive one.** Almost every problem people have with Claude Code traces back to violating this. Too many MCPs enabled. Too many skills loaded. CLAUDE.md grown to 4,000 lines. Subagents that return everything they read.

The skill of using Claude Code well is not configuring more. It is configuring less, on purpose.

## What this means in practice

- **Default to off.** Every MCP, every plugin, every skill auto-loaded into context should justify its slot.
- **Specialize agents.** A subagent with five tools and a 200-word system prompt outperforms one with thirty tools and a 2,000-word system prompt for almost any narrow task.
- **Compact deliberately.** Don't let context fill with exploration noise before execution. Start fresh between phases.
- **Prefer CLI + skills over MCPs** when the MCP is just wrapping a CLI you already have.
- **One CLAUDE.md, kept short.** If it grows past a screen, split it into rules and load on demand.

## What this rules out

- "Install everything to be safe." No. Every line of context is a tax.
- "More agents = more capability." No. More agents that the orchestrator has to choose between is a coordination problem; it doesn't add capability, it spends it.
- "Let it run and figure it out." No. Frequent compaction without checkpoints loses signal.

## When to violate the principle

Sometimes you need a lot of context: deep code archaeology, a new codebase you're learning, complex debugging that genuinely spans many files. In those cases, *spend the budget knowingly* — prefer one Claude instance with full context over five with partial context. And prepare a session memory file before you exit, because that conversation isn't replayable.

The rest of these docs are practical applications of the principle. If a recommendation here ever conflicts with the principle, the principle wins.
