---
name: meeting-processor
description: Convert meeting transcripts into structured meeting minutes on the NITC Wiki and create individual task pages in the WikiTasks Cargo table, deduplicating against existing tasks. Use when a user provides a meeting transcript (Google Meet/Gemini notes or similar) and wants minutes generated plus action items tracked on the task board.
---

# Meeting Transcript → Minutes + Tasks

Converts a meeting transcript (from Google Meet/Gemini or similar) into a
structured Meeting Minutes page on the wiki and creates individual task pages
in the WikiTasks Cargo table, deduplicating against existing tasks.

---

## Input format

The skill expects a transcript with these sections (Gemini note-taking format):

```
Meeting <date> at <time> IST
Meeting records Transcript


Summary
...

Decisions
...

Next steps
[Name] Action item description
[Name] Action item description
...

Details
=== Topic Heading ===
Narrative with timestamps (00:03:15)
...
```

If the transcript format differs significantly, adapt the parsing rules
accordingly or ask the human for clarification.

---

## Data sources

1. **Transcript** — provided by the user (the trigger).
2. **Team roster** — `WIKI FOSSCELL NITC:Wiki Admin Team/2026-27` page for
   username → team → category mapping.
3. **WikiTasks Cargo table** — queried via `parse-wikitext` with
   `{{#cargo_query:}}` for dedup checks.
4. **Template:Task** — used as-is for creating task pages.

---

## Step-by-step

### 1. Parse the transcript

Extract from the user-provided transcript:

- **Meeting date & time** — from the first lines.
- **Attendees** — infer from names appearing in Next steps and Details.
- **Summary** — the paragraph(s) under "Summary".
- **Decisions** — each line under "Decisions".
- **Next steps** — each `[Name] Task description` line.
- **Details** — each `=== Topic ===` section with its narrative.
- **Group items** — lines starting with `[The group]` in Next steps treated as group assignments.

### 2. Fuzzy-match names to wiki usernames

For each unique name found in Next steps and Details:

1. Try `search-page-by-prefix("User:<name>")`.
2. If no direct match, try the last word of the name (e.g. "Thomas" for
   "Joshua Jacob Thomas").
3. If still no match, try the first word as a `User:` page search.
4. If ambiguous (multiple matches) or no match at all → **ask the human**.

**Known mapping (for reference — fuzzy match should find these):**

| Transcript name | Wiki username |
|---|---|
| Vysakh Premkumar | Vysakh |
| H R SOORYA DEV | H_R_Soorya_Dev |
| Ajay AB | Ajayab |
| Fadil Hasan | Fadil |
| BATHULA LOHITH | Lohith |
| Benjamin Mathew | Benjammer |
| Joshua Jacob Thomas / Josh | Jay_Jay_Tee |
| Pridhul Sagar | Pridhul Sagar |

### 3. Create the Meeting Minutes page

**Title:** `WIKI FOSSCELL NITC:Meetings/YYYY-MM-DD`

(Note: if a meeting already exists for this date, append `-2`, `-3`, etc.)

**Wikitext format:**

```wikitext
== Meeting Info ==
* '''Date:''' YYYY-MM-DD
* '''Time:''' HH:MM IST
* '''Source:''' Google Meet transcript

== Attendees ==
* [[User:Username|Display Name]]
...

== Summary ==
(transcript Summary)

== Decisions ==
# Decision 1
# Decision 2

== Discussion ==
=== Topic 1 ===
Narrative... (00:03:15)

=== Topic 2 ===
Narrative... (00:07:02)
...

== Action Items ==
{| class="wikitable"
! Task !! Assignee !! Priority !! Status
|-
| [[WIKI FOSSCELL NITC:Tasks/<slug>|Title]] || Assignee || high/med/low || open
...
|}
```

Use `create-page` to create the minutes page.

**Before saving, show the human the proposed wikitext** (review protocol).

### 4. Extract action items

#### From Next steps (primary)

Each `[Name] Task description` line becomes an action item.

- **Assignee:** mapped username from Step 2.
- **Description:** the task description text.
- **Priority heuristic (applied to task title & description):**

  | Keyword | Priority |
  |---|---|
  | `fix`, `resolve`, `complete`, `finish`, `implement`, `configure`, `deploy`, `build`, `create`, `setup` | **high** |
  | `recruit`, `collect`, `send`, `remind`, `check`, `ask`, `poll`, `review` | **low** |
  | everything else | **medium** |

#### Deadline extraction

For each action item (from both Next steps and Details), scan the
description for deadline cues and parse them relative to the meeting date:

| Pattern | Example | Computed deadline |
|---|---|---|
| `by <date>` | "by 2026-06-25" or "by June 25" | That date |
| `within <N> days` | "within 3 days" | Meeting date + N |
| `within <N> weeks` | "within 2 weeks" | Meeting date + N×7 |
| `by <dayname>` | "by Friday", "by Monday" | Next occurrence of that day |
| `before next meeting` | "before next meeting" | Meeting date + 7 |
| `this week` | "this week" | Meeting date + (6 - day_of_week) → Saturday |
| `tomorrow` | "by tomorrow" | Meeting date + 1 |
| `next week` | "next week" | Meeting date + 7 |
| `by end of <month>` | "by end of June" | Last day of that month |

Where the meeting date is known (from Step 1), compute the deadline as a
`YYYY-MM-DD` string. If the pattern is ambiguous or cannot be reliably
parsed, leave `deadline` empty.

Set the parsed deadline in the task's `deadline` field.

#### From Details (conservative)

- "committed to [doing X]"
- "will [do X]"
- "going to [do X]"
- "plan to [do X]"
- "plans to [do X]"
- "will handle [X]"
- "take on [X]"
- "will take on [X]"

If found, check against the Next-steps list to avoid duplicates. If unique,
create an action item with **medium** priority (unless context suggests
higher, e.g. "urgent" or "blocker" language).

### 5. Deduplicate against existing tasks

For each extracted action item:

1. Search WikiTasks via `parse-wikitext`:
   ```
   {{#cargo_query:tables=WikiTasks
   |fields=_pageName,task_title,status
   |where=task_title LIKE '%keyword%' AND status!='done' AND status!='cancelled'
   |format=ul
   |limit=10}}
   ```
   Use the first 2-3 significant keywords from the action item as the search
   term. Try multiple keyword combinations if the first yields no results.

2. If a matching active (non-done, non-cancelled) task exists:
   - **Skip creation.**
   - Note in the minutes page:
     `Already tracked by [[WIKI FOSSCELL NITC:Tasks/<existing>|existing task]]`.

3. If no match found, proceed to create.

### 6. Create task pages

For each unique (non-duplicate) action item:

**Title:** `WIKI FOSSCELL NITC:Tasks/Mtg-YYYY-MM-DD-<Short-slug>`

The slug should be a clean, hyphenated summary of the task (e.g.
`Fix-Images`, `CI-Workflow`, `Course-Page-Cargo-Table`). Keep it under
~40 chars.

**Content:**
```wikitext
{{Task
|title=<Description of the task>
|status=open
|priority=<high|medium|low>
|category=<inferred team category>
|assignee=<wiki username>
|deadline=<YYYY-MM-DD or leave empty>
|description=<Context from the transcript, expanded for actionability>
|created=YYYY-MM-DD
}}
```

If a deadline was extracted in Step 4 (from patterns like "within 3 days"
or "by Friday"), populate the `|deadline=` field. Otherwise leave it empty.

**Category inference (from team roster):**

| Team | Category |
|---|---|
| Lead | `mcp-admins` |
| MCP | `mcp-admins` |
| Templates | `template-admins` |
| App | `app-dev` |
| PRC | `prc` |
| Social Media | `social-media` |
| Video | `video-editors` |

If the member is not found in the team roster, leave `category` empty.

Use `create-page` to create the task page.

**Before saving, show the human each proposed `{{Task}}` content** (review
protocol). Batch all proposed tasks into a single message and ask:
"Create all N tasks? (Y/N)"

### 7. Update the minutes page with task links

Append the Action Items table to the minutes page listing all created and
skipped tasks:

```
== Action Items ==
{| class="wikitable"
! Task !! Assignee !! Priority !! Status
|-
| [[WIKI FOSSCELL NITC:Tasks/Mtg-2026-06-21-Fix-Images|Fix image rendering]] || Vysakh || high || open
|-
| ''Already tracked by [[WIKI FOSSCELL NITC:Tasks/Some-task|existing task]]'' || — || — || —
|}
```

Use `update-page` with edit-conflict detection (`latestId` from the initial
`create-page` response).

---

## Which items to skip

| Condition | Action |
|---|---|
| Assignee is `[The group]` | Skip entirely |
| Similar active task exists in WikiTasks | Skip, note existing link in minutes |
| Task clearly already done (completed language in transcript) | Skip entirely |
| Assignee name cannot be mapped (after asking human) | Skip, flag in minutes as "unassigned" |

---

## Review protocol

Per `Agents.md §8`, the skill must pause and surface to the human:

1. **Before creating the minutes page** — show the proposed wikitext.
2. **Before creating any task page** — show the proposed `{{Task}}` content.
3. **When a name cannot be matched** — show the name and possible matches,
   ask for clarification.
4. **When multiple tasks are ready** — batch confirm: "Create all N tasks?"

---

## Edit summaries

| Action | Summary |
|---|---|
| Create minutes page | `Bot: Add meeting minutes for YYYY-MM-DD — meeting-processor` |
| Create task page | `Bot: Create task from meeting YYYY-MM-DD — meeting-processor` |
| Update minutes with links | `Bot: Link action items on minutes — meeting-processor` |

---

## Related skills & references

- `wiki-task-board` — task creation, status updates, and board queries.
- `eod-status-report` — team roster parsing and name cross-referencing.
- `Agents.md` — master rules, review protocol (§8), edit summary format (§1).
- `rules/namespaces.md` — naming conventions.
- `Template:Task` on the live wiki — field names and accepted values.
