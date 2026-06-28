#!/bin/bash
set -euo pipefail

# Only run in remote (cloud) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Check if claude-mem is already installed and runtime is set up
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
PLUGIN_CACHE="$CLAUDE_DIR/plugins/cache/thedotmack/claude-mem"
INSTALL_MARKER=$(ls "$PLUGIN_CACHE"/[0-9]*/.install-version 2>/dev/null | tail -1)

if [ -n "$INSTALL_MARKER" ] && [ -f "$INSTALL_MARKER" ]; then
  exit 0
fi

# Install or repair claude-mem plugin
if [ -d "$PLUGIN_CACHE" ] && ls "$PLUGIN_CACHE"/[0-9]*/scripts/worker-service.cjs >/dev/null 2>&1; then
  # Plugin files exist but runtime not set up — repair is faster than full reinstall
  npx --yes claude-mem repair
else
  npx --yes claude-mem install
fi
