# Context Economics

Your 200k context window is not 200k. After Claude's system prompt, your tool descriptions, MCP definitions, hook outputs, skill auto-loads, and the conversation itself, you might be working with effective room of 70-100k. Sometimes less.

Treat every byte loaded into context like an expense. The most common pattern of "Claude is getting dumber" is "I have too much loaded."

## What costs what

**Tool descriptions.** Every tool a Claude instance can see has its full schema and description in context. A typical MCP server adds 5-20 tools, each with a paragraph of description. Multiplied across 10 MCPs, this can be 15-30k tokens of pure tool definitions before you've sent a single message.

**MCP server schemas in particular.** GitHub, Supabase, Vercel, Railway, Playwright — each adds substantial overhead. Many of these are wrappers around CLIs you already have on your machine. The MCP gives you a bit of integration polish; the CLI is in your context cost-free if you invoke it through `Bash`.

**Hook output.** Hooks that print to stderr are visible to Claude. A chatty PostToolUse hook on every Edit can fill context fast. Keep hook output terse and exit silent on the success path.

**Auto-loaded skills.** Skills with `auto-load: true` (or skills referenced in your CLAUDE.md) are always in context. Keep these to the small handful you actually use every session.

**CLAUDE.md / rules / `.cursor/rules`.** Always loaded. Big CLAUDE.md is the single most common source of bloat I see. If yours is over ~150 lines, split it into rules files and reference them from CLAUDE.md instead of inlining.

## What to do

### Triage MCPs

Run `/mcp` and disable everything you're not actively using *this week*. The rule of thumb that works:

- **Configured (in `~/.claude/settings.json` or `.mcp.json`):** 20-30 OK
- **Enabled at any one time:** under 10
- **Total active tools:** under 80

If a project doesn't need GitHub MCP for the current task, disable it. You can re-enable in seconds when you do.

### Replace MCPs with CLI + skill

When the MCP is mostly a wrapper around a tool you already have:

- **GitHub MCP** → `gh` CLI invoked via `Bash`, plus a small skill `gh-pr-create` that documents your preferred flags
- **Supabase MCP** → `supabase` CLI + skill
- **Vercel MCP** → `vercel` CLI + skill
- **Railway MCP** → `railway` CLI + skill

You lose nothing meaningful and recover the context.

When the MCP genuinely adds something the CLI can't (live HTTP, a service that has no CLI, browser control), keep it.

### Keep CLAUDE.md short

Treat CLAUDE.md as a routing layer, not a knowledge base. It should answer:

- What is this project?
- Where do the rules live?
- What's the dominant stack and tooling?
- Which subagents/skills are project-specific?

Detailed style guides, testing standards, and security rules go in `claude/rules/*.md` and load only when relevant.

### Run lean by default

A reasonable session-start state:

```
~5-7 MCP servers enabled
~3-5 auto-loaded skills
CLAUDE.md ≤ 150 lines
2-3 rules files referenced
```

Add more for specific tasks; trim back after.

## A note on benchmark claims

The source repo (and parts of the wider Claude Code community) make specific token-saving claims about particular tools — for example, that `mgrep` uses ~50% fewer tokens than `grep` in a 50-task benchmark. These numbers are plausible in principle (smarter search returns smaller match sets) but are vendor-published and the methodology isn't always public. Treat such numbers as directional, not load-bearing. The general claim "noisy tools eat context" is correct; the specific multiplier on any given tool is worth measuring in your own workflow before depending on it.

## Quick checklist

Before a session, ask:

- [ ] Are there MCPs enabled I won't use today? Disable them.
- [ ] Has CLAUDE.md grown unchecked? Trim or split.
- [ ] Are any hooks producing chatty output? Quiet them.
- [ ] Am I about to start a long session that will accumulate exploration context? Plan a compaction point.

That's it. The rest is just discipline applied across these axes.
