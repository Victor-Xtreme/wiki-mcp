# Category Rules

This document defines category conventions and hierarchy for the NITC Wiki.

---

## Root categories

All content should fall under one of these root categories:

| Category | Contents |
|---|---|
| `Category:Clubs and Communities` | Student clubs (FOSSCell, IEDC, etc.) |
| `Category:Events` | FOSSMeet, Ragam, Tathva, CodeInit, workshops |
| `Category:People` | Faculty, alumni, contributors |
| `Category:Projects` | Open source projects by NITC students |
| `Category:Infrastructure` | Labs, buildings, servers, network |
| `Category:Campus Life` | Hostels, mess, sports, cultural groups |
| `Category:Tutorials` | How-to guides and technical documentation |
| `Category:Templates` | Reusable wiki templates |
| `Category:Files` | Uploaded media organised by type |

## Naming conventions

- Capitalise the first letter of each word: `Category:Clubs And Communities`.
- Use singular for categories that describe a type: `Category:Event` not `Category:Events`.
- Use plural for categories that contain instances: `Category:Projects` (contains many projects).
- Avoid abbreviations: `Category:National Institute of Technology Calicut` not `Category:NITC`.

## Hierarchy rules

1. Every page must belong to at least one category.
2. Categories should be placed at the **bottom** of the page.
3. Subcategories should have exactly one parent category (no multiple parents unless cross-listing is intended).
4. Maximum depth: 5 levels from root.
5. Use `Category:...` links, not pipe-tricked variations.

## Prohibited actions

- Agents must not delete or rename categories.
- Agents must not add pages to root categories directly (use subcategories).
- Agents must not create "uncategorised" or "miscellaneous" catch-all categories.
- Agents must not change the parent of a category without human review.

## Category syntax

Use standard wiki syntax:

```
[[Category:Events|Ragam]]
[[Category:Ragam|2025]]
```

The sort key (text after `|`) should reflect the page title or a logical ordering value.
