# Category Rules

Category conventions for the NITC Wiki. **Verified against the live category
list** — use real category names, not invented ones.

---

## How NITC Wiki names categories

The established convention (observed across hundreds of pages) is:

- **Title Case** — capitalise each significant word: `Clubs and Organizations`,
  `Food and Eateries`, `Gates and Landmarks`, `Home Teams`.
- **Plural** for categories that group instances: `Events`, `Hostels`,
  `Departments`, `Laboratories`, `Faculty`.
- **Spelled-out "and"** (not `&`).
- **Year categories** are bare years: `Category:2026`. Event editions also get a
  combined one: `Category:FOSSMeet 2026`.

> This differs from generic MediaWiki "sentence case" advice. On this wiki, match
> the existing Title-Case-plural style.

---

## Real top-level categories (use these, don't invent)

| Category | What goes in it |
|---|---|
| `Category:Events` | Any event or festival edition (also add the year + specific event cat). |
| `Category:FOSSMeet` | FOSSMeet pages (plus `Category:FOSSMeet YYYY`). |
| `Category:Ragam`, `Category:Tathva` | Those festivals. |
| `Category:Clubs and Organizations` | Student clubs (e.g. FOSSCell). |
| `Category:Home Teams` | Hostel/home teams. |
| `Category:Communities` | Interest groups / communities. |
| `Category:People` | People in general. |
| `Category:Faculty` | Faculty members. |
| `Category:Departments` | Academic departments. |
| `Category:Curriculum` | B.Tech curriculum / syllabus pages. |
| `Category:Academics`, `Category:Courses` | Academic content; courses. |
| `Category:Campus` | Campus places (umbrella). |
| `Category:Academic Buildings`, `Category:Laboratories` | Buildings and labs. |
| `Category:Hostels` | Hostels. |
| `Category:Amenities`, `Category:Food and Eateries` | Facilities and eateries. |
| `Category:Gates and Landmarks`, `Category:Grounds and Courts` | Outdoor places. |
| `Category:Student Government`, `Category:Student Life` | Student governance and life. |
| `Category:HowTo` | How-to guides. |
| `Category:Stubs` | Stub pages (added by `{{Stub}}`). |

For template/maintenance categories see [templates.md](templates.md). When in
doubt, open a similar existing page and copy its categories verbatim.

---

## How to categorise a page

1. **Every page gets at least one category.** Uncategorised pages are a known
   cleanup burden — never leave a new page bare.
2. Place categories at the **bottom** of the page, after `== See also ==` /
   `== References ==`.
3. Add the **most specific** category plus its umbrella(s). An event typically
   carries three:
   ```wikitext
   [[Category:FOSSMeet]]
   [[Category:FOSSMeet 2026]]
   [[Category:Events]]
   ```
4. Use a **sort key** when the page title shouldn't drive ordering:
   ```wikitext
   [[Category:Events|Ragam]]
   ```
5. To *link* to a category (instead of categorising), use the leading colon:
   `[[:Category:Events]]`.

---

## Before creating a new category

1. Check it doesn't already exist under a slightly different name
   (`search-page-by-prefix` with prefix `Category:`). The wiki already has a long,
   curated list — reuse beats inventing.
2. Match the Title-Case-plural style.
3. Give the new category page at least one parent category so it isn't orphaned.

## Prohibited

- Don't delete or rename categories (surface to a human).
- Don't create catch-all `Miscellaneous` / `Uncategorised` categories.
- Don't reparent an existing category without human review.
- Don't apply a category whose name you guessed — verify it exists first.
