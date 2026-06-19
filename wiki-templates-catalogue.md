# NITC Wiki Template Catalogue

Complete inventory of all 109 templates on `wiki.fosscell.org`, organised by
hierarchy. Templates in bold transclude or depend on the indented templates
below them.

---

## L0 — Parser functions & utilities (used by templates, never directly on pages)

These provide conditional logic, namespace detection, metadata helpers, and
safe substitution. Every template editor should be familiar with them.

### `Template:Category handler`
**Lua** (`#invoke:Category handler`). Routes pages into maintenance categories
based on namespace. Core of the dated-maintenance-category system. Used by
`Dated maintenance category`, `Dead link`, `Ambox`.

### `Template:Documentation`
**Lua** (`#invoke:documentation`). Fetches `/doc` subpage content and transcludes
it beneath the template source. Almost every template with `<noinclude>` uses this.

### `Template:FULLROOTPAGENAME`
Returns the root page name (strips subpages). Used by `Ns has subpages` and
various metadata templates.

### `Template:Ns has subpages`
Checks if the current namespace supports subpages. Used by `FULLROOTPAGENAME`.

### `Template:Template other`
Namespace detector: returns first param if in Template space, second param
otherwise. Used by `Documentation` and utility chains.

### `Template:Main other`
Returns first param if in main (article) namespace, second param otherwise.
Used by `Dead link`, `Find sources mainspace`, etc.

### `Template:Br separated entries`
**Lua** (`#invoke:Separated entries|br`). Renders positional params separated by
`<br/>`. Used by infoboxes for multi-line fields.

### `Template:Dated maintenance category`
Date-aware categorisation. If a date is supplied, generates a dated category
like `Category:Articles with dead external links June 2026`. Also validates
that the category exists. Used by: `Dated maintenance category (articles)`,
`Use dmy dates`, `Use Indian English`.

### `Template:Dated maintenance category (articles)`
Wrapper around `Dated maintenance category` restricted to article namespace
only. Redirect: `Template:DMCA`.

### `Template:Fix`
Standardised inline fix marker with a tooltip. Used by `Dead link`.

### `Template:Fix/category`
Helper that expands dated fix categories. Used by `Fix`.

### `Template:DISPLAYTITLE`
Skeleton — uses parser function directly. Some pages call this to stylise
display titles. Category: SEO and metadata templates.

### `Template:Icon`
Renders an icon / inline marker image.

---

## L1 — Shared formatting & infrastructure

Transcluded by higher-level templates. Do not use directly on content pages.

### `Template:Ambox`
**Lua** (`#invoke:Message box`). Article message box — coloured bar for
maintenance banners. Injected from the Scribunto module. Used by: `Cleanup`,
`Outdated`, `More citations needed`.

### `Template:Infobox`
Generic infobox shell with default table styling. Parent of all `Infobox *`
templates.

### `Template:Navbox`
Standard collapsible navbox table. Parent of: `FOSSMeet Navbox`, `Ragam Navbox`,
`Tathva Navbox`, `LnD Navbox`.

    FOSSMeet Navbox  ─── FOSSMeet Navbox
    Ragam Navbox     ─── Ragam Navbox
    Tathva Navbox    ─── Tathva Navbox
    LnD Navbox       ─── LnD Navbox

### `Template:Nav Tiles`
Responsive grid of navigation cards for the Main Page.
Depends on `Template:Nav Tiles/styles.css` for grid layout.

### `Template:Plainlist`
Wraps content in a `<div class="plainlist">` with no list-style.
Depends on `Plainlist/styles.css`.

### `Template:Reflist`
Renders the references list (`<references />`) in a styled column div.
Depends on `Reflist/styles.css`. Used on every page with `<ref>` tags.

### `Template:SEO`
**WikiSEO**. Thin wrapper around `{{#seo:}}` for setting Open Graph / search-engine
metadata. Most infoboxes call this internally.

### `Template:Hlist/styles.css`
CSS for horizontal lists. Injected by templates that render inline lists.

### `Template:About`
**Lua** (`#invoke:about`). Hatnote for disambiguation ("For other uses, see …").

### `Template:Main`
Hatnote directing to the main article for a subtopic.

### `Template:See also`
Hatnote directing to related articles.

### `Template:Quote`
Blockquote with optional author and source attribution.

### `Template:URL`
**Lua** (`#invoke:URL`). Formats a URL for display with link.

### `Template:Official website`
**Lua** (`#invoke:Official website`). Formats official website link with
icon and domain extraction.

### `Template:Succession`
Succession box (before / years / after). Used on person pages for roles held.

### `Template:Find sources mainspace`
Hatnote for article talk pages ("Find sources about this topic").

### `Template:Timeline`
**EasyTimeline**. MediaWiki version release timeline. Used on meta pages.

### `Template:Use dmy dates`
Adds dated DMCA category `Use dmy dates` + date validation. Depends on:
`Dated maintenance category`.

### `Template:Use Indian English`
Adds dated DMCA category `Use Indian English`. Depends on: `Dated maintenance category`.

### `Template:Cite web`
**Lua** (`#invoke:citation/CS1|citation`). Structured web citation. Depends on
the CS1 Scribunto module (currently broken — needs re-import).

### `Template:Cite news`
**Lua** (`#invoke:citation/CS1|CitationClass=news`). Structured news citation.
Depends on CS1 Scribunto module (currently broken).

### `Template:Dead link`
Inline marker for broken external links. Depends on: `Fix`, `Main other`.

---

## L2 — Data templates & infoboxes (used on content pages)

These are the templates editors use directly. Many store rows in Cargo tables.

### ── Events & Festivals ──

### `Template:Event`
**Cargo** (`Events` table). Every event page **must** include this to appear
in "This Day in History". Fields: year, month, day, description, type,
organizer. Used alongside one of the infoboxes below.

**Subpages:**
- `Template:Event/preload` — preload form for creating event pages

### `Template:Infobox Event`
Generic infobox for recurring events (Ragam, Tathva, TEDxNITC). Fields:
name, logo, type, institution, first_held, frequency, venue, organizer,
attendance, website, previous, next. *For FOSSMeet use `Infobox FOSSMeet`
instead.*

### `Template:Infobox FOSSMeet`
Comprehensive infobox for FOSSMeet edition pages. 50+ fields covering
identity, dates, venue, key people, statistics, online presence, media,
and navigation (prev/next).

### `Template:Infobox recurring event`
Generic infobox for events that repeat periodically.

### `Template:Infobox sport overview`
Infobox for a sport's overview page.

### `Template:This day in history`
**Cargo query**. Queries `Events` table for today's month/day. Renders
results via `This day in history/item`. **Main Page component.**

    This day in history
        This day in history/item

### `Template:Upcoming events`
**Cargo query**. Queries `Events` table for future dates. Renders results
via `Upcoming events/item`. **Main Page component.**

    Upcoming events
        Upcoming events/item

### ── Clubs & Organisations ──

### `Template:Infobox Club`
**Cargo** (`Clubs` table). Fields: name, shortname, type, founded,
faculty_advisor, flagship_event, status, website, social links, etc.
Includes `{{#seo:}}` metadata. Used on club pages (FOSSCell, GLUG, etc.).

**Preload:** `Template:Infobox Club/preload`

### `Template:Infobox Home Team`
Infobox for NITC home teams (cultural, technical, sports). Fields: name,
type, discipline, founded, batch_size, induction_year, parent_fest, etc.

### `Template:Infobox Home Team Year`
Infobox for home team yearly report pages (e.g. `2026:NITC Mime Team`).
Fields: team, year, batch, captain, members, achievements, project.

**Preload:** `Template:Infobox Home Team Year/preload`

### `Template:Home Team Year Report`
Full-page layout for home team yearly reports. Generates section headings
and a table for team members.

### `Template:Home Team Year Tabs`
Tab navigation for home team year pages. Auto-detects base.

### `Template:Community`
**Cargo** (`Communities` table). Rich profile card for informal interest
groups (no hierarchy, no inductions). Fields: name, interest, platform,
platform_link, founded, origin, parent, members, status.

**Preload:** `Template:Community/preload`

### `Template:FOSSMeetTeam`
Comprehensive team roster table for FOSSMeet editions. Sections: Core Team,
Technical, Media & Outreach, Events & Logistics, Volunteers.

### ── People ──

### `Template:Infobox Person`
Infobox for notable individuals (alumni, guests, staff). Fields: name,
affiliation, role, known_for, birth/death, alma_mater, nitc_connection,
batch, department, projects, fossmeet_editions, events_organized, etc.

### `Template:Infobox Faculty`
Infobox for faculty members. Fields: name, designation, department,
qualification, specialization, office, phone, email, website, Google Scholar,
Scopus, ORCID, joined_institution, awards, publications, PhD students, etc.

### `Template:User Profile`
**Cargo** (`UserProfiles` table). Rich profile card for user pages.
Fields: name, batch, passing_out, department, quote, about, interests,
clubs, image, links, scrapbook. Supports magazine scrapbook integration.

**Preload:** `Template:User Profile/preload`

### `Template:User Profile Card`
Compact profile card for the scrapbook grid display. Renders one user
profile as a card from Cargo query results.

### `Template:Succession`
See L1. Used on person pages to show role succession.

### ── Campus Buildings & Hostels ──

### `Template:Infobox Building`
Infobox for campus buildings, labs, and landmarks. Fields: name, image,
type, namesake, built, renovated, floors, capacity, occupants, facilities,
zone, coordinates.

### `Template:Infobox Campus Location`
**Cargo** (`CampusLocations` table). Infobox for campus locations with
map support. Includes coordinate-based mini-map via `#display_map:`.
Fields: name, type, campus, coordinates, status, established, area, etc.

**Preload:** `Template:Infobox Campus Location/preload`

### `Template:Infobox Hostel`
Infobox for hostels. Fields: name, image, campus, gender, residents,
established, floors, room_types, total_rooms, capacity, mess, warden,
amenities, coordinates.

**Preload:** `Template:Infobox Hostel/preload`

### ── Courses & Academics ──

### `Template:Infobox Course`
Infobox for courses. Fields: name, code, department, type, credits,
lecture/tutorial/practical hours, total_hours, semester, offered_to,
prerequisites, tools, instructor, textbook, syllabus_year.

### ── Centres & Reports ──

### `Template:Infobox Centre`
**Cargo** (`Centres` table). Infobox for NITC multidisciplinary centres.
Fields: name, shortname, established, chairperson, type, website, email,
contact, description. Includes `{{#seo:}}` metadata.

**Preload:** `Template:Infobox Centre/preload`

### `Template:Centre Year Report`
Infobox for centre yearly report pages. Fields: centre, year, chairperson,
activities, achievements, events, collaborations, publications.

**Preload:** `Template:Centre Year Report/preload`

### `Template:CCD Year Report`
Infobox for CCD (Career Development) annual placement reports. Fields:
year, companies_visited, total_offers, UG/PG/PhD placement stats, salary
figures, internship data, notable recruiters.

**Preload:** `Template:CCD Year Report/preload`

### `Template:Mime Team Member`
**Cargo** (`MimeTeamMembers` table). Logs an individual's contribution to
the NITC Mime Team for a given year.

### `Template:Mime Team Year Report`
Report page template for Mime Team yearly activities.

### `Template:Office Year Report`
Full-page layout for Student Affairs office yearly reports. Generates the
entire page structure with members table, activities table, and manifesto
link. Used by Cultural, Technical, and Sports offices.

### ── Student Affairs ──

### `Template:Infobox SAC Meeting`
Infobox for Students' Affairs Council meeting minutes. Fields for meeting
date, agenda, decisions, attendees.

### `Template:Infobox Office`
Infobox for Student Affairs offices (Cultural, Technical, Sports). Fields:
name, type, image, established, faculty_advisor, secretary.

### `Template:Office Year Report`
Full-page layout for office yearly reports (see Centres section).

### ── Book Club ──

### `Template:Book Club Meeting`
**Cargo** (`BookClubMeetings` table). Rich template for LnD Book Club
meetings. Lifecycle stages: suggestions-open → reading-period → completed.
Features infobox, status badges, lifecycle timeline, and prev/next
navigation. Fields: theme, month, year, academic_year, status,
meeting_date, venue, facilitator, attendee_count, books_count, summary.

**Preload:** `Template:Book Club Meeting/preload`

### `Template:LnD Year`
Wrapper for Literary & Debate Club yearly pages.

### `Template:LnD Navbox`
Bottom navigation for LnD sub-pages.

### ── FOSSCell ──

### `Template:FOSSCell Event`
**Cargo** (`FOSSCellEvents` table). Full event card for FOSSCell events
(Git Workshop, Install Fest, etc.). Automatically pulls member contributions
from the `FOSSCellActivities` table. Fields: title, type, date, end_date,
venue, year, academic_year, description, attendee_count, status.

**Preload:** `Template:FOSSCell Event/preload`

### `Template:FOSSCell Event Card`
Compact card for rendering FOSSCell events in lists. Colour-coded by type.

### `Template:FOSSCell Activity`
**Cargo** (`FOSSCellActivities` table). Logs one person's contribution to
a FOSSCell event. Placed on a user subpage; auto-appears on the event page
through Cargo query. Fields: title, contributor, type, year, date,
description, event, role, links.

**Preload:** `Template:FOSSCell Activity/preload`

### `Template:FOSSCell Activity Card`
Renders one FOSSCell Activity entry as a card.

### `Template:FOSSMeet Latest`
Resolves to `{{CURRENTYEAR}}:FOSSMeet`. Auto-updates every January 1st.

### `Template:Foss-meet-at-nitc`
Legacy FOSSMeet navbox. Superseded by `FOSSMeet Navbox`.

### ── Magazine ──

### `Template:Magazine Submission`
**Cargo** (`MagazineSubmissions` table). Submission entry for the NITC
Wiki Magazine. Fields: title, type, year, author, description, content,
links, status.

**Preload:** `Template:Magazine Submission/preload`

### `Template:Magazine Entry Card`
Renders one magazine submission as a card in the magazine index.

### ── Campaigns & Outreach ──

### `Template:Campaign`
Eye-catching banner for Main Page campaigns. Gradient background, icon,
title, description, CTA button, optional tag badge. Used for: Saving
Stories campaign, Magazine submissions drive.

### `Template:Hall of Fame`
Hall of Fame display template.

### `Template:Mental Health Week`
Mental Health Week campaign page template.

### ── Wiki Admin ──

### `Template:Wiki Admin Team`
Full-page layout for the Wiki Admin Team yearly roster. Takes a lead and
HTML table rows for members.

### `Template:Task`
**Cargo** (`WikiTasks` table). Task board entry. Fields: title, status
(open/claimed/in-progress/review/done/cancelled), priority (low/medium/high/
critical), category (team routing), assignee, deadline, description,
created_date. Renders a priority-coloured card.

**Preload:** `Template:Task/preload`

### `Template:Task Card`
Compact card for rendering task board items. Colour-coded by team category.
Used by the Task Board's `{{#cargo_query:}}` calls.

### ── HowTo ──

### `Template:HowTo`
Layout wrapper for HowTo namespace pages. Provides standardised section
structure and categorisation.

---

## L3 — Navigation templates

### Event navigation
```
FOSSMeet Navbox   — bottom nav, all editions + meta links → uses Navbox
FOSSMeet Tabs     — top tab bar: Main, Schedule, Speakers, Team, etc.
Ragam Navbox      — bottom nav, all editions → uses Navbox
Ragam Tabs        — top tab bar: Main, Schedule, Competitions, etc.
Tathva Navbox     — bottom nav, all editions → uses Navbox
Tathva Tabs       — top tab bar: Main, Schedule, Events, Workshops, etc.
```

### Other navigation
```
LnD Navbox         — bottom nav for Literary & Debating Club
Home Team Year Tabs — top tabs for home team year pages
National Institutes of Technology — navbox linking NIT pages
Nav Tiles          — responsive grid of links (Main Page)
Nav Tiles/styles.css — grid CSS for Nav Tiles
```

---

## L4 — Main Page components

Used only on the Main Page (`WIKI FOSSCELL NITC:Main Page`):

```
Template:Main Page Section — section wrapper
Template:Main page         — Main Page layout shell
Template:This day in history — Cargo-powered today-in-history
Template:Upcoming events   — Cargo-powered future events list
Template:Featured Article  — highlighted article card with image
Template:Recent Activity   — links to RecentChanges / NewPages / Log
Template:Quick Links       — responsive grid of navigation cards
Template:Campaign          — campaign banners
Template:Trending Pages    — curated top-pages list
Template:Whos Online       — transcludes Special:WhosOnline
```

---

## L5 — Maintenance templates

Place on content pages to flag issues. Colour-coded and auto-categorising.

```
Template:Stub        — short/incomplete page. Adds Category:Stubs.
Template:Cleanup     — needs formatting or structure fixes
Template:Outdated    — content may be out of date
Template:More citations needed — insufficient references
Template:Dead link   — specific external link is broken
```

These use `Dated maintenance category` and `Category handler` for dated
sub-categorisation.

---

## L6 — Preload pages (subpages)

Used by Page Forms and InputBox `preload=` parameter. Transcluded when
creating new pages. Each stores a blank row in its Cargo table (known issue:
see cargo-auditor skill).

```
Template:Book Club Meeting/preload
Template:CCD Year Report/preload
Template:Centre Year Report/preload
Template:Community/preload
Template:Event/preload
Template:FOSSCell Activity/preload
Template:FOSSCell Event/preload
Template:Infobox Campus Location/preload
Template:Infobox Centre/preload
Template:Infobox Club/preload
Template:Infobox Home Team/preload
Template:Infobox Home Team Year/preload
Template:Infobox Hostel/preload
Template:Magazine Submission/preload
Template:Task/preload
Template:User Profile/preload
```

---

## L7 — Sandbox / test / legacy

```
Template:Sandbox/TestAccess — sandbox for testing
Template:Header1            — early wiki template, likely unused
Template:Infobox sport overview — from imported Wikipedia content
Template:Foss-meet-at-nitc  — legacy FOSSMeet navbox (replaced by Navbox)
```

---

## Hierarchy reference (full tree)

```
Utility layer
    ├── Category handler (Lua)
    ├── Documentation (Lua)
    ├── FULLROOTPAGENAME
    ├── Ns has subpages
    ├── Template other
    ├── Main other
    ├── Br separated entries (Lua)
    ├── Dated maintenance category
    │   └── Dated maintenance category (articles)
    ├── Fix
    │   └── Fix/category
    └── DISPLAYTITLE

Formatting layer
    ├── Ambox (Lua)
    ├── Icon
    ├── Infobox (generic shell)
    ├── Navbox
    │   ├── FOSSMeet Navbox
    │   ├── Ragam Navbox
    │   ├── Tathva Navbox
    │   └── LnD Navbox
    ├── Nav Tiles + /styles.css
    ├── Plainlist
    ├── Reflist + /styles.css
    ├── SEO
    ├── Hlist/styles.css
    ├── About, Main, See also (hatnotes)
    ├── Quote
    ├── URL, Official website (Lua)
    ├── Succession
    ├── Find sources mainspace
    ├── Timeline
    ├── Use dmy dates, Use Indian English
    ├── Cite web, Cite news (Lua — broken)
    └── Dead link

Event system
    ├── Event (Cargo)
    │   ├── /preload
    │   └── → This day in history
    │       └── → This day in history/item
    ├── Infobox Event
    ├── Infobox FOSSMeet
    ├── Infobox recurring event
    ├── Infobox sport overview
    └── Upcoming events
        └── → Upcoming events/item

Clubs & communities
    ├── Infobox Club (Cargo) + /preload
    ├── Community (Cargo) + /preload
    ├── Infobox Home Team
    ├── Infobox Home Team Year + /preload
    ├── Home Team Year Report
    └── Home Team Year Tabs

People
    ├── Infobox Person
    ├── Infobox Faculty
    └── User Profile (Cargo) + /preload
        └── User Profile Card

Campus
    ├── Infobox Building
    ├── Infobox Campus Location (Cargo) + /preload
    └── Infobox Hostel + /preload

Centres & reports
    ├── Infobox Centre (Cargo) + /preload
    ├── Centre Year Report + /preload
    ├── CCD Year Report + /preload
    ├── Mime Team Member (Cargo)
    ├── Mime Team Year Report
    └── Office Year Report

FOSSCell
    ├── FOSSCell Event (Cargo) + /preload
    │   └── FOSSCell Event Card
    ├── FOSSCell Activity (Cargo) + /preload
    │   └── FOSSCell Activity Card
    ├── FOSSMeet Latest
    └── FOSSMeetTeam

Task board
    ├── Task (Cargo) + /preload
    └── Task Card

Magazine
    ├── Magazine Submission (Cargo) + /preload
    └── Magazine Entry Card

Navigation
    ├── Event Tabs (FOSSMeet, Ragam, Tathva)
    ├── Event Navboxes (FOSSMeet, Ragam, Tathva, LnD)
    └── National Institutes of Technology

Main Page
    ├── Main Page Section
    ├── Main page
    ├── Featured Article
    ├── Recent Activity
    ├── Quick Links
    ├── Campaign
    ├── Trending Pages
    ├── Whos Online
    └── This day in history / Upcoming events (see Event system)

Maintenance
    ├── Stub
    ├── Cleanup
    ├── Outdated
    ├── More citations needed
    └── Dead link (see Formatting layer)

Misc
    ├── Book Club Meeting (Cargo) + /preload
    ├── LnD Year
    ├── HowTo
    ├── Hall of Fame
    ├── Mental Health Week
    ├── Wiki Admin Team
    ├── Sac (student info)
    ├── Sandbox/TestAccess
    ├── Header1
    └── Foss-meet-at-nitc (legacy)
```

---

*Generated 2026-06-19 from live wiki scan. 109 templates total
(including preload subpages and CSS subpages).*
