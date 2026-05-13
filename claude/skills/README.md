# Skills

Skills are reusable workflow definitions. They're invoked by name (the orchestrator decides when relevant), and they bring a defined process plus, optionally, supporting files.

This starter pack includes four skills focused on **workflow primitives** rather than language- or framework-specific recipes. Add the latter only when you're using them often.

## What's here

| Skill | When |
|---|---|
| `tdd-workflow` | When you're starting non-trivial implementation work |
| `search-first` | When the task is "find / understand / locate" before any edits |
| `iterative-retrieval` | When delegating retrieval to a subagent and the first answer is incomplete |
| `strategic-compact` | When ending a session, or before transitioning between phases |

## What a skill looks like

Each skill is a folder with a `SKILL.md` file. The frontmatter tells Claude when it applies; the body tells Claude how to do it.

```
skills/
  tdd-workflow/
    SKILL.md
  search-first/
    SKILL.md
```

A skill can also include supporting files (templates, scripts, examples) in its folder.

## What a skill should *not* be

- A wrapper around a single command. (Just use the command.)
- A 5-page essay. (Skills are workflow distillation; tutorials go in `docs/`.)
- Auto-loaded if it's specific to a rare workflow. (Set auto-load only on the few that genuinely apply every session.)

## Adding skills

When a workflow recurs and you keep re-explaining it:

1. Create `skills/<name>/SKILL.md`.
2. Frontmatter: `description` (terse, what triggers loading), `triggers` (optional explicit matchers).
3. Body: numbered steps, with examples where useful.
4. Test it by invoking it directly a few times before letting it auto-suggest.

Keep skill bodies under ~300 lines. If you need more, either you have multiple skills hidden in one, or you need a `docs/` page that the skill links to.

## Anti-patterns

- **Language-explosion.** `python-tdd`, `javascript-tdd`, `go-tdd`, etc. — keep `tdd-workflow` general and refer to language specifics as needed.
- **Framework explosion.** Same deal.
- **Skills that just paraphrase rules.** A rule says what; a skill says how. Don't duplicate.

## Install

User-level (applies everywhere):

```bash
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/
```

Project-level:

```bash
mkdir -p .claude/skills
cp -r skills/* .claude/skills/
```
