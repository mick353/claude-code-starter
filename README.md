# Claude Code Starter

A lean, opinionated config pack for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Rules, agents, skills, hooks, and short docs that capture the patterns that actually move the needle, without the sprawl.

---

## ⚡ Quick start — using Claude Code in the Claude app

You're probably here for this. If you use Claude Code through the Claude mobile or desktop app (not the terminal CLI), you select one repo per session. To get the benefits of this starter pack on a new project, you bake the config *into that project's repo*. Once it's there, every Claude Code session attached to that repo loads the config automatically.

### One-time setup for any new project repo

**Step 1 — Create the new project repo on GitHub.** Empty is fine. Just a name.

**Step 2 — Start a Claude Code session attached to *this* repo (`claude-code-starter`).**

**Step 3 — Paste this prompt:**

> Run `bash bootstrap.sh <NEW-REPO-URL> <project-name>` from the root of this repo. Replace `<NEW-REPO-URL>` with the HTTPS clone URL of my new repo, and `<project-name>` with a short name for the project. The script will clone the target, copy the `claude/` folder into it as `.claude/`, create a `CLAUDE.md` from the template, commit, and push. After it finishes, summarize what landed in the new repo.

Claude Code will run the script. Two minutes later, your new repo has the full config and is ready to use.

**Step 4 — Start a fresh Claude Code session, this time attached to the *new* repo.** Everything is now active — rules apply on every turn, agents are available for delegation, skills fire when relevant, hooks run on events. Start working.

### If you forget how this works

You're reading the README right now — that's exactly the recovery path. As long as this repo exists on your GitHub, the bootstrap workflow always works the same way.

### What the bootstrap script does, plainly

- Clones your target repo into a temp folder
- Copies this repo's `claude/` directory into the target as `.claude/`
- Creates a starter `CLAUDE.md` at the target's root (only if one doesn't already exist)
- Commits with the message `scaffold: add Claude Code starter config`
- Pushes to the target's default branch
- Refuses to overwrite an existing `.claude/` folder if the target already has one

If the target repo already has a `.claude/`, the script bails out and tells you. You then merge manually — your existing config wins.

### Customising `CLAUDE.md` after the bootstrap

The template includes placeholders like `<STACK>`, `<RUNTIME>`, and "Where things are." Fill these in for the new project so Claude Code knows the context. Keep it under ~150 lines — detailed rules go in `.claude/rules/`, not here.

---

## What this is

A few dozen files. Roughly:

- **`docs/`** — Six short guides on the things most people get wrong: context economics, model selection, parallelization, memory, evals, and subagent orchestration.
- **`claude/rules/`** — A compact rules taxonomy that drops into a project's `.claude/rules/` (or `~/.claude/rules/` for terminal CLI users).
- **`claude/agents/`** — Five subagent definitions covering the main delegation patterns. Add more only when you have a real reason.
- **`claude/skills/`** — Four skills focused on workflow primitives, not language-specific recipes.
- **`claude/hooks/hooks.example.json`** — A minimal hook config you can extend.
- **`claude/contexts/`** — Three system-prompt context files for use with `claude --system-prompt` (terminal CLI only).
- **`claude/CLAUDE.template.md`** — A starter `CLAUDE.md` for new projects.
- **`bootstrap.sh`** — One-shot scaffolding script for new project repos.

## What this is *not*

- Not a 200-skill mega-bundle. The point is that **bigger is worse** — every skill, agent, and MCP description eats your context window. See [`docs/context-economics.md`](docs/context-economics.md).
- Not a framework or plugin. There's nothing to install. You scaffold from it; you don't depend on it.
- Not language-specific. Add language packs to a project's `.claude/` as separate files when you need them.
- Not portable to ChatGPT Codex, Cursor, Copilot, etc. The *ideas* transfer (model selection, context economics, etc.); the file format is Claude Code-specific.
- Not magic. These are conventions and templates. They work because they're simple.

---

## Two ways to use this repo

### A) Project-level (Claude Code in the Claude app — most users)

Use `bootstrap.sh` as described above. The config lives inside each project repo. Pros: travels with the repo, works in cloud sandboxes, teammates inherit it. Cons: a one-time scaffold step per project.

### B) User-level (Claude Code CLI on your own machine — power users)

If you run Claude Code natively on your machine, you can install user-level config that applies to every project automatically:

```bash
git clone https://github.com/<your-handle>/claude-code-starter.git
cd claude-code-starter

mkdir -p ~/.claude/rules ~/.claude/agents ~/.claude/skills ~/.claude/contexts ~/.claude/sessions

# Selective install — read the files first and pick what you want:
cp claude/rules/security.md ~/.claude/rules/
cp claude/rules/performance.md ~/.claude/rules/
cp -r claude/agents/*.md ~/.claude/agents/
cp -r claude/skills/* ~/.claude/skills/
cp -r claude/contexts/* ~/.claude/contexts/

# Hooks: merge by hand into ~/.claude/settings.json — don't blindly replace
cat claude/hooks/hooks.example.json
```

Then add aliases to your shell config:

```bash
alias claude-dev='claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"'
alias claude-review='claude --system-prompt "$(cat ~/.claude/contexts/review.md)"'
alias claude-research='claude --system-prompt "$(cat ~/.claude/contexts/research.md)"'
```

This route is for terminal users. If you're not sure which you are, you're probably in the app and want route A.

---

## How to use the docs

Read them in this order if you're new:

1. [`philosophy.md`](docs/philosophy.md) — the one principle everything else follows from
2. [`context-economics.md`](docs/context-economics.md) — why MCPs and tools cost more than they look
3. [`model-selection.md`](docs/model-selection.md) — when to use Haiku, Sonnet, Opus
4. [`memory-persistence.md`](docs/memory-persistence.md) — surviving across sessions
5. [`subagent-orchestration.md`](docs/subagent-orchestration.md) — delegating without losing the plot
6. [`parallelization.md`](docs/parallelization.md) — multiple Claude instances, when and how
7. [`evals.md`](docs/evals.md) — verification loops and the pass@k vs pass^k distinction

Each is 1-3 pages. None are theoretical.

---

## Attribution

The patterns and structure here are informed by [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code). That repo is sprawling and aggressively marketed but contains real ideas underneath. This starter pack distills the parts that hold up to scrutiny, leaves out the parts that don't, and adds critical commentary where the source overclaims. See [`ATTRIBUTION.md`](ATTRIBUTION.md) for specifics.

Other influences are credited inline where relevant.

## License

MIT. Do whatever you want with it. Attribution appreciated but not required.
