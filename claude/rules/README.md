# Rules

Files in this folder are loaded into every Claude Code session for the project (or user, depending on where you copy them). They are *always* in context — be ruthless about what goes here.

## Layout

```
rules/
  coding-style.md    # Universal style rules
  testing.md         # TDD workflow, coverage
  security.md        # Mandatory security checks
  git-workflow.md    # Commit format, PR process
  performance.md     # Model selection, context discipline
```

This is intentionally small. Five files. About a screen of content each. Total: maybe 600-800 lines of rules in context.

## What belongs in a rules file

A rule should be:

- **Always relevant.** If it only matters for a specific stack, it belongs in a project-specific rules file or a skill.
- **Actionable.** "Be careful with secrets" is not a rule. "Never paste a value matching `[A-Za-z0-9]{32,}` into source files" is.
- **Brief.** A rule is one or two sentences. If a rule needs a tutorial, the tutorial belongs in `docs/` or in a skill, and the rule cross-references it.

## What does *not* belong here

- Tutorials.
- Long examples.
- "Things I want Claude to know about my company." (→ CLAUDE.md, briefly.)
- Anything stack-specific that doesn't apply to all your projects.

## Install

User-level (applies to all projects):

```bash
mkdir -p ~/.claude/rules
cp rules/*.md ~/.claude/rules/
```

Project-level (applies to current project only):

```bash
mkdir -p .claude/rules
cp rules/*.md .claude/rules/
```

If you have both user-level and project-level rules with the same name, project-level wins. Use this for overrides.

## Adding language- or framework-specific rules

Don't put them here. Make a separate folder:

```
~/.claude/rules/lang/typescript.md
~/.claude/rules/lang/python.md
```

Reference them from CLAUDE.md only when the project actually uses that language. Loading every language rule into every session is exactly the bloat this starter pack is meant to avoid.
