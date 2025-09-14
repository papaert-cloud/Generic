#!/usr/bin/env bash
# setup-hooks.sh — copy hooks from docs/hooks to .git/hooks and make them executable
# Usage: ./scripts/setup-hooks.sh

set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
HOOKS_DIR="$REPO_ROOT/.git/hooks"
SRC_DIR="$REPO_ROOT/docs/hooks"

if [ ! -d "$SRC_DIR" ]; then
  echo "No local hooks directory found at $SRC_DIR. Create docs/hooks/ with your hook files first." >&2
  exit 1
fi

mkdir -p "$HOOKS_DIR"
cp -v "$SRC_DIR"/* "$HOOKS_DIR" || true
chmod -v +x "$HOOKS_DIR"/* || true

echo "Hooks installed from $SRC_DIR to $HOOKS_DIR"
