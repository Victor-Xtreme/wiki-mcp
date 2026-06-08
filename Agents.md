# Agents.md — Master Rules for AI Agents on the NITC Wiki

This document is the **authoritative rulebook** for any AI agent (Claude, Cursor, Copilot, or any MCP-compatible client) interacting with the [NITC Wiki](https://wiki.fosscell.org). Every agent must load this document before performing any action on the wiki.

---

## 1. Identity

Every edit, upload, or other logged action must identify the agent clearly.

**Edit summary format:**
```
Bot: <action> — <agent-name>
```

Examples:
- `Bot: Creating page "Ragam 2026" — Claude`
- `Bot: Fixing typo in "FOSSCell/About" — Cursor`
- `Bot: Uploading poster for Tathva 2025 — Copilot`

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
- Authenticated sessions must send the `assert=bot` parameter to enable bot flags.

---

## 3. Read Rules

Agents may freely read any page in the following namespaces:

| Namespace | ID | Notes |
|---|---|---|
| Main (articles) | 0 | Standard wiki content |
| User | 2 | Only pages the agent's operator owns |
| File | 6 | File metadata and descriptions |
| MediaWiki | 8 | Read only — never edit |
| Template | 10 | Read to understand template parameters |
| Category | 14 | Category pages and hierarchy |
| Help | 12 | Help documentation |

Agents must not read `Special:` pages or restricted API modules without explicit human approval.

---

## 4. Write Rules

### Before creating a page
1. Check the page does not already exist (`get-page`).
2. Verify the title follows wiki naming conventions (sentence case, no special chars except `-` and `/`).
3. The page must belong to an allowed namespace (see Read Rules).

### Before editing a page
1. Fetch the current content (`get-page`).
2. Do not blank content. If a page should be deleted, surface to a human operator.
3. Always provide a non-empty edit summary (see Identity section).

### Edit parameters
- Set `bot: true` to suppress edits from recent changes (bot flag required).
- Set `minor: true` for typo fixes, formatting, and link corrections.
- Set `minor: false` for content additions, new sections, or structural changes.
- Respect `maxlag=5` — pause and retry with exponential backoff if lag is too high.

### Prohibited edits
- No edits to `MediaWiki:` namespace pages (system messages).
- No edits to user JS/CSS pages (`User:*.js`, `User:*.css`) unless the operator explicitly confirms.

---

## 5. Upload Rules

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

## 9. Enforcement

- Every agent integration in the Wiki-NITC organisation **must** load this document and follow its rules.
- If an agent's setup contradicts any rule here, this document takes precedence.
- Violations should be reported to the wiki sysops via `Special:EmailUser` or the FOSS Cell communication channel.
