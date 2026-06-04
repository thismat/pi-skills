---
name: kagi-search
description: Web search via Kagi API. Use when the user asks to search the web, look something up, find documentation, or any general web search request.
---

# Kagi Search

Web search using the [Kagi API](https://kagi.com/api). Returns search results with titles, URLs, and snippets.

## Setup

1. Get a Kagi API key from https://kagi.com/api/keys
2. Add to your shell profile (`~/.profile` or `~/.zprofile` for zsh):
   ```bash
   export KAGI_API_KEY="your-api-key-here"
   ```

No dependencies to install — uses Node.js built-in `fetch`.

## Usage

```bash
{baseDir}/search.js "query"                          # Basic search (10 results)
{baseDir}/search.js "query" -n 5                     # Limit results
{baseDir}/search.js "query" -n 3 --json              # Output as JSON
```

### Options

- `-n <num>` — Number of results (default: 10, max: 50)
- `--json` — Output raw JSON instead of formatted text

## Output Format

```
--- Result 1 ---
Title: Page Title
URL: https://example.com/page
Snippet: Description from search results...

--- Result 2 ---
...
```

## When to Use

- Searching for documentation, tutorials, or API references
- Looking up facts, news, or current information
- Any task requiring web search results
- When the user asks to search, look up, or find something on the web
