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

## Club / organisation

- **Title / namespace:** common name in main namespace (`FOSSCell`).
- **Form / template:** `Form:Club` → `{{Infobox Club}}`
  (`name`, `image`, `type`, `affiliated_with`, `teams`, `flagship_event`).
- **Body:** intro, `== Team Structure ==` (a `{{#mermaid:}}` graph is common),
  `== Events ==`, `== History ==`.
- **Category:** `[[Category:Clubs and Organizations]]`.

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

## Home team

- **Form / template:** `Form:Home Team` / `Form:Home Team Year` →
  `{{Infobox Home Team}}` / `{{Infobox Home Team Year}}`.
- **Category:** `[[Category:Home Teams]]`.

## HowTo guide

- **Title / namespace:** `HowTo:Topic` (use `HowTo/Beginner`, `HowTo/AI` subpages
  where they fit).
- **Category:** `[[Category:HowTo]]`.

## Task (Project Task Board)

- **Title / namespace:** `WIKI FOSSCELL NITC:Tasks/<short title>`.
- **Template:** `{{Task|title=|status=|priority=|category=|description=|created=}}`.

---

## Quality bar for any new page

- Not empty/placeholder. If genuinely minimal, add `{{Stub}}` and at least one
  real sentence plus a category — never a bare title.
- At least one **category** (see [categories.md](categories.md)).
- The right **infobox/data template** filled from the form/template definition.
- A clear lead sentence in **bold** naming the subject.
- Internal links (`[[...]]`) to related pages; a `== See also ==` where useful.
