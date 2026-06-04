# Pi Skills

A collection of [Pi coding agent](https://github.com/badlogic/pi-coding-agent) skills built with TypeScript.

## What Are Pi Skills?

Skills are self-contained capability packages that Pi loads on-demand. Each skill provides specialized workflows, setup instructions, helper scripts, and reference documentation for specific tasks. Pi follows the [Agent Skills standard](https://agentskills.io/specification).

A skill is simply a directory with a `SKILL.md` file:

```
my-skill/
├── SKILL.md           # Required: frontmatter + instructions
├── scripts/           # Helper scripts (TypeScript, bash, etc.)
├── references/        # Detailed docs loaded on-demand
└── assets/            # Templates, configs, etc.
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

### 4. As a package (npm/git)

Publish individual skills or the full collection as a Pi package (see [Pi packages](https://github.com/badlogic/pi-coding-agent/blob/main/docs/packages.md)).

## Skill Structure

Every skill follows this format:

**`SKILL.md`:**

```markdown
---
name: my-skill
description: What this skill does and when to use it. Be specific.
---

# My Skill

## Setup

```bash
cd /path/to/skill && npm install
```

## Usage

```bash
./scripts/process.sh <input>
```
```

Key points:

- **`name`**: Lowercase letters, numbers, and hyphens only. Max 64 chars.
- **`description`**: Be specific — this determines when Pi loads the skill. Max 1024 chars.
- Use relative paths for scripts, references, and assets.
- Setup instructions run once before first use.

## Skills

| Skill | Description |
|-------|-------------|
| _(add your skills here)_ | |

## Development

### Prerequisites

- [Node.js](https://nodejs.org/) 18+
- [Pi coding agent](https://github.com/badlogic/pi-coding-agent) (for testing)

### Scripts

```bash
# Install dependencies for all skills
npm install

# Type-check all TypeScript
npx tsc --noEmit

# Run skill-specific tests
npx vitest run
```

### Creating a new skill

Use the `create-skill.ts` script or copy an existing skill:

```bash
cp -r _template my-new-skill
```

Edit `my-new-skill/SKILL.md` with your name, description, and instructions. Add helper scripts in `scripts/` and reference docs in `references/`.

## Conventions

- **TypeScript** for all helper scripts that aren't trivial shell commands
- **ESM modules** throughout (`import`/`export`)
- **Zod schemas** or **TypeBox** for parameter validation in custom tools/extensions
- **Error handling**: scripts should exit non-zero and print user-friendly errors
- **Docs**: each skill's `SKILL.md` is the primary documentation; use `references/` for deep technical details

## License

MIT
