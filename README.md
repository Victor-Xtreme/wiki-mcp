# wiki-mcp

> **The single source of truth for AI agents interacting with the NITC Wiki.**

[![MediaWiki](https://img.shields.io/badge/MediaWiki-wiki.fosscell.org-blue?logo=wikipedia)](https://wiki.fosscell.org)
[![MCP](https://img.shields.io/badge/Protocol-Model%20Context%20Protocol-purple)](https://modelcontextprotocol.io)
[![License: AGPL-3.0](https://img.shields.io/badge/License-AGPL-3.0-yellow.svg)](./LICENSE)
[![FOSS Cell NITC](https://img.shields.io/badge/Maintained%20by-FOSS%20Cell%20NITC-green)](https://fosscell.org)

---

## What is this?

`wiki-mcp` is the **canonical configuration and rules repository** for any AI agent (Claude, Cursor, Copilot, or any MCP-compatible client) that needs to read from or write to the [NITC Wiki](https://wiki.fosscell.org).

Instead of every agent or developer defining their own way of talking to the wiki, this repo establishes:

- **How** agents must interact with the wiki (authentication, rate limits, edit summaries)
- **What** agents are allowed to do (read, write, upload, delete — and when)
- **Which** namespaces, templates, and categories are in scope
- **Where** all related config files live (via symlinks, so there is one canonical version)

The rules that govern all of this are defined in [`Agents.md`](./Agents.md).

---

## Repository structure

```
wiki-mcp/
├── README.md           ← You are here
├── Agents.md           ← Master rules & conventions for all AI agents
├── config.example.json ← Template — copy and fill in credentials
│                          (copy to config.json — never commit credentials)
│
├── rules/              ← Granular rule files (sourced by Agents.md)
│   ├── namespaces.md   ← Allowed namespaces and their purposes
│   ├── templates.md    ← Templates agents must use / must not overwrite
│   ├── categories.md   ← Category conventions and hierarchy
│   ├── uploads.md      ← File upload rules (formats, naming, licensing)
│   └── editing.md      ← Wikitext style guide for agent-generated content
│
├── symlinks/           ← Symlink targets for downstream tool configs
│   ├── claude          ← Claude project memory (Agents.md for Claude)
│   ├── cursor          ← Cursor project-level rules
│   └── mcp             ← Shared MCP server manifest
│
└── scripts/
    ├── setup-symlinks.sh   ← One-time setup: creates all symlinks
    └── validate-config.sh  ← Checks config.json against the live wiki API
```

`config.json` (user-created from `config.example.json`) is in `.gitignore` and must never be committed.

---

## Agents.md — the master rulebook

[`Agents.md`](./Agents.md) is the **primary document** every AI agent must load before interacting with the NITC Wiki. It defines:

| Section | What it covers |
|---|---|
| **Identity** | How the agent should identify itself in edit summaries |
| **Authentication** | Which credentials to use (bot password preferred, OAuth2 alternative) |
| **Read rules** | Which pages/namespaces the agent can freely read |
| **Write rules** | When the agent may create or edit pages, and mandatory pre-checks |
| **Upload rules** | Accepted file types, naming conventions, required license tags |
| **Forbidden actions** | Pages the agent must never touch, categories to never alter |
| **Error handling** | What to do on API errors, rate limits, or edit conflicts |
| **Review protocol** | When to pause and surface a decision to a human operator |

> **Every agent integration in this org must treat `Agents.md` as authoritative.** If your agent setup contradicts anything in `Agents.md`, `Agents.md` wins.

---

## Setup

See [**HowTo:SetupMCP**](https://wiki.fosscell.org/HowTo:SetupMCP) on the NITC Wiki for setup instructions — cloning, credentials, MCP client configuration, and validation.

---

## Available MCP tools (via wiki.fosscell.org)

| Tool | Description | Auth required |
|---|---|---|
| `get-page` | Fetch a wiki page's content | No |
| `search-page` | Search titles and full-text | No |
| `get-category-members` | List pages in a category | No |
| `get-page-history` | View recent revisions | No |
| `get-file` | Fetch a file page's metadata | No |
| `create-page` 🔐 | Create a new wiki page | Yes |
| `update-page` 🔐 | Edit an existing wiki page | Yes |
| `delete-page` 🔐 | Delete a wiki page | Yes (sysop) |
| `upload-file` 🔐 | Upload a file from disk | Yes |
| `upload-file-from-url` 🔐 | Upload a file from a URL | Yes |

> Before using any 🔐 tool, read the relevant section in `Agents.md` for required pre-checks and mandatory edit summary format.

---

## Symlink conventions

The `symlinks/` directory is how this repo stays the **single source of truth** across multiple tools and projects. Instead of duplicating config files, we symlink them here.

To add a new symlink:

```bash
# From the repo root
ln -s /absolute/path/to/other-repo/.cursor/rules symlinks/cursor-rules
```

Then register it in `scripts/setup-symlinks.sh` so new contributors get it automatically.

**Rule:** If a config file affects how an agent interacts with the NITC Wiki, its canonical location is this repo. Everything else symlinks to it — not the other way around.

---

## Contributing

All changes go through pull requests. The same rules in `Agents.md` that govern AI agents also apply to human contributors making changes here.

### What to change and how

| You want to… | Edit this | Notes |
|---|---|---|
| Change agent rules | `Agents.md` or `rules/*.md` | Get at least one review |
| Fix a typo / clarify wording | `README.md` or any `.md` file | Quick review |
| Add a new rule category | Create a file in `rules/` then reference it from `Agents.md` | |
| Add a new symlink target | `symlinks/README.md` + `scripts/setup-symlinks.sh` | Document what it's for |
| Update wiki connection config | `config.example.json` (never `config.json`) | Ensure it matches the upstream MCP server schema |
| Add a new AI client | Update the tools table in `README.md` | List the tool and how to configure it |

### PR checklist

- [ ] Read `Agents.md` first.
- [ ] Changes are on a descriptive branch name (e.g. `fix/auth-typo`, `add/cursor-setup`).
- [ ] If you added a file, it's referenced from somewhere (README tree or `Agents.md`).
- [ ] No credentials, tokens, or secrets in any committed file.
- [ ] `config.example.json` stays in sync with the upstream MCP server schema.

---

## Related repositories

| Repo | Purpose |
|---|---|
| [`Wiki-NITC/mediawiki-deploy`](https://github.com/Wiki-NITC/mediawiki-deploy) | Docker/infra for wiki.fosscell.org |
| [`Wiki-NITC/extensions`](https://github.com/Wiki-NITC/extensions) | Custom MediaWiki extensions |
| [`ProfessionalWiki/MediaWiki-MCP-Server`](https://github.com/ProfessionalWiki/MediaWiki-MCP-Server) | Upstream MCP server used here |

---

## License

AGPL-3.0 © FOSS Cell, NIT Calicut.

This repo contains configuration and documentation only. The upstream MCP server is separately licensed — see [ProfessionalWiki/MediaWiki-MCP-Server](https://github.com/ProfessionalWiki/MediaWiki-MCP-Server/blob/master/LICENSE).
