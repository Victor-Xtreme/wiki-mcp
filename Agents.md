# Agents.md — Master Rules for AI Agents on the NITC Wiki

This document is the **authoritative rulebook** for any AI agent (Claude, Cursor, Copilot, or any MCP-compatible client) interacting with the [NITC Wiki](https://wiki.fosscell.org). Every agent must load this document before performing any action on the wiki.

---

## 0. What is enforced vs. what is guidance

Be honest about where these rules live:

- **Enforced by the wiki** — MediaWiki user rights and bot-password grants. An agent literally cannot do what its account isn't permitted to do (e.g. delete a page without the delete right).
- **Provided by the MCP server** — the bundled `@professional-wiki/mediawiki-mcp-server` exposes a fixed set of tools (`get-page`, `update-page`, `upload-file`, `whoami`, etc.). Uploads are off until upload directories are configured. The server does **not** expose `bot`, `minor`, `assert=bot`, or `maxlag` parameters on its edit tools.
- **Guidance only (this document + `rules/`)** — naming conventions, edit-summary format, namespace etiquette, license tags. Nothing mechanically enforces these; they work only because the agent is asked to follow them. Where a rule below mentions a parameter the MCP tools don't support (`bot`, `minor`, `maxlag`, `assert=bot`), treat it as background — the MCP edit tools simply take a title, content, and an edit summary.

When in doubt, prefer the [Review Protocol](#8-review-protocol): surface the action to a human.

---

## 1. Identity

Every edit, upload, or other logged action must identify the agent clearly.

**Edit summary format:**
```
Bot: <action> — <agent-name>
```

Examples:
- `Bot: Creating page "2026:Ragam" — Claude`
- `Bot: Fixing typo in "FOSSCell/About" — Cursor`
- `Bot: Uploading poster for 2025:Tathva — Copilot`

The agent name must match the `User-Agent` header sent to the MediaWiki API.

**User-Agent format:**
```
<agent-name>/<version> (https://wiki.fosscell.org; <operator-username>) <library>/<version>
```

Example:
```
Claude/1.0 (https://wiki.fosscell.org; User:ExampleBot) MediaWiki-MCP-Server/1.0
```

---

## 2. Authentication

### Preferred — Bot Password
- Create a bot password at `Special:BotPasswords` with minimal scopes.
- Store credentials in `config.json` under `username` and `password`.
- Each agent should have its own dedicated bot password.

### Alternative — OAuth2
- If bot passwords are insufficient, use OAuth2 with a personal access token stored in `config.json` under `token`.
- The token must be scoped to the minimum permissions needed.
- Never log or expose the token value.

### General rules
- Never share credentials between agents. Each agent gets its own token or bot password.
- Anonymous (unauthenticated) access is allowed for read-only tools only.
- Authenticated sessions should send the `assert=bot` parameter to enable bot flags where the client supports it (direct MediaWiki API access only; not exposed by the MCP tools).

---

## 3. Read Rules

Agents may freely read any page in the following namespaces:

| Namespace | ID | Notes |
|---|---|---|
| Main (articles) | 0 | Standard wiki content |
| `YYYY:` (year) | 3000–3135 | Event/edition pages (e.g. `2026:FOSSMeet`) |
| HowTo | 3200 | How-to guides |
| User | 2 | Only pages the agent's operator owns |
| File | 6 | File metadata and descriptions |
| MediaWiki | 8 | Read only — never edit |
| Template | 10 | Read to understand infobox/Cargo parameters |
| Form | 106 | Read to learn a page type's fields (Page Forms) |
| Property | 102 | Semantic MediaWiki properties |
| Category | 14 | Category pages and hierarchy |
| Help | 12 | Help documentation |
| `WIKI FOSSCELL NITC:` (Project) | 4 | Policy, Task Board, form helpers |

For the full namespace map and naming conventions see
[`rules/namespaces.md`](rules/namespaces.md). Agents must not read `Special:` pages
or restricted API modules without explicit human approval.

> **This is a structured-data wiki** (Cargo + SMW + Page Forms). Before creating
> content, read [`rules/structured-data.md`](rules/structured-data.md) and the
> per-type recipes in [`rules/page-types.md`](rules/page-types.md). Task-board
> operations follow [`rules/task-board.md`](rules/task-board.md).

---

## 4. Write Rules

### Before creating a page
1. Check the page does not already exist (`get-page`), and look at a sibling page of the same type to copy its pattern.
2. Verify the title follows the wiki's naming conventions (see [`rules/namespaces.md`](rules/namespaces.md)): `YYYY:EventName` for events, `Firstname Lastname` for people, common name for clubs. No special chars except `-`, `/`, `'`, `:`.
3. The page must belong to an allowed namespace (see Read Rules).
4. Use the matching **form/infobox/Cargo template** for the page type — don't hand-format structured content. See [`rules/page-types.md`](rules/page-types.md).
5. Add at least one **category** (real names only — see [`rules/categories.md`](rules/categories.md)).

### Before editing a page
1. Fetch the current content (`get-page`).
2. Do not blank content. If a page should be deleted, surface to a human operator.
3. Always provide a non-empty edit summary (see Identity section).

### Edit parameters

> The MCP server's `update-page` / `create-page` tools do **not** expose `bot`, `minor`, `maxlag`, or `assert=bot`. When editing through MCP, just provide a clear edit summary. The settings below are documented for completeness and apply only to direct MediaWiki API access.

- Set `bot: true` to suppress edits from recent changes (bot flag required).
- Set `minor: true` for typo fixes, formatting, and link corrections.
- Set `minor: false` for content additions, new sections, or structural changes.
- Respect `maxlag=5` — pause and retry with exponential backoff if lag is too high.

### Prohibited edits
- No edits to `MediaWiki:` namespace pages (system messages).
- No edits to user JS/CSS pages (`User:*.js`, `User:*.css`) unless the operator explicitly confirms.
- No changes to a **Cargo-declaring template** (`{{#cargo_declare}}` / `{{#cargo_store}}`) without human review — it needs a table rebuild.
- No edits to `Module:`, `Widget:`, `GeoJson:`, or `smw/schema:` pages without human review (code/schema).

---

## 5. Upload Rules

> **Uploads are disabled in the current beta.** The MCP server is run without any
> allowed upload directories, so `upload-file` is unavailable and agents cannot add
> files to the wiki. The rules below describe the intended policy for when uploads
> are turned on later.

### Allowed file types
| Format | Extensions | Max size |
|---|---|---|
| PNG | `.png` | 10 MB |
| JPEG | `.jpg`, `.jpeg` | 10 MB |
| SVG | `.svg` | 5 MB |
| GIF (animated) | `.gif` | 5 MB |
| GIF (static) | `.gif` | 10 MB |

### Naming conventions
- Use descriptive names with hyphens: `Ragam-2025-poster.png`
- Avoid special characters, spaces, or uppercase extensions.
- Prefix with event or topic name when applicable.

### License tags
Every upload must include exactly one license template on the file description page:

| License | Template |
|---|---|
| Creative Commons Attribution-ShareAlike 4.0 | `{{CC-BY-SA-4.0}}` |
| Creative Commons Attribution 4.0 | `{{CC-BY-4.0}}` |
| Own work, public domain | `{{PD-self}}` |
| GNU Free Documentation License | `{{GFDL}}` |
| Wikimedia Commons import | `{{From Wikimedia Commons}}` |

### Prohibited uploads
- Non-free / fair use content (the wiki is CC-BY-SA).
- Executables, archives (`.zip`, `.rar`), or documents (`.docx`, `.pdf` — except for reference material).
- Files with no license tag.

---

## 6. Forbidden Actions

The following actions are **always forbidden** without explicit, written human approval:

- Deleting any page.
- Blocking or unblocking users.
- Changing user rights or groups.
- Editing `MediaWiki:*.css` or `MediaWiki:*.js`.
- Editing the Main Page.
- Editing an agent operator's user page or user talk page except for bot notices.
- Creating pages outside allowed namespaces.
- Uploading files without a license tag.

---

## 7. Rate Limits and Error Handling

| Situation | Behaviour |
|---|---|
| `maxlag` exceeded (5 second default) | Wait 10 seconds, retry. Double wait on each subsequent failure (up to 120s max). |
| HTTP 429 Too Many Requests | Read `Retry-After` header. Wait that many seconds + 5s jitter. |
| Edit conflict (revision mismatch) | Re-fetch page, re-apply changes, retry. If conflict persists, abort and surface to human. |
| Network error / timeout | Retry up to 3 times with 5s backoff. Then abort. |
| API error: `badtags` | The configured change tag does not exist on the wiki. Contact a sysop. |
| API error: `permissiondenied` | The token lacks required grants. Surface to human. |

Agents must never silently swallow errors. Every error must be logged in the agent's output.

---

## 8. Review Protocol

The agent must pause and surface a decision to a human operator in these situations:

1. **Creating a new page** — Show the proposed wikitext and ask for confirmation before saving.
2. **Deleting or blanking a page** — Always require human confirmation.
3. **Editing a page in the `MediaWiki:` namespace** — Require human confirmation.
4. **First-time authentication** — Confirm the token works by calling `whoami` and showing the result to the human.

The agent must provide the human with:
- The action to be performed.
- The page(s) affected.
- A summary of changes (diff if available).
- The rationale for the action.

---

## 9. Draft Format

When the user asks you to prepare a draft (of category pages, template changes, new pages, or any batch edit), follow this procedure:

### Location
- Create a `drafts/` directory at the project root (`{repo_root}/drafts/`) if it does not already exist.
- Place **all** draft files inside this directory. Do not scatter drafts elsewhere in the repo.

### Contents
1. **Draft document** — one or more `.md` files describing every proposed change (page content, category tags, etc.). Name them descriptively, e.g. `category-hierarchy-draft.md`.
2. **HTML mockups** — one or more `draftpage-{N}.html` files showing how the modified pages will look after the changes are applied. The mockups should mimic the wiki's actual rendering (Citizen skin) as closely as possible: category member lists, subcategory grids, and page content.
   - If the draft affects many similar pages (e.g. adding a category tag to 50 templates), make mockups of **2–3 representative pages** only.
   - Mockups must be self-contained HTML files (CSS inline or in `<style>`).

### Goal
The human operator should be able to open each `draftpage-*.html` in a browser and see exactly what the wiki will look like after the changes — without having to imagine or cross-reference.

---

## 10. Enforcement

- Every agent integration in the Wiki-NITC organisation **must** load this document and follow its rules.(Rules are present in the rules folder.)
- If an agent's setup contradicts any rule here, this document takes precedence.
- Violations should be reported to the wiki sysops via `Special:EmailUser` or the FOSS Cell communication channel.
