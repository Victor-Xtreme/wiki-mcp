#!/usr/bin/env python3
"""List all pages in a category on the NITC Wiki — read-only, no auth needed."""
import sys
import mwclient

AGENT_NAME = "ExampleBot"
WIKI_URL = "wiki.fosscell.org"

site = mwclient.Site(WIKI_URL, clients_useragent=f"{AGENT_NAME}/1.0 (https://{WIKI_URL}; User:{AGENT_NAME}) mwclient/0.10")

cat_name = sys.argv[1]
cat = site.categories[cat_name]

for page in cat:
    print(f"  {page.name}")
