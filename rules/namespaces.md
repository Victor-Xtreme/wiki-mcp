# Namespace Rules

This document defines which MediaWiki namespaces agents may operate in and the conventions for each.

---

## Allowed namespaces

| Namespace | ID | Read | Write | Notes |
|---|---|---|---|---|
| Main | 0 | Yes | Yes | Standard articles. Use sentence case titles. |
| User | 2 | Yes | Operator only | Only edit pages owned by the agent operator. |
| File | 6 | Yes | Yes | Upload via `upload-file` tool, not by direct edit. |
| Template | 10 | Yes | Yes | Must not break existing template calls. Test in sandbox first. |
| Category | 14 | Yes | Yes | Add categories at page bottom. Follow hierarchy. |
| Help | 12 | Yes | No | Reference only. |
| MediaWiki | 8 | Yes | No | System messages — read-only for agents. |

## Restricted namespaces

| Namespace | ID | Reason |
|---|---|---|
| Special | -1 | Virtual namespace. Not accessible via API. |
| Media | -2 | Direct file access alias. Use File namespace instead. |
| Project | 4 | Wiki policy pages — human review required. |

## Naming conventions

- Use sentence case: `How to contribute to FOSSCell` (not `How To Contribute To FOSSCell`).
- Use hyphens for multi-word slugs: `Ragam-2025-workshops`.
- Avoid special characters: `&`, `%`, `#`, `?`, `+`.
- Prefix pages belonging to an event: `FOSSMeet/2025/Schedule`.

## Namespace aliases

The NITC Wiki may define custom namespace aliases. Check `Special:Version` or use the `get-site-info` tool to list them. Default MediaWiki aliases apply:

- `WP:` → Project (NS_PROJECT)
- `WT:` → Project talk (NS_PROJECT_TALK)
- `T:` → Template (NS_TEMPLATE)
- `C:` → Category (NS_CATEGORY)
