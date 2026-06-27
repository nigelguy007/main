# Using NotebookLM with Claude

Two ways are set up here:

1. **roomi-fields/notebooklm-mcp** — community MCP server (free, runs on your machine).
2. **Official NotebookLM Enterprise** — Google Workspace Enterprise with API access.

The `.mcp.json` in this repo registers the community server for Claude Code. It
points at `${NOTEBOOKLM_MCP_PATH}/dist/index.js`, so you set one env var to the
folder where you cloned the server (see below).

---

## 1. Install roomi-fields/notebooklm-mcp (on your own machine)

> This must run wherever you run Claude (Desktop / Code / IDE). It cannot be
> installed from the ephemeral cloud session — Claude reaches the server over
> stdio on your local machine.

### Fastest path — Claude Code plugin marketplace
```bash
/plugin marketplace add roomi-fields/claude-plugins
/plugin install notebooklm@roomi-fields
```
This registers and runs the server automatically; you can skip the manual steps
below and the `.mcp.json` in this repo.

### Manual path
```bash
git clone https://github.com/roomi-fields/notebooklm-mcp.git
cd notebooklm-mcp
npm install && npm run build

# one-time Google sign-in for NotebookLM (opens a browser)
npm run setup-auth
```

Then point this repo's config at that clone:
```bash
export NOTEBOOKLM_MCP_PATH=/absolute/path/to/notebooklm-mcp   # add to your shell profile
```

Optional local REST API (port 3000) for n8n / Zapier / Make:
```bash
npm run start:http
```

### Register with your Claude client

- **Claude Code (this repo):** already done via `.mcp.json`. Restart Claude Code;
  approve the server when prompted. Verify with `/mcp`.
- **Claude Desktop:** add to `claude_desktop_config.json`:
  ```json
  {
    "mcpServers": {
      "notebooklm": {
        "command": "node",
        "args": ["/absolute/path/to/notebooklm-mcp/dist/index.js"]
      }
    }
  }
  ```
  Restart Claude Desktop.

Check `.env.example` in the cloned repo for optional settings (multi-account
rotation, audio/video generation). Config docs:
https://roomi-fields.github.io/notebooklm-mcp/02-configuration

---

## 2. Official NotebookLM Enterprise path

This is an account/admin action — there is nothing to install in code. Steps,
which require Google Workspace **admin** access:

1. **Confirm licensing.** NotebookLM Enterprise (a.k.a. via Agentspace / Gemini
   Enterprise) requires a Google Workspace Enterprise plan with NotebookLM
   Enterprise enabled. Check at https://workspace.google.com and your billing.
2. **Enable in Admin console.** admin.google.com → Apps → turn on NotebookLM
   Enterprise for the relevant org units.
3. **Enable API access.** In Google Cloud Console, enable the NotebookLM
   Enterprise API on the project tied to your Workspace, and create
   credentials (service account or OAuth) with the required scopes.
4. **Connect via MCP.** Use Google's official Enterprise MCP endpoint with those
   credentials, or configure the community server above to use the Enterprise
   account. Add the endpoint/credentials as env vars rather than committing them.

> ⚠️ Do not commit any tokens, service-account keys, or client secrets to this
> repo. Keep them in your local environment or a secrets manager.

Reference: https://github.com/roomi-fields/notebooklm-mcp
