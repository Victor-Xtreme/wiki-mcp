#!/bin/bash
# setup-symlinks.sh — Creates symlinks so downstream tools pick up canonical config
#
# Usage: bash scripts/setup-symlinks.sh
#
# This script creates symlinks from tool-specific config locations back to this
# repo, ensuring wiki-mcp remains the single source of truth.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PARENT_DIR="$(dirname "$REPO_ROOT")"

echo "==> Setting up wiki-mcp symlinks..."
echo "    Repo root: $REPO_ROOT"

# ------------------------------------------------------------------
# Claude project memory (CLAUDE.md)
# ------------------------------------------------------------------
CLAUDE_DIR="$PARENT_DIR/.claude"
CLAUDE_TARGET="$CLAUDE_DIR/CLAUDE.md"

if [ ! -d "$CLAUDE_DIR" ]; then
  mkdir -p "$CLAUDE_DIR"
  echo "    Created $CLAUDE_DIR"
fi

if [ -L "$CLAUDE_TARGET" ] || [ -f "$CLAUDE_TARGET" ]; then
  echo "    Skipping Claude symlink — $CLAUDE_TARGET already exists"
else
  ln -s "$REPO_ROOT/Agents.md" "$CLAUDE_TARGET"
  echo "    Created: $CLAUDE_TARGET -> $REPO_ROOT/Agents.md"
fi

# ------------------------------------------------------------------
# Cursor project-level rules
# ------------------------------------------------------------------
CURSOR_DIR="$PARENT_DIR/.cursor"
CURSOR_TARGET="$CURSOR_DIR/rules"

if [ ! -d "$CURSOR_DIR" ]; then
  mkdir -p "$CURSOR_DIR"
  echo "    Created $CURSOR_DIR"
fi

if [ -L "$CURSOR_TARGET" ] || [ -d "$CURSOR_TARGET" ]; then
  echo "    Skipping Cursor symlink — $CURSOR_TARGET already exists"
else
  ln -s "$REPO_ROOT/rules" "$CURSOR_TARGET"
  echo "    Created: $CURSOR_TARGET -> $REPO_ROOT/rules"
fi

# ------------------------------------------------------------------
# MCP server manifest (mcp.json) — shared across projects
# ------------------------------------------------------------------
MCP_TARGET="$PARENT_DIR/mcp.json"

if [ -L "$MCP_TARGET" ] || [ -f "$MCP_TARGET" ]; then
  echo "    Skipping MCP manifest symlink — $MCP_TARGET already exists"
else
  ln -s "$REPO_ROOT/config.example.json" "$MCP_TARGET"
  echo "    Created: $MCP_TARGET -> $REPO_ROOT/config.example.json"
fi

echo "==> Done."
