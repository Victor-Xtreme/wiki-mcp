# Template Rules

Which templates agents may use on the NITC Wiki. **This list is verified against
the live `Template:` namespace** — these templates actually exist. Citation
templates (`Cite web`, etc.) are *not yet imported*, so don't assume them.

> Many of these are **Cargo data templates**: filling them in stores structured
> data that powers queries and features like "This day in history." Always prefer
> the right structured template over hand-rolled formatting. See
> [structured-data.md](structured-data.md).

---

## Infobox & data templates (by page type)

| Template | Use on | Notes |
|---|---|---|
| `{{Infobox Club}}` | Club / organisation pages | params: `name`, `image`, `type`, `affiliated_with`, `teams`, `flagship_event` |
| `{{Infobox FOSSMeet}}` | FOSSMeet edition pages | edition/year/dates/venue/keynote/etc. |
| `{{Infobox Event}}` | General event pages | |
| `{{Infobox Person}}` | People | |
| `{{Infobox Faculty}}` | Faculty | |
| `{{Infobox Course}}` | Courses | |
| `{{Infobox Building}}` | Academic/campus buildings | |
| `{{Infobox Campus Location}}` | Campus places | |
| `{{Infobox Hostel}}` | Hostels | |
| `{{Infobox Home Team}}`, `{{Infobox Home Team Year}}` | Home teams | |
| `{{Infobox Centre}}` | Centres | |
| `{{Infobox SAC Meeting}}` | SAC meeting minutes | |
| `{{Event}}` | **Any event page** | Cargo-stores to the `Events` table; enables "This day in history". Pair with the matching infobox. |
| `{{Community}}` | Community/interest-group pages | |
| `{{Task}}` | Project Task Board entries | `title`, `status`, `priority`, `category`, `description`, `created` |

> **Don't guess parameters.** Before filling an infobox, read its template page
> (`get-page` on `Template:Infobox X`) or the matching `Form:X` to get the exact,
> current parameter names. Parameters change; the template/form is the source of truth.

## Maintenance & status templates

| Template | Purpose |
|---|---|
| `{{Stub}}` | Marks a short/incomplete page; adds it to `Category:Stubs`. |
| `{{Cleanup}}` | Page needs formatting/structure fixes. |
| `{{Outdated}}` | Content is out of date. |

There is no `{{Under construction}}` or generic `{{Infobox}}` on this wiki — use
the specific templates above.

---

## Citations

CS1/Citation modules are **not yet imported** (it's an open task). Until then:

- Cite inline with `<ref>` tags containing a plain external link and source name:
  ```wikitext
  <ref>[https://example.com Example Source], retrieved 2026-06-09.</ref>
  ```
- Put `<references />` under a `== References ==` heading.
- Do **not** add `{{Cite web}}` / `{{Cite book}}` / `{{Reflist}}` — they don't
  resolve yet and will render as red links.

---

## Creating or editing templates

Templates are the wiki's structured-data backbone and live in a protected
namespace. Treat them as code:

1. **Reuse first.** Check for an existing template before making a new one.
2. **Do not edit a live template** that pages depend on without human review —
   a bad edit can break every page that transcludes it (and its Cargo table).
3. If a template declares a Cargo table (`{{#cargo_declare:}}`) or stores data
   (`{{#cargo_store:}}`), changing fields requires a Cargo table rebuild — always
   surface this to a human.
4. Document parameters in a `<noinclude>` section; categorise the template under
   `Category:Infobox templates`, `Category:Maintenance templates`, etc.
5. Use `<includeonly>` / `<noinclude>` correctly so docs don't leak into pages.

## Never touch without written approval

- Core layout/navigation: `Main Page` and its sub-templates, navbox/tab templates,
  anything in `Category:Main Page templates` or `Category:Navigation templates`.
- Any `Template:` that declares or stores a Cargo table.
- `MediaWiki:` system messages, `Widget:` and `Module:` code.
