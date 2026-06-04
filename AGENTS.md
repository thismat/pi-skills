# Pi Skills — Agent Context

## Project Overview

This repository contains [Pi coding agent](https://github.com/badlogic/pi-coding-agent) skills — self-contained capability packages that Pi loads on-demand. Each skill lives in its own directory with a `SKILLS.md` entry point.

## Key Files

- **`AGENTS.md`** — This file. Instructions for AI coding agents working on this project.
- **`README.md`** — User-facing project documentation.
- **`.gitignore`** — Standard TypeScript/Pi ignores.

## Skill Structure

```
skill-name/
└── SKILLS.md           # Required: frontmatter + instructions
```

The `SKILLS.md` file is self-documenting — it tells Pi what to do.

### SKILLS.md Format

```markdown
---
name: skill-name
description: What this skill does and when to use it. Be specific.
---

# Skill Name

## Setup
...one-time setup instructions...
## Usage
...how to invoke the skill...
```

Frontmatter rules:
- `name`: lowercase a-z, 0-9, hyphens only, 1-64 chars, no leading/trailing hyphens
- `description`: max 1024 chars, be specific about when to use

### Git

- Use conventional commits: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`
- Keep skills focused — one distinct capability per skill
- New skills get a pull request with SKILLS.md and an entry in the README skills table

## When Interacting With This Repo

1. **Creating a new skill**: Create `skill-name/SKILLS.md` with valid frontmatter. Update the skills table in README.md.
2. **Modifying an existing skill**: Edit `SKILLS.md`.
3. **Installing skills**: Run `./scripts/install.sh` to symlink all skills to `~/.pi/agent/skills/`.
4. **Uninstalling skills**: Run `./scripts/uninstall.sh` to remove symlinks.
