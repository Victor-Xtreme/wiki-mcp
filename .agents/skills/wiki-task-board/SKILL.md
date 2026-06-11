---
name: wiki-task-board
description: Work with the NITC Wiki task board. Find open tasks, claim or update them, mark them done, and create new tasks under the WIKI FOSSCELL NITC project namespace using Template:Task and the WikiTasks Cargo table. Use when asked what needs doing on the wiki, to pick up or assign a task, or to log new work.
---

# Wiki Task Board

Use this skill to work with the **task board** on `wiki.fosscell.org`. Tasks
are wiki pages that store rows in the `WikiTasks` Cargo table, so the board
is queryable.

---

## Where tasks live

```
WIKI FOSSCELL NITC:Tasks/<Short task name>
```

(Project namespace, ID 4.) Live examples:

- `WIKI FOSSCELL NITC:Tasks/Mass categorize uncategorized pages`
- `WIKI FOSSCELL NITC:Tasks/Backfill FOSSMeet historical data`
- `WIKI FOSSCELL NITC:Tasks/Create department infobox`

---

## The Task template

Each task page is a single `{{Task}}` call. Live example:

```wikitext
{{Task
|title=Mass-categorize ~257 uncategorized pages
|status=open
|priority=high
|category=content
|description=The wiki has ~257 pages with no categories. Work through
Special:UncategorizedPages in batches of 50. Add appropriate categories
from the established category tree.
|created=2026-05-24
}}
```

The `WikiTasks` Cargo schema also has `assignee` (String) and `deadline`
(Date), settable as `|assignee=` and `|deadline=`. Read `Template:Task` on
the live wiki before writing to confirm the accepted values for `status`,
`priority`, and `category`; observed values so far are `status=open`,
`priority=high|medium|low`, `category=content|technical|admin`.

---

## Querying the board

The `cargo-query` API tool is permission-restricted for regular accounts.
Use a `{{#cargo_query:}}` parser function through `parse-wikitext` instead
(see the `cargo-auditor` skill for the full technique):

List open tasks, highest priority first:

```
{{#cargo_query:tables=WikiTasks
|fields=_pageName,task_title,priority,assignee,deadline
|where=status='open'
|order by=priority
|format=ul}}
```

Unassigned open tasks (good for "what can I pick up?"):

```
{{#cargo_query:tables=WikiTasks|fields=_pageName,task_title,priority|where=status='open' AND assignee=''|format=ul}}
```

Tasks assigned to a specific person:

```
{{#cargo_query:tables=WikiTasks|fields=_pageName,task_title,status|where=assignee='Vysakh'|format=ul}}
```

---

## Workflows

### Pick up a task

1. Query unassigned open tasks (above) and let the human choose, or match
   the task to what they asked for.
2. `whoami` to get the acting username.
3. Fetch the task page, add `|assignee=<username>` to the `{{Task}}` call,
   and save with summary `Claim task - <agent>`.

### Complete a task

1. Fetch the task page and confirm the work described is actually done.
2. Change `|status=` to the completed value (check `Template:Task`; do not
   guess a value the template does not render).
3. Save with summary `Mark task done - <agent>`.

### Create a task

1. Check it does not already exist: query `WikiTasks` for a similar
   `task_title`, and `get-page` the planned title.
2. Create `WIKI FOSSCELL NITC:Tasks/<Short name>` containing one `{{Task}}`
   call. Always set `title`, `status=open`, `priority`, `category`,
   `description`, and `created=<today, YYYY-MM-DD>`.
3. Keep `description` self-contained: someone (or some agent) with no other
   context should be able to act on it.

### Report board health

Combine queries into a short report: open count by priority, stale tasks
(created long ago, still open, no assignee), and tasks past their
`deadline`. Useful as a recurring check.

---

## Rules

- One task per page; one `{{Task}}` call per page.
- Do not delete task pages; close them by status change so history stays.
- Tasks that require admin rights (blocks, template-namespace edits) can be
  created by anyone but only executed by an admin; say so in the
  description.
- Show the human the proposed `{{Task}}` wikitext before creating new tasks.

## Authoritative references

- `Template:Task` on the live wiki - field names and accepted values.
- `rules/page-types.md` - "Task (Project Task Board)" section.
- `.agents/skills/cargo-auditor` - the parser-function query technique.
- `Agents.md` - write rules and review protocol.
