---
name: strategic-compact
description: Manually summarize the current session into a compact session memory file. Use at end of session, before phase transitions, or when context is filling with exploration noise.
auto-load: false
---

# Strategic Compact

Auto-compact is fine, but blunt. It loses the wrong things sometimes. This skill is the manual version: deliberate, lossy-on-purpose summarization that preserves what tomorrow-you actually needs.

## When to use

- **End of a working session.** Save state before closing.
- **Phase transitions.** After research, before implementation. After implementation, before review. Each phase needs the prior phase's output, not its working tape.
- **Context filling with exploration noise.** When the conversation is 60% file reads and dead ends, manually compact before doing real work.
- **Hitting token pressure.** Better to compact deliberately than to be auto-compacted at a bad moment.

## When *not* to use

- Mid-step on a complex task. Wait for a logical boundary.
- When you don't actually have anything worth preserving (a 10-minute exploration that didn't go anywhere — just `/clear`).

## The output: a session memory file

Write to `.claude/sessions/YYYY-MM-DD-<short-topic>.md`. Required sections:

```markdown
# <Session topic>
*Date: YYYY-MM-DD | Status: <in-progress | done | blocked>*

## Goal
One sentence: what we set out to do.

## Approach
2-4 sentences: the strategy we landed on.

## What worked
- <Item> — evidence: <test name | commit hash | file:line>
- ...

## What was tried but didn't work
- <Item> — why: <reason>
- ...

## What's still open
- [ ] <next action>
- [ ] <next action>

## Files touched
- `path/to/file.ts` — <what changed and why>
- ...

## Decisions made
- **<Decision>** — chose A over B because <reason>. If we change our mind, look at <where>.
- ...

## Notes for tomorrow
<Anything that would take 10 minutes to re-derive without this file. Be ruthless about what to keep.>
```

## What to leave out

- Long quoted code. Reference files instead.
- Failed approaches in detail (one line is enough; the file isn't a postmortem).
- "I tried this and Claude said..." narration. Summarize the *outcome*, not the dialogue.
- Anything that's already in commit messages or PR descriptions.

## How to use the file later

Tomorrow, in a new session:

```
"Read .claude/sessions/2026-05-10-auth-flow.md and continue where we left off.
Start by confirming the open items in 'What's still open' are still relevant."
```

Claude rebuilds context from the structured summary, not from re-reading scrolled-out conversation. Far cheaper, and the structure forces you to have actually summarized rather than dumped.

## When a session-level summary should become a rule

If you find yourself writing the same "decision" or "lesson" in multiple session files, lift it to a rule:

- "We always validate inputs at the API boundary, not in the handler" → goes in `rules/security.md` or a project rule.
- "Never run migrations without explicit approval" → CLAUDE.md or project rule.

Session files are for one session's state. Rules are for durable conventions. Don't conflate them.

## The compaction itself

Step by step:

1. **Decide what topic this session was.** If the session covered three unrelated topics, you have three files to write, not one.
2. **Open the template above.**
3. **Fill it in working from memory of the conversation.** It's OK if Claude does a first draft and you edit. Don't accept the first draft as final.
4. **Trim ruthlessly.** Anything you wouldn't read tomorrow comes out.
5. **Save.**
6. **`/clear` or end the session.**

## Quality bar

The session file is good if:

- A version of you tomorrow could resume work from it without scrolling chat history.
- Someone else on your team could understand the state if you handed it to them.
- It's under ~150 lines.

If it's longer than 150 lines, either the session covered too many topics or you didn't trim. Re-summarize.

## Failure modes

- **Saving auto-summary as-is.** Claude's first-draft summary is verbose and often misses the *why*. Edit it.
- **Skipping it because "I'll remember."** You won't. Five minutes now beats thirty minutes of confused recovery tomorrow.
- **Hoarding all sessions forever.** Old session files are noise. Periodically prune `.claude/sessions/` — keep recent and significant ones, delete the rest.
