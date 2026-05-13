# Git Workflow

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types:
- `feat` — new functionality
- `fix` — bug fix
- `refactor` — code change that neither fixes a bug nor adds a feature
- `docs` — documentation only
- `test` — adding or updating tests
- `chore` — tooling, deps, build
- `perf` — performance improvement

Description rules:
- Imperative mood. `add user auth` not `added user auth`.
- Lowercase, no period.
- Under 72 chars.

Body (when needed):
- Explain *why*, not what. Diff shows what.
- Wrap at 72 chars.
- Reference issues if relevant.

## Commit hygiene

- **One logical change per commit.** A commit is a story. Multiple unrelated changes in one commit make `git bisect` and `git revert` painful.
- **Compile and pass tests at every commit.** Use `git rebase -i` to clean up before pushing.
- **No `wip`, `fix`, `oops` commits in main history.** Squash before merging.

## Branches

- `main` (or `master`) is always deployable.
- Feature branches: `feat/<short-description>` or `username/<topic>`.
- Don't push to main directly on shared repos.

## PR process

1. Branch from `main`.
2. Make commits as you go (messy is fine on a feature branch).
3. Before requesting review: rebase, squash, write a clean PR description.
4. PR description has: **what** (one line), **why** (paragraph), **how to test** (steps), **risks** (anything reviewer should poke at).
5. Don't merge your own PR without review unless the team agreement says solo dev.

## Before pushing

```bash
# 1. Check what you're about to push
git log @{u}..HEAD --oneline

# 2. Run the quality gate
npm run lint && npm run typecheck && npm test
# (or your project's equivalent)

# 3. Push
git push
```

If any step fails, fix before pushing. Don't push broken code thinking "I'll fix it next commit." That commit is now in someone else's pull.

## Handling Claude-generated commits

When Claude generates a commit message:

- **Read it.** Claude's commit messages are usually serviceable but sometimes oversell ("revolutionary refactor of authentication system" for a one-line fix).
- **Edit ruthlessly.** A commit message is a contract with your future self.
- **Don't include "Generated with Claude" boilerplate** unless your team agreed to it. Most don't need it.

## When things go wrong

- **Force push** only on your own feature branches, never on `main` or shared branches.
- If you `git reset --hard` and lose work, `git reflog` is your friend — commits stay around for ~30 days.
- If you're about to do anything destructive in a hurry, stop. Make a branch first as a safety net: `git branch backup-before-thing`.
