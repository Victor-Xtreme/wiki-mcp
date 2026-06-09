# Changelog

All notable changes to this repo are documented here.

## [0.1.0-beta] — 2026-06-09

First beta. The repo now works against the live wiki out of the box.

### Fixed
- **Corrected wiki API path.** `scriptpath` and `articlepath` were `/w` and
  `/wiki`, which 404'd. The live wiki serves its API at the root, so both are now
  empty strings. Reading previously failed before this fix.
- **Corrected `sitename`** to `WIKI FOSSCELL NITC` (matches the live siteinfo).
- **Fixed `opencode.json`.** Removed the invalid `${workspaceRoot}` token (VS Code
  syntax, not supported by opencode) and switched to a relative command path.
- **`validate-config.sh`** no longer reports legitimately-empty `scriptpath` /
  `articlepath` as missing.

### Changed
- **Pinned the upstream server** to `@professional-wiki/mediawiki-mcp-server@0.10.0`
  for reproducible beta installs. Bump in `scripts/start-mcp.sh` to upgrade.
- **Rewrote the README** with per-client setup (opencode, Claude Desktop, Cursor),
  Node 22.12+ prerequisite, troubleshooting, and a beta notice.
- **`Agents.md`** now states clearly what the wiki/MCP enforce versus what is
  agent-followed guidance, and notes that `bot` / `minor` / `maxlag` / `assert=bot`
  are not exposed by the MCP edit tools.
- **`start-mcp.sh`** adds a soft Node-version check and clearer error messages.

### Added
- **Rewrote `rules/` against the live wiki** (MediaWiki 1.45 + Cargo + SMW + Page
  Forms). `namespaces.md`, `categories.md`, and `templates.md` now use the wiki's
  real namespaces, category names (Title Case, plural), and templates that actually
  exist — replacing earlier invented values. `editing.md` reflects real markup
  practice (themed inline styles in templates, `{{#mermaid:}}`, `{{DISPLAYTITLE}}`).
- **New `rules/structured-data.md`** — Cargo / SMW / Page Forms: use the matching
  form/template, include `{{Event}}` on event pages, never break Cargo-declaring
  templates.
- **New `rules/page-types.md`** — per-type recipes (event, club, person, faculty,
  course, building, hostel, home team, HowTo, task).
- **New skill `.agents/skills/nitc-wiki-editing/`** so any skill-aware agent loads
  these conventions on demand.
- **`Agents.md`** read/write rules updated for the real namespaces, the
  structured-data workflow, and Cargo/Module/Widget edit protections.

### Removed
- **File uploads are disabled** for this beta. `Agents.md`, the README, and the
  setup agent all reflect that agents cannot upload files yet.
- **Removed the symlink machinery** (`symlinks/` and `scripts/setup-symlinks.sh`).
  Each client points at the repo directly; no cross-tool symlinks are needed.
- **Removed the `examples/` direct-API scripts** and all references to them.

### Known limitations
- File uploads are intentionally disabled in this beta.
- The `opencode.json` command assumes the client runs it from the repo root.
