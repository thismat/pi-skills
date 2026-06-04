#!/usr/bin/env bash
#
# uninstall.sh — Remove symlinked skills installed by install.sh
#
# Removes any symlinks in ~/.pi/agent/skills/ that point to directories
# inside this repository. Regular files/directories are left untouched.
#
# Usage:
#   ./scripts/uninstall.sh          # Uninstall all linked skills
#   ./scripts/uninstall.sh --help   # Show this help
#   ./scripts/uninstall.sh --dry-run  # Show what would be done without doing it
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
  echo "This script removes symlinks in ~/.pi/agent/skills/ that point to"
  echo "skill directories inside this repository. Only symlinks are removed;"
  echo "regular files and directories are never touched."
  echo ""
  echo "Options:"
  echo "  --help      Show this help and exit"
  echo "  --dry-run   Print what would be done without making changes"
  echo ""
  echo "Run ./scripts/install.sh to re-install after uninstalling."
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
  echo "Nothing to uninstall."
  exit 1
fi

# ── Find symlinks pointing into this repo ──────────────────────────────────

UNLINKED=0
SKIPPED=0
FOUND=false

echo "🗑️  Checking for skills linked from $REPO_ROOT"
echo ""

for entry in "$PI_SKILLS_DIR"/*; do
  [ -e "$entry" ] || continue  # handle empty directory

  target="$(readlink "$entry" 2>/dev/null || true)"

  # Only process symlinks
  if [ -z "$target" ]; then
    echo "   ⚠  $(basename "$entry") — not a symlink, skipping"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # Resolve the symlink target to an absolute path for comparison
  case "$target" in
    /*) abs_target="$target" ;;
    *)  abs_target="$(cd "$(dirname "$entry")" && cd "$(dirname "$target")" 2>/dev/null && pwd)/$(basename "$target")" ;;
  esac

  # Check if the symlink points inside this repository
  if [[ "$abs_target" == "$REPO_ROOT"/* ]] || [ "$abs_target" = "$REPO_ROOT" ]; then
    FOUND=true
    skill_name="$(basename "$entry")"

    if [ "$DRY_RUN" = true ]; then
      echo "   🗑️  $skill_name → would unlink (dry run)"
    else
      rm "$entry"
      echo "   🗑️  $skill_name — unlinked"
    fi
    UNLINKED=$((UNLINKED + 1))
  else
    echo "   − $(basename "$entry") — points outside repo, skipping"
    SKIPPED=$((SKIPPED + 1))
  fi
done

echo ""

if [ "$FOUND" = false ]; then
  echo "ℹ️  No skills from this repo are currently linked."
fi

echo "✅ Done — $UNLINKED unlinked, $SKIPPED skipped."
