#!/usr/bin/env python3
"""Upload a file to the NITC Wiki — follows Agents.md upload rules.

Usage:
    export WIKI_USERNAME=your-bot-username
    export WIKI_PASSWORD=your-bot-password
    python examples/upload-file.py /path/to/image.png "Description text"
"""
import os
import sys
import mwclient

AGENT_NAME = "ExampleBot"
WIKI_URL = "wiki.fosscell.org"

if len(sys.argv) < 3:
    print("Usage: upload-file.py <filepath> <description>")
    sys.exit(1)

filepath = sys.argv[1]
description = sys.argv[2]

if not os.path.isfile(filepath):
    print(f"File not found: {filepath}")
    sys.exit(1)

site = mwclient.Site(WIKI_URL, clients_useragent=f"{AGENT_NAME}/1.0 (https://{WIKI_URL}; User:{AGENT_NAME}) mwclient/0.10")

site.login(os.environ["WIKI_USERNAME"], os.environ["WIKI_PASSWORD"])

filename = os.path.basename(filepath)
summary = f"Bot: Uploading {filename} — {AGENT_NAME}"

# Agents.md §5: upload must include a license tag
file_comment = f"{description}\n\n{{{{CC-BY-SA-4.0}}}}"

site.upload(filepath, filename, description=file_comment, summary=summary)
print(f"Uploaded '{filename}'")
