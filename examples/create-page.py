#!/usr/bin/env python3
"""Create a new page on the NITC Wiki — follows Agents.md write rules.

Usage:
    export WIKI_USERNAME=your-bot-username
    export WIKI_PASSWORD=your-bot-password
    python examples/create-page.py "Page title" "Page content"
"""
import os
import sys
import mwclient

AGENT_NAME = "ExampleBot"
WIKI_URL = "wiki.fosscell.org"

if len(sys.argv) < 3:
    print("Usage: create-page.py <title> <content>")
    sys.exit(1)

title = sys.argv[1]
content = sys.argv[2]

site = mwclient.Site(WIKI_URL, clients_useragent=f"{AGENT_NAME}/1.0 (https://{WIKI_URL}; User:{AGENT_NAME}) mwclient/0.10")

site.login(os.environ["WIKI_USERNAME"], os.environ["WIKI_PASSWORD"])

page = site.pages[title]

# Pre-check: page must not already exist (Agents.md §4)
if page.exists:
    print(f"Page '{title}' already exists. Aborting.")
    sys.exit(1)

summary = f"Bot: Creating page \"{title}\" — {AGENT_NAME}"

# Use bot flag and respect maxlag (Agents.md §4, §7)
page.save(content, summary=summary, bot=True, minor=False)
print(f"Created '{title}'")
