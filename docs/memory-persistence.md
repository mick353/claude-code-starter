# Memory Persistence

Claude Code sessions don't share memory by default. When you `/clear` or close the terminal, that state is gone. For long-running work, you need three things: a place to write durable state, a way to load it on the next session, and the discipline to do both.

## The three layers

1. **Within a session** — context window, finite, eventually compacted.
2. **Across same-day sessions** — session memory files in `.claude/sessions/`.
3. **Across the project's life** — `CLAUDE.md`, rules, skills, codemaps.

Confusion between these is common. CLAUDE.md is not a place to log session-specific decisions. Session files are not a place to record durable conventions. Use each for what it is.

## Layer 1: within-session — strategic compaction

Auto-compact is fine but blunt. It loses the wrong things sometimes. Better:

- **Disable auto-compact** if your work involves multi-step reasoning you don't want flattened.
- **Manually `/compact` at logical boundaries** — after research, before implementation; after implementation, before review.
- **Take checkpoints** with `/checkpoints` so you can revert.

The skill in `claude/skills/strategic-compact/` walks through this.

## Layer 2: across-session — session files

The pattern:

```
.claude/sessions/
  2026-05-10-auth-flow.md       # today's work
  2026-05-09-onboarding.md      # yesterday's work
  ...
```

At session end, ask Claude to summarize state into `.claude/sessions/<date>-<topic>.md`. The file should contain:

- **What we set out to do** — original objective
- **What worked** (with evidence — test names, commit hashes, line numbers)
- **What was attempted but failed** — and why
- **What's still open** — concrete next steps
- **Files touched** — paths, what changed, why
- **Decisions made** — the trade-offs, with the reasoning preserved

Tomorrow you start the next session by saying *"Read `.claude/sessions/2026-05-10-auth-flow.md` and continue from where we left off"*. Claude rebuilds context from the file rather than from scrolling its way back through old turns.

A small skill (`strategic-compact/`) automates this.

## Layer 3: project life — hooks

Claude Code supports lifecycle hooks. Three are useful here:

- **`PreCompact`** — fires before context compaction. Good place to write important state to a file before it's flattened.
- **`Stop`** — fires when Claude finishes responding. Good place to extract any session-end summary.
- **`SessionStart`** — fires when a session begins. Good place to load the most recent session file automatically.

A minimal `hooks.example.json` with these is in `claude/hooks/`. The principle is: **save before lossy events, load at start, keep both quiet on the success path.**

## Dynamic system prompt injection (advanced)

Claude Code accepts a `--system-prompt` flag. Combined with mode-specific files, you get session profiles:

```bash
# ~/.zshrc or equivalent
alias claude-dev='claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"'
alias claude-review='claude --system-prompt "$(cat ~/.claude/contexts/review.md)"'
alias claude-research='claude --system-prompt "$(cat ~/.claude/contexts/research.md)"'
```

The `claude/contexts/` folder has starting templates for each. The system prompt has higher precedence than user messages, so this is a clean way to set tone and constraints per session type without bloating CLAUDE.md.

## What goes in CLAUDE.md (and what doesn't)

**Yes:**
- Project name, one-line summary
- Tech stack (Next.js 15, Supabase, etc.)
- Where rules live (e.g., "see `.claude/rules/`")
- Project-specific subagents
- Codemap pointer
- Conventions Claude needs to enforce on every turn (e.g., "never run migrations without explicit approval")

**No:**
- Detailed style guides (→ `rules/coding-style.md`)
- Long testing protocols (→ `rules/testing.md`)
- Session-specific notes (→ session files)
- "Things I tried last week" (→ commit messages, session files)

If your CLAUDE.md exceeds about 150 lines, split it. Bigger CLAUDE.md is one of the most common quiet causes of degraded Claude Code performance.

## Failure modes

- **Saving everything.** Session files that dump the entire conversation are useless tomorrow because you have to re-read them. Summarize ruthlessly.
- **Saving nothing.** Without a session file, you wake up to "remind me what we did" and burn 20 minutes rebuilding state.
- **Conflating layers.** A "lessons learned" entry that should be a permanent rule ends up in a session file and is forgotten in two days. If a lesson is durable, lift it to a rule file.
- **Trusting auto-summary blindly.** Claude's session summary is a starting point. Read it, edit it, then save it.

## A working loop

```
Session start  →  read .claude/sessions/<latest>.md if relevant
Mid-session    →  /compact at boundaries
                  /checkpoints before risky operations
Session end    →  generate summary, edit, save to .claude/sessions/
                  if a durable lesson emerged, lift it to rules/
```

Five extra minutes per session. Pays back the next day, every day.
