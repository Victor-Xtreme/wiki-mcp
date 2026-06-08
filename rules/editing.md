# Editing Rules — Wikitext Style Guide

This document defines the wikitext style that AI agents must follow when creating or editing pages on the NITC Wiki.

---

## 1. Section headings

Use `==` and `===` for section headings. Do not use `=` for the page title.

Correct:
```wikitext
== History ==
=== Early years ===
=== Recent developments ===
== Organisation ==
```

Incorrect:
```wikitext
= History =   (reserved for page title)
==Early years==  (no space — hard to read)
===Early Years===  (inconsistent capitalisation)
```

Heading capitalisation: Sentence case. Capitalise the first word and proper nouns only.

## 2. Text formatting

| Purpose | Syntax |
|---|---|
| Bold | `'''text'''` |
| Italic | `''text''` |
| Bold italic | `'''''text'''''` |
| Strikethrough | `<s>text</s>` (use sparingly) |
| Inline code | `<code>text</code>` |
| Block code | `<pre>text</pre>` or indent with space |

Do not use HTML `<b>`, `<i>`, or `<u>` tags — use wikitext equivalents.

## 3. Internal links

- Link to wiki pages: `[[Page title]]` or `[[Page title|display text]]`.
- Link to a section: `[[Page title#Section heading]]`.
- Link to a category: `[[:Category:Category name]]` (leading colon renders as link, not categorisation).
- Link to a file: `[[File:Filename.png|thumb|caption]]`.
- Do not pipe links just to hide the plural: incorrect `[[Page]]s`, correct `[[Page]]s` (MediaWiki handles this automatically).

## 4. External links

- Named: `[https://example.com Display text]`
- Bare URL: `https://example.com` (avoid — always provide display text)
- References: `[https://example.com Display text]` wrapped in `<ref>` tags.

## 5. References and citations

- Use `<ref>` tags for inline citations.
- Use the `{{Cite web}}` and `{{Cite book}}` templates for structured citations.
- Place references section at the bottom, before categories:

```wikitext
== References ==
<references />
```

Do not use `{{Reflist}}` on the NITC Wiki — use `<references />` instead.

## 6. Lists

Unordered:
```wikitext
* Item one
* Item two
** Sub-item
* Item three
```

Ordered:
```wikitext
# First
# Second
## Sub-step
# Third
```

Definition lists:
```wikitext
; Term
: Definition
```

## 7. Tables

Use MediaWiki table syntax, not HTML `<table>`:

```wikitext
{| class="wikitable"
|+ Caption
! Header 1 !! Header 2
|-
| Cell 1 || Cell 2
|-
| Cell 3 || Cell 4
|}
```

Always include `class="wikitable"` for standard styling.

## 8. Edit summaries

See `Agents.md § Identity` for the required edit summary format. Summaries must:

- Be non-empty.
- Briefly describe what changed and why.
- Not contain personal information.

## 9. Prohibited markup

- No `<span>` or `<div>` for styling — use wikitext or templates.
- No inline CSS — all styling goes in template or site CSS.
- No `<font>` tags — deprecated.
- No tables used for page layout (use div-based layout or templates).
- No raw HTML where a wikitext equivalent exists.

## 10. Page structure

Pages should follow this general structure:

```wikitext
'''Lead paragraph''' — bold summary of the page topic.

== Section 1 ==
Content here.

== Section 2 ==
Content here.

=== Subsection 2.1 ===
Content here.

== See also ==
* [[Related page 1]]
* [[Related page 2]]

== References ==
<references />

[[Category:Category name]]
```
