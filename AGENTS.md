# Pi Skills — Agent Context

## Project Overview

This repository contains [Pi coding agent](https://github.com/badlogic/pi-coding-agent) skills — self-contained capability packages that Pi loads on-demand. Each skill lives in its own directory with a `SKILL.md` entry point.

## Key Files

- **`AGENTS.md`** — This file. Instructions for AI coding agents working on this project.
- **`README.md`** — User-facing project documentation.
- **`.gitignore`** — Standard TypeScript/Pi ignores.

## Skill Structure

```
skill-name/
├── SKILL.md           # Required: frontmatter + agent instructions
├── scripts/           # Executable helpers (TypeScript, bash, etc.)
├── references/        # Deep docs loaded on-demand
└── assets/            # Static resources
```

### SKILL.md Format

```markdown
---
name: skill-name
description: What this skill does and when to use it. Be specific.
---

# Skill Name

## Setup
...one-time setup instructions...
## Usage
...how to invoke scripts and use the skill...
```

Frontmatter rules:
- `name`: lowercase a-z, 0-9, hyphens only, 1-64 chars, no leading/trailing hyphens
- `description`: max 1024 chars, be specific about when to use
- Relative paths only (resolve from skill directory)

## Development Conventions

### TypeScript

- **ESM only** — use `import`/`export`, not `require()`
- **`package.json`** at repo root with `"type": "module"`
- Dependencies: shared in root `package.json`, per-skill `package.json` for isolated deps
- Run `npm install` at root; per-skill `npm install` for isolated skills
- Type-check: `npx tsc --noEmit`
- Tests: Vitest preferred (config in `vitest.config.ts`)

### Scripts

- Skill scripts go in `scripts/` and are invoked from `SKILL.md` via relative paths
- CLI scripts should accept arguments and support `--help`
- Exit non-zero on errors with clear messages

### Git

- Use conventional commits: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`
- Keep skills focused — one distinct capability per skill
- New skills get a pull request with SKILL.md, scripts, and README entry

## When Interacting With This Repo

1. **Creating a new skill**: Create `skill-name/SKILL.md` with valid frontmatter. Add `scripts/`, `references/`, `assets/` as needed. Update the skills table in README.md.
2. **Modifying an existing skill**: Update `SKILL.md` instructions, then adjust scripts/tests.
3. **Adding dependencies**: Install at root if shared, or create a `package.json` inside the skill directory for isolated deps.
4. **Running scripts**: Always use relative paths from the skill directory (e.g., `./scripts/my-script.ts`).

## Pi SDK & Extension Reference

- **Skills docs**: Check `/home/m/.local/share/fnm/node-versions/v24.16.0/installation/lib/node_modules/@earendil-works/pi-coding-agent/docs/skills.md`
- **Extensions docs**: `docs/extensions.md` — for when a skill needs custom tools registered via an extension
- **SDK docs**: `docs/sdk.md` — for programmatic usage
- **Examples**: `examples/` directory under the pi package
