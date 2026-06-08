# Template Rules

This document defines which templates agents may use, create, or modify on the NITC Wiki.

---

## Allowed templates for agent use

These templates are safe for agents to use in page creation and editing:

| Template | Purpose | Usage |
|---|---|---|
| `{{CC-BY-SA-4.0}}` | License tag for file uploads | `{{CC-BY-SA-4.0}}` |
| `{{CC-BY-4.0}}` | Alternative license tag | `{{CC-BY-4.0}}` |
| `{{PD-self}}` | Public domain declaration | `{{PD-self}}` |
| `{{Stub}}` | Mark page as incomplete | `{{Stub}}` |
| `{{Under construction}}` | Page actively being written | `{{Under construction}}` |
| `{{Cleanup}}` | Page needs formatting fixes | `{{Cleanup|reason=...}}` |
| `{{Infobox}}` | Generic infobox | `{{Infobox|title=...|data1=...}}` |
| `{{Cite web}}` | Cite a web source | `{{Cite web|url=...|title=...|access-date=...}}` |
| `{{Cite book}}` | Cite a book | `{{Cite book|title=...|author=...|year=...}}` |

## Templates agents must never overwrite

These templates are critical to wiki infrastructure. Agents may read them but must never edit or delete them:

- `Main Page` (and its sub-templates)
- `Sidebar`
- `Footer`
- `License` (footer license notice)
- Navigation templates (prefixed with `Nav/`)
- Any template in `MediaWiki:` namespace

## Template creation rules

1. Reuse existing templates before creating new ones.
2. Template names should be descriptive: `Event infobox` not `Infobox2`.
3. Document all parameters with `<noinclude>` comments.
4. Categorise templates under `Category:Templates`.
5. Do not duplicate templates that already exist on Wikimedia Commons or MediaWiki.org — transclude instead.

## Template usage rules

1. Always use named parameters when available: `{{Cite web|url=...}}` not `{{Cite web|...|...}}`.
2. Do not nest templates more than 5 levels deep to avoid parser limits.
3. Use `<includeonly>` and `<noinclude>` tags appropriately.
4. Wrap agent-generated template calls with `{{subst:...}}` only when the result should be static.
