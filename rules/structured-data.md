# Structured Data: Cargo, Forms & Semantic MediaWiki

The NITC Wiki is a **structured-data wiki**. Many pages are not just prose — they
store machine-readable data that drives queries, dashboards, and features like the
Main Page's "This day in history." Agents must respect this layer.

Installed extensions: **Cargo**, **Semantic MediaWiki (SMW)**, **Page Forms**,
plus Scribunto (Lua `Module:`), Maps (`GeoJson:`), and Widgets.

---

## The golden rule

**When a structured template or form exists for what you're creating, use it.**
Don't hand-format an event, club, person, or course as free prose — fill in the
matching template so the data lands in Cargo and the page shows up in queries.

---

## Cargo data templates

Some templates declare and populate Cargo tables. Example — `{{Event}}` declares
the `Events` table and stores a row per event:

```wikitext
{{Event
|year=2026
|month=4
|day=10
|description=20th edition of FOSSMeet — keynote by Kailash Nadh
|type=Conference
|organizer=FOSS Cell NITC
}}
```

That single call writes `title/year/month/day/description/type/organizer` into the
`Events` Cargo table. Because of this:

- **Always include `{{Event}}` on event pages** (alongside `{{Infobox FOSSMeet}}`
  or `{{Infobox Event}}`), or the event won't appear in date-based queries.
- **Never change a Cargo-declaring template's fields** casually — it requires a
  table rebuild (`Special:CargoTables` → recreate). Surface to a human.

### Querying Cargo

To list data, use a Cargo query rather than maintaining a manual list:

```wikitext
{{#cargo_query: tables=Events
|fields=title, year, description
|where=type="Hackathon"
|order by=year DESC
}}
```

If you have the MCP Cargo tools available, you can also explore tables directly:
`cargo-list-tables`, `cargo-describe-table`, `cargo-query`.

---

## Page Forms (preferred way to create structured pages)

The wiki defines **Forms** that generate correctly-structured pages. Existing
forms include: `Form:Organization`, `Form:Event`, `Form:FOSSMeet`, `Form:Course`,
`Form:Faculty`, `Form:Person`, `Form:Centre`, `Form:Hostel`, `Form:Home Team`,
`Form:Home Team Year`, `Form:Campus Location`, `Form:SAC Meeting`,
`Form:CCD Year Report`, `Form:Centre Year Report`, `Form:Artwork Submission`,
`Form:Magazine Submission`.

For agents:

- A form is the **authoritative source of a page type's fields**. Before creating
  (say) an organisation page, read `Form:Organization` and the template it wraps to learn the exact
  parameters — don't invent them.
- Humans usually create these via `Special:FormEdit/Organization` (or the project
  "Create a Club" helper pages). When an agent creates the page through the MCP
  `create-page`/`update-page` tools, it should reproduce the **same template call
  the form would have produced**, so the data and the form stay consistent.

---

## Semantic MediaWiki

SMW properties exist (e.g. FOAF/OWL imported vocabulary in `Property:`). Most
structured data on this wiki flows through **Cargo**, so prefer Cargo templates
unless a page clearly uses SMW annotations (`[[Property::value]]`). If MCP SMW
tools are available (`smw-list-properties`, `smw-query`), use them to inspect
before annotating.

---

## Content models — handle with care

| Namespace | Content model | Rule |
|---|---|---|
| `Module:` | Lua (Scribunto) | Code. Don't edit without human review. |
| `GeoJson:` | GeoJSON | Map data; validate JSON. Human review. |
| `smw/schema:` | smw/schema | Schema. Human review. |
| `Widget:` | wikitext (privileged) | Protected (`editwidgets`). |

---

## Checklist before saving a structured page

1. Did I use the matching **infobox** and (for events) the **`{{Event}}`** Cargo
   template?
2. Did I read the **template/form** to get parameter names right (not guess)?
3. Did I add the right **categories** (specific + umbrella)?
4. For events: is the page in the **`YYYY:` namespace** with a redirect from the
   common name?
5. Am I about to modify a **Cargo-declaring template**? If so — stop, surface to a
   human (table rebuild needed).
