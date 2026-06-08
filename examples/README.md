# Example Bot Scripts

These example scripts demonstrate how to interact with the NITC Wiki via the MediaWiki API following the rules in `Agents.md`.

## Prerequisites

```bash
pip install mwclient
```

## Scripts

| Script | Demonstrates | Auth required |
|---|---|---|
| `fetch-page.py` | Reading page content with proper User-Agent | No |
| `create-page.py` | Creating a new page with correct edit summary | Yes |
| `upload-file.py` | Uploading a file with license tag | Yes |
| `list-category.py` | Listing members of a category | No |

## Usage

```bash
export WIKI_USERNAME=your-bot-username
export WIKI_PASSWORD=your-bot-password

python examples/fetch-page.py "Main Page"
python examples/create-page.py "Sandbox/Test" "== Hello =="
python examples/list-category.py "Events"
```

All scripts follow the conventions in [`Agents.md`](../Agents.md): proper User-Agent, edit summaries in `Bot: <action> — <agent-name>` format, and `maxlag` handling.
