# symlinks — Cross-tool Config Links

This directory documents symlinks that connect this repo (the single source of truth) to downstream tool configurations. The actual symlinks are created by `scripts/setup-symlinks.sh`.

## Current symlinks

| Name | Target location | Points to |
|---|---|---|
| `claude` | `../.claude/CLAUDE.md` | `Agents.md` — project memory for Claude |
| `cursor` | `../.cursor/rules` | `rules/` — project-level Cursor rules |
| `mcp` | `../mcp.json` | `config.example.json` — shared MCP server manifest |

## Adding a new symlink

1. Add an entry to the table above documenting the link.
2. Add the symlink creation logic to `scripts/setup-symlinks.sh`.
3. Run `bash scripts/setup-symlinks.sh` to apply.

## Principle

If a config file affects how an AI agent interacts with the NITC Wiki, its canonical location is this repo. Downstream tools get a symlink pointing here — never the reverse.
