# Page-Type Recipes

Concrete recipes for the page types the NITC Wiki uses, based on how real pages are
built. Each recipe says **where** the page goes, **which form/template** owns its
fields, and **which categories** to apply.

> **Read the form/template first.** The `Form:X` and `Template:X` pages are the
> source of truth for parameter names. Fetch them before filling in values — don't
> rely on the (illustrative) field lists below.

---

## Event / festival edition

The most structured page type on the wiki.

- **Title / namespace:** `YYYY:EventName` (year namespace) — e.g. `2026:FOSSMeet`,
  `2025:Ragam`, `2026:Tathva`. Create a main-namespace **redirect** from the common
  name (e.g. `FOSSMeet'26` → `[[2026:FOSSMeet]]`).
- **Form:** `Form:Event` (or `Form:FOSSMeet` for FOSSMeet).
- **Templates, in order:**
  1. `{{Event|year=|month=|day=|description=|type=|organizer=}}` — Cargo data
     (required for "This day in history" + queries).
  2. The matching infobox: `{{Infobox FOSSMeet}}` or `{{Infobox Event}}`.
  3. `{{DISPLAYTITLE:...}}` if the display title is stylised (`FOSSMeet'26`).
- **Body:** lead paragraph, `== Highlights ==`, `== Sub Committees ==`,
  `== See also ==` with subpage links, then the navbox.
- **Subpages:** `/Schedule`, `/Speakers`, `/Team`, `/Gallery`, `/Coverage`,
  `/Roadmap` as needed.
- **Categories:** specific + year + umbrella, e.g.
  `[[Category:FOSSMeet]] [[Category:FOSSMeet 2026]] [[Category:Events]]`.

## Organisation (club / home team)

Covers both student clubs (professional, non-technical) and home teams (cultural,
technical, sports). **Always use the unified `{{Infobox Organization}}` for new
pages** — it stores to the `Clubs` Cargo table, making the page visible in
structured queries.

- **Title / namespace:** common name in main namespace (`FOSSCell`, `The Act: Drama Team`).
- **Form / template (preferred):** `Form:Organization` → `{{Infobox Organization}}`
  (27 fields: `name`, `type`, `logo`, `image`, `fullname`, `shortname`, `founded`,
  `founder`, `faculty_advisor`, `parent_fest`, `flagship_event`, `parent_org`,
  `induction_year`, `batch_size`, `member_count`, `current_lead`, `captain`,
  `status`, `instagram`, `youtube`, `github`, `email`, `telegram`, `website`,
  `description`, `discipline`, `meeting_place`, `achievements_count`, ...).
  The `type` parameter controls auto-categorisation:
  - `Cultural Organisation` / `Technical Organisation` / `Sports Organisation` → auto-categorised under `Home Teams`
  - `Professional Organisation` / `Non-Technical Organisation` → auto-categorised under `Clubs and Organizations`
- **Legacy (existing pages only):** `Form:Club` → `{{Infobox Club}}` (no Cargo storage)
  and `Form:Home Team` → `{{Infobox Home Team}}` (no Cargo storage). Do not use for
  new pages — they won't appear in Cargo queries.
- **Body:** intro, `== Yearly Reports ==`, `== Achievements ==` (batch-organised for
  home teams), `== See also ==`.
- **Categories:** auto-assigned by the template based on `type`. Verify the
  type-specific subcategories exist with `search-page-by-prefix` (they may need
  creation — see [categories.md](categories.md)).

## Person

- **Title / namespace:** `Firstname Lastname` in main namespace.
- **Form / template:** `Form:Person` → `{{Infobox Person}}`.
- **Category:** `[[Category:People]]` (add others as relevant).

## Faculty

- **Form / template:** `Form:Faculty` → `{{Infobox Faculty}}`.
- **Category:** `[[Category:Faculty]]` (and `[[Category:People]]` / department cat
  where appropriate).

## Course

- **Form / template:** `Form:Course` → `{{Infobox Course}}`.
- **Categories:** `[[Category:Courses]]` plus `[[Category:Theory Courses]]` or
  `[[Category:Lab Courses]]` and the department.

## Building / campus location

- **Form / template:** `Form:Campus Location` → `{{Infobox Building}}` or
  `{{Infobox Campus Location}}`.
- **Categories:** `[[Category:Campus]]` plus a specific one
  (`Academic Buildings`, `Laboratories`, `Amenities`, `Food and Eateries`,
  `Gates and Landmarks`, `Grounds and Courts`).

## Hostel

- **Form / template:** `Form:Hostel` → `{{Infobox Hostel}}`.
- **Category:** `[[Category:Hostels]]`.

## Home team (legacy — prefer Organisation path above)

- **Form / template (legacy):** `Form:Home Team` → `{{Infobox Home Team}}`
  (no Cargo storage). For **new** home team main pages, use
  `Form:Organization` → `{{Infobox Organization}}` with `type=Cultural Organisation`
  (or Technical Organisation / Sports Organisation) instead.
- **Yearly sub-pages** still use `Form:Home Team Year` → `{{Home Team Year Report}}`
  (this template is not deprecated).
- **Category:** `[[Category:Home Teams]]` (auto-assigned by `{{Infobox Organization}}`
  for cultural/technical/sports types).

## HowTo guide

- **Title / namespace:** `HowTo:Topic` (use `HowTo/Beginner`, `HowTo/AI` subpages
  where they fit).
- **Category:** `[[Category:HowTo]]`.

## Task (Project Task Board)

- **Title / namespace:** `WIKI FOSSCELL NITC:Tasks/<short title>`.
- **Template:** `{{Task|title=|status=|priority=|category=|description=|created=}}`.
- **Rules:** see [`task-board.md`](task-board.md) for full lifecycle, status transitions, category taxonomy, and conventions.

---

## Quality bar for any new page

- Not empty/placeholder. If genuinely minimal, add `{{Stub}}` and at least one
  real sentence plus a category — never a bare title.
- At least one **category** (see [categories.md](categories.md)).
- The right **infobox/data template** filled from the form/template definition.
- A clear lead sentence in **bold** naming the subject.
- Internal links (`[[...]]`) to related pages; a `== See also ==` where useful.
