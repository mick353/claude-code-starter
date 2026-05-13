# Claude Code Starter

A lean, opinionated starter pack for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Rules, agents, skills, hooks, and short docs that capture the patterns that actually move the needle, without the sprawl.

## What this is

About a dozen files. Roughly:

- **`docs/`** — Six short guides on the things most people get wrong: context economics, model selection, parallelization, memory, evals, and subagent orchestration.
- **`claude/rules/`** — A compact rules taxonomy you can drop into `~/.claude/rules/` or your project's `.claude/rules/`.
- **`claude/agents/`** — Five subagent definitions covering the main delegation patterns. Add more only when you have a real reason.
- **`claude/skills/`** — Four skills focused on workflow primitives, not language-specific recipes.
- **`claude/hooks/hooks.example.json`** — A minimal hook config you can extend.
- **`claude/contexts/`** — Three system-prompt context files for `claude --system-prompt "$(cat ...)"` usage.
- **`claude/CLAUDE.template.md`** — A starter CLAUDE.md you can copy and trim.

## What this is *not*

- Not a 200-skill mega-bundle. The point is that **bigger is worse** — every skill, agent, and MCP description eats your context window. See [`docs/context-economics.md`](docs/context-economics.md).
- Not a framework or plugin. There's nothing to install. You copy the files you want into `~/.claude/` or your project's `.claude/`.
- Not language-specific. Add language packs as separate files when you need them.
- Not magic. These are conventions and templates. They work because they're simple.

## Install

There's no installer. Pick what you want:

```bash
# Clone or download this repo
git clone <your-repo-url> claude-code-starter
cd claude-code-starter

# User-level (applies to all your projects)
mkdir -p ~/.claude/rules ~/.claude/agents ~/.claude/skills ~/.claude/contexts
cp -r claude/rules/* ~/.claude/rules/
cp -r claude/agents/* ~/.claude/agents/
cp -r claude/skills/* ~/.claude/skills/
cp -r claude/contexts/* ~/.claude/contexts/

# Project-level (applies only to current project)
mkdir -p .claude/rules .claude/agents .claude/skills
cp -r claude/rules/* .claude/rules/
# ...etc

# Hooks: review hooks.example.json first, then merge into your settings
cat claude/hooks/hooks.example.json
# Then edit ~/.claude/settings.json to add the hooks you want
```

Read the rules and agents before copying them. Trim aggressively.

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

## Attribution

The patterns and structure here are heavily informed by [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code). That repo is sprawling and aggressively marketed but contains real ideas underneath. This starter pack distills the parts that hold up to scrutiny, leaves out the parts that don't, and adds critical commentary where the source overclaims. See [`ATTRIBUTION.md`](ATTRIBUTION.md) for specifics.

Other influences are credited inline where relevant.

## License

MIT. Do whatever you want with it. Attribution appreciated but not required.
