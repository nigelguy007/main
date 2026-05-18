#!/bin/bash
set -euo pipefail

# Only run in remote (cloud) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Check if claude-mem is already installed and up to date
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
PLUGIN_CACHE="$CLAUDE_DIR/plugins/cache/thedotmack/claude-mem"

if [ -d "$PLUGIN_CACHE" ] && ls "$PLUGIN_CACHE"/[0-9]*/scripts/worker-service.cjs >/dev/null 2>&1; then
  exit 0
fi

# Install claude-mem plugin
npx --yes claude-mem install
