#!/usr/bin/env python3
"""Fetch a page from the NITC Wiki — read-only, no auth needed."""
import sys
import mwclient

AGENT_NAME = "ExampleBot"
WIKI_URL = "wiki.fosscell.org"

site = mwclient.Site(WIKI_URL, clients_useragent=f"{AGENT_NAME}/1.0 (https://{WIKI_URL}; User:{AGENT_NAME}) mwclient/0.10")

page = site.pages[sys.argv[1]]
if not page.exists:
    print(f"Page '{page.name}' does not exist.")
    sys.exit(1)

print(f"Title: {page.name}")
print(f"Last revised: {page.edit_time}")
print("---")
print(page.text())
