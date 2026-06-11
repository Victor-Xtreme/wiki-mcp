---
name: magazine-archiver
description: Archive MagCom (FOSSCell magazine) submissions to the NITC Wiki under `User:<editor>/Magazine/<slug>`. Use when processing magazine submissions, bulk-archiving entries, or creating a new issue index. Covers slug generation, page format, and batch workflow.
---

# Magazine Archiver

Use this skill when **archiving MagCom (FOSSCell magazine) submissions** to
`wiki.fosscell.org`. Submissions live under the editor's user namespace and follow
a consistent format so they can be queried and listed.

---

## Page naming

```
User:<editor-username>/Magazine/<Slug>
```

- `<editor-username>` - the wiki username of the person archiving (confirm with
  `whoami` before starting).
- `<Slug>` - title-cased hyphenated slug derived from the submission title.

### Slug rules

1. Take the submission title.
2. Title-case each word (capitalize first letter of every word).
3. Replace spaces with hyphens.
4. Remove or replace special characters: `'` → omit, `&` → `and`, `,` → omit.
5. Keep it under ~50 characters; truncate at a word boundary if needed.

Examples:
- "Crap, I like the Girl Now" → `Crap-I-like-the-Girl-Now`
- "Images Taken from my Nokia 808 Pureview" → `Images-Taken-from-my-Nokia-808-Pureview`
- "Marichittum Mazhayathu Nilkunnavar" → `Marichittum-Mazhayathu-Nilkunnavar`
- "Who Does Art Belong To?" → `Who-Does-Art-Belong-To`

---

## Page format

```wikitext
== <Submission Title> ==
; Type: <Poetry | Fiction | Essay | Memoir | Artwork | Photography | Comic>
; Author: <Author Name>
; Issue: <Issue name or year, e.g. 2025>

<Full submission text, formatted as plain wikitext prose.>

<!-- For comics / artwork: describe the piece if image upload is unavailable -->

[[Category:Magazine]]
[[Category:Magazine <Year>]]
```

### Notes on formatting

- **Poetry**: preserve line breaks using blank lines between stanzas. Do not use
  `<br>` - blank lines between stanzas render correctly.
- **Fiction / Essay / Memoir**: paragraph breaks as blank lines. Bold the opening
  line only if it's a stylised title/header in the original.
- **Comics / Artwork**: describe the work in prose if the image can't be uploaded
  (uploads are currently disabled in beta). Note: `<!-- image pending upload -->`.
- **Malayalam / non-Latin text**: paste UTF-8 directly - MediaWiki handles it.
  Do not transliterate.

---

## Edit summary format

```
Bot: Archived MagCom submission - <Type> by <Author> (<agent>)
```

Examples:
- `Bot: Archived MagCom submission - Poetry by Shifana S Shafeek (agent)`
- `Bot: Archived MagCom submission - Fiction by Swathy Suresh (agent)`
- `Bot: Archived MagCom submission - Poetry (Anonymous) (agent)`

---

## Bulk archiving workflow

When processing a batch of submissions:

1. `whoami` - confirm the editor username (e.g. `Vysakh`).
2. For each submission:
   a. Generate the slug from the title.
   b. `get-page("User:<editor>/Magazine/<Slug>")` - check it doesn't already exist.
   c. Format the wikitext (template above).
   d. `create-page` with the correct edit summary.
3. After all submissions are created, optionally create or update an index page:
   `User:<editor>/Magazine` listing all entries with links.

Never batch more than ~20 pages without pausing to confirm with the human that
the format looks correct.

---

## Index page format (optional)

```wikitext
== Magazine Archive ==
Submissions archived from MagCom.

{| class="wikitable sortable"
! Title !! Author !! Type !! Issue
|-
| [[User:Vysakh/Magazine/Marichittum-Mazhayathu-Nilkunnavar|Marichittum Mazhayathu Nilkunnavar]] || Anandapadmanabhan || Essay || 2025
|-
| ... || ... || ... || ...
|}

[[Category:Magazine]]
```

---

## Categories

- `[[Category:Magazine]]` - always.
- `[[Category:Magazine YYYY]]` - year-specific (e.g. `Magazine 2025`).
- Verify the year category exists before using; create it if needed with a
  one-line description page.

---

## Common mistakes to avoid

- Using the wrong username in the page path - always `whoami` first.
- Skipping the slug-generation rules and using raw title with spaces (page titles
  can have spaces, but hyphens are the convention for this archive).
- Forgetting the category - uncategorised submissions won't appear in listings.
- Attempting image uploads - file uploads are disabled in the current beta.
- Overwriting an existing submission - always `get-page` first; if it exists,
  `update-page` instead, and note the change in the edit summary.

---

## Authoritative references

- `rules/namespaces.md` → User namespace conventions.
- `Agents.md` → Review protocol (show human a sample before bulk-creating).
- `Template:Magazine Submission/preload` on the live wiki - canonical format
  reference for submission pages.
