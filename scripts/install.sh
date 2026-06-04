#!/usr/bin/env bash
#
# install.sh — Symlink all skills in this repo into ~/.pi/agent/skills/
#
# Usage:
#   ./scripts/install.sh          # Install all skills
#   ./scripts/install.sh --help   # Show this help
#   ./scripts/install.sh --dry-run  # Show what would be done without doing it
#
# Exit codes:
#   0 — Success (or nothing to do)
#   1 — ~/.pi/agent/skills/ does not exist
#   2 — Other error

set -euo pipefail

# ── Help text ──────────────────────────────────────────────────────────────

show_help() {
  sed -n '2,12p' "$0"
  echo ""
  echo "This script symlinks every skill directory (a directory containing a"
  echo "SKILL.md file) from this repository into ~/.pi/agent/skills/."
  echo ""
  echo "Options:"
  echo "  --help      Show this help and exit"
  echo "  --dry-run   Print what would be done without making changes"
  echo ""
  echo "If ~/.pi/agent/skills/ doesn't exist yet, run 'pi init' or create it"
  echo "manually, then re-run this script."
  exit 0
}

# ── Parse flags ────────────────────────────────────────────────────────────

DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --help)    show_help ;;
    --dry-run) DRY_RUN=true ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--help] [--dry-run]"
      exit 2
      ;;
  esac
done

# ── Locate repo root ───────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ── Target directory ───────────────────────────────────────────────────────

PI_SKILLS_DIR="${HOME}/.pi/agent/skills"

if [ ! -d "$PI_SKILLS_DIR" ]; then
  echo "❌ Pi skills directory not found: $PI_SKILLS_DIR"
  echo ""
  echo "Make sure Pi is installed and has been initialized."
  echo "You can create it manually:"
  echo "  mkdir -p \"$PI_SKILLS_DIR\""
  echo ""
  echo "Then re-run this script."
  exit 1
fi

# ── Find skills ────────────────────────────────────────────────────────────

SKILL_DIRS=()
while IFS= read -r -d '' skfile; do
  skill_dir="$(dirname "$skfile")"
  skill_name="$(basename "$skill_dir")"
  SKILL_DIRS+=("$skill_name:$skill_dir")
done < <(find "$REPO_ROOT" -maxdepth 2 -name 'SKILL.md' -print0 2>/dev/null)

if [ ${#SKILL_DIRS[@]} -eq 0 ]; then
  echo "ℹ️  No skills found (no directories with SKILL.md). Nothing to install."
  exit 0
fi

# ── Install each skill ─────────────────────────────────────────────────────

INSTALLED=0
SKIPPED=0

echo "📦 Installing skills from $REPO_ROOT → $PI_SKILLS_DIR"
echo ""

for entry in "${SKILL_DIRS[@]}"; do
  IFS=':' read -r skill_name skill_dir <<< "$entry"
  target="$PI_SKILLS_DIR/$skill_name"
  source="$skill_dir"

  if [ -L "$target" ] || [ -e "$target" ]; then
    existing="$(readlink "$target" 2>/dev/null || echo "(not a symlink)")"
    if [ "$existing" = "$source" ]; then
      echo "   ✓ $skill_name — already linked"
    else
      echo "   ⚠  $skill_name — target exists ($target), skipping"
    fi
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "   🔗 $skill_name → $target (dry run)"
  else
    ln -s "$source" "$target"
    echo "   🔗 $skill_name → $target"
  fi
  INSTALLED=$((INSTALLED + 1))
done

echo ""
echo "✅ Done — $INSTALLED installed, $SKIPPED skipped."
