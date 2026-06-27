# Using NotebookLM with Claude (verified working)

NotebookLM has **no official Google API**. This connects Claude to your
notebooks using [`teng-lin/notebooklm-py`](https://github.com/teng-lin/notebooklm-py),
an unofficial Python tool that signs into NotebookLM as you (browser
automation) and exposes it to Claude over MCP.

> Caveat: because it's unofficial, it can break when Google changes their site,
> and the login expires periodically (re-run `notebooklm login` to fix).

The `.mcp.json` in this repo registers the server for Claude Code. Note it
installs from **git**, not PyPI — the MCP server (`notebooklm-mcp`) only exists
in the GitHub `main` branch, not in any published release (latest PyPI is 0.7.2
and does not include it).

---

## Setup (macOS — what was actually verified)

### 1. Install `uv`
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```
Reopen Terminal afterward.

### 2. Sign in to NotebookLM
```bash
uv tool install "notebooklm-py[browser]"
notebooklm login          # opens a browser; sign into the Google account with your notebooks
```
Verify auth and list notebooks:
```bash
notebooklm auth check --test
notebooklm list
```

### 3. Confirm the MCP server runs (from git)
```bash
uvx --from "notebooklm-py[mcp] @ git+https://github.com/teng-lin/notebooklm-py" notebooklm-mcp --help
```
This must print usage text. (Plain `notebooklm-py[mcp]` from PyPI will fail with
`executable named notebooklm-mcp is not provided` — that's why the git URL is
required.)

### 4. Register with your Claude client

**Claude Desktop** — edit `~/Library/Application Support/Claude/claude_desktop_config.json`
and add the `notebooklm` entry inside `mcpServers` (keep any existing keys; mind
the commas). Use the **absolute path** to `uvx` (find it with `which uvx`,
e.g. `/Users/<you>/.local/bin/uvx`) — Claude Desktop on macOS does not inherit
your shell PATH:
```json
{
  "mcpServers": {
    "notebooklm": {
      "command": "/Users/<you>/.local/bin/uvx",
      "args": [
        "--from",
        "notebooklm-py[mcp] @ git+https://github.com/teng-lin/notebooklm-py",
        "notebooklm-mcp"
      ]
    }
  }
}
```
Then **fully quit (Cmd+Q) and reopen** Claude Desktop. The `notebooklm` server
should show as connected under the tools/🔌 menu.

**Claude Code** — this repo's `.mcp.json` already registers it. Restart Claude
Code, approve the server, and verify with `/mcp`.

### 5. Use it
Ask Claude:
- "List my NotebookLM notebooks"
- "Ask my <notebook> notebook: <question>"
- "Summarize the sources in <notebook>"

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Server shows **failed** in Claude | Check "View Logs" in Developer settings. |
| `executable named notebooklm-mcp is not provided` | You're on the PyPI build — use the `@ git+...` install above. |
| `spawn uvx ENOENT` / not found | Use the absolute path to `uvx` in `command` (`which uvx`). |
| Auth errors / was working, now failed | Re-run `notebooklm login`, then quit/reopen Claude. |

> Don't commit any auth state or tokens. Login lives in
> `~/.notebooklm/profiles/` on your machine, not in this repo.
