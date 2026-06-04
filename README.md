# Pi Skills

A collection of [Pi coding agent](https://github.com/badlogic/pi-coding-agent) skills.

## What Are Pi Skills?

Skills are self-contained capability packages that Pi loads on-demand. Each skill is a directory with a `SKILLS.md` file that tells Pi what to do. Pi follows the [Agent Skills standard](https://agentskills.io/specification).

```
my-skill/
└── SKILLS.md           # Required: frontmatter + instructions
```

## Usage

Skills in this repo can be used by Pi in several ways:

### 1. Global installation

Clone this repo and symlink or copy individual skill directories to `~/.pi/agent/skills/`:

```bash
ln -s "$PWD/my-skill" ~/.pi/agent/skills/my-skill
```

### 2. Project-local

Add a `.pi/settings.json` to any project:

```json
{
  "skills": ["../path/to/pi-skills/my-skill"]
}
```

### 3. Direct reference

Load a skill at runtime:

```bash
pi --skill ./my-skill
```

Or add to your Pi settings:

```json
{
  "skills": ["path/to/pi-skills"]
}
```

## Skill Structure

Every skill is a directory with a single `SKILLS.md` file. Example:

```
example-packager/
└── SKILLS.md
```

**`example-packager/SKILLS.md`:**

```markdown
---
name: example-packager
description: Package a project into a tarball for distribution. Use when the user asks to bundle or ship the project.
---

# Example Packager

## Setup

```bash
npm install
```

## Usage

Create a tarball from the current project:

```bash
./scripts/package.sh
```
```

Key points:

- **`name`**: Lowercase letters, numbers, and hyphens only. Max 64 chars.
- **`description`**: Be specific — this determines when Pi loads the skill. Max 1024 chars. The more precise, the better Pi's automatic skill selection works.

## Skills

| Skill | Description |
|-------|-------------|
| _(add your skills here)_ | |

## License

MIT
