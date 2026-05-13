# Hooks

Hooks are commands that fire on Claude Code lifecycle events. Used well, they catch issues early, save state automatically, and remove repetitive sanity checks. Used badly, they spam your context and slow every interaction.

This folder has one example file: `hooks.example.json`. It's not auto-installed — you copy what you want into your `~/.claude/settings.json` (under the `"hooks"` key) or into a project's `.claude/settings.json`.

## Hook events

- **`PreToolUse`** — before a tool runs (validation, blocking, hints). Can `exit 2` to block.
- **`PostToolUse`** — after a tool runs (formatting, linting, follow-up checks).
- **`UserPromptSubmit`** — when you send a message. Use sparingly; runs on every prompt.
- **`Stop`** — when Claude finishes responding. Good for end-of-turn checks.
- **`PreCompact`** — before context is compacted. Good for saving state.
- **`SessionStart`** — when a new session begins. Good for loading prior state.
- **`Notification`** — when permission is requested.

## Design principles

The example file follows these rules. Yours should too.

### 1. Quiet on the success path

A hook that prints "✓ check passed" on every edit fills your context with noise. Hooks should be silent when everything is fine and only speak when something needs attention. The pattern:

```bash
# Good — speaks only on failure
some-check && true || echo "[warn] check failed: ..." >&2

# Bad — speaks always
echo "Running check..." >&2; some-check; echo "Done." >&2
```

### 2. stderr, not stdout

Hook output to stderr is shown to Claude as a hint. Hook output to stdout can confuse the tool's own output. Default to stderr.

### 3. Don't block unless you mean it

`exit 2` from a `PreToolUse` blocks the tool. This is right for "about to write a secret to source" or "trying to push to main." It's wrong for "this might be slightly suboptimal." Reserve blocking for genuinely destructive operations.

### 4. Keep them fast

A hook that takes 3 seconds turns every edit into a 3-second wait. Hooks running on `PostToolUse` (which fires often) need to be sub-second. Slow checks belong in `Stop` or `PreCompact`, which fire less.

### 5. Resilient to absence

Don't assume tools exist:

```bash
command -v prettier >/dev/null && prettier --write "$file_path" || true
```

A hook that fails because `prettier` isn't installed is worse than no hook.

### 6. Match precisely

A `PostToolUse` matcher of `tool == "Edit"` fires on every edit, of every kind, in every file. Narrow the matcher:

```
"matcher": "tool == \"Edit\" && tool_input.file_path matches \"\\\\.(ts|tsx)$\""
```

## Installing the examples

The `_comment` and `_purpose` fields in the example are for human reading; Claude Code will ignore them. To install:

1. Read `hooks.example.json`. Decide which hooks you actually want.
2. Open `~/.claude/settings.json` (or your project's `.claude/settings.json`).
3. Under the `"hooks"` key, add the relevant entries from the example.
4. Test by triggering each event (e.g., make an edit, run a bash command).

Remove the `_purpose` and `_comment` fields from your real config — they're just documentation here.

## What to *not* hook

- **Hourly cron-style work.** Hooks are event-driven; if you want something to happen every N minutes, use a real scheduler.
- **Long-running checks** (full test suite, dependency audit, complex security scans). Run those manually or in CI; hooks are for fast, surgical interventions.
- **Notifications you don't act on.** If a hook tells you something every time and you ignore it every time, the hook is noise. Either change the threshold so it speaks less often, or remove it.

## Common starting set

If you want a sane minimal hook config, take just these three from the example:

1. **PostToolUse** — formatter on edit
2. **PostToolUse** — typecheck on TypeScript edit
3. **Stop** — warn on console.log in modified files

That's enough to catch most quiet regressions without adding noise.

## A note on portability

The example uses bash, which works on macOS and Linux. For Windows, hooks need to be PowerShell-compatible or run through WSL. The patterns are the same; the syntax differs.
