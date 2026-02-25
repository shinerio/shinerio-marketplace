# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Shinerio Marketplace is a **Claude Code plugin marketplace** containing two independent plugins distributed via the Claude Code plugin system. There is no traditional build/test/lint pipeline — plugins are markdown/JSON-based configuration.

## Repository Structure

```
.claude-plugin/marketplace.json    # Marketplace registry (lists all plugins + versions)
plugins/
  shinerio-code-plugin/            # Dev productivity: git automation, test analysis
    .claude-plugin/plugin.json     # Plugin manifest
    agents/test-case-executor.md   # Read-only agent for test failure analysis
    commands/gitacp.md             # /gitacp slash command (git add, commit, push)
  shinerio-note-plugin/            # Visualization: mindmaps, diagrams
    .claude-plugin/plugin.json     # Plugin manifest
    .mcp.json                      # MCP server dependencies
    agents/drawio-diagram-analyst.md  # Agent: parse and explain Draw.io diagrams
    skills/embed-mindmap/          # Skill: generate mindmap PNG and embed in markdown
```

## Architecture

**Plugin types** follow Claude Code's extension model:
- **Commands** (`commands/*.md`): User-invocable slash commands (e.g., `/gitacp`)
- **Agents** (`agents/*.md`): Specialized subagents with restricted tool access
- **Skills** (`skills/*/SKILL.md`): Multi-step workflows with detailed instructions

**MCP servers** (configured in `shinerio-note-plugin/.mcp.json`):
- `@jinzcdev/markmap-mcp-server` — Markdown to mindmap HTML conversion
- `chrome-devtools-mcp` — Browser automation for screenshots/export
- `@next-ai-drawio/mcp-server` — Draw.io diagram creation

## Key Conventions

- Plugin versions are tracked in `.claude-plugin/marketplace.json` — update version there when releasing
- The `/gitacp` command auto-generates changelog entries at `changelog/change_YYYYMM.md` (monthly files)
- Agent `test-case-executor` is strictly read-only — it must never modify code
- Agent `drawio-diagram-analyst` parses Draw.io XML and produces structured textual analysis; uses `mcp__plugin_shinerio-note-plugin_drawio__*` tools
- The `embed-mindmap` skill uses PicGO (localhost:36677) for image uploads and requires Chrome for PNG export
- All plugin content is written in Markdown with YAML frontmatter for metadata

## Installation & Testing

```bash
# Install from marketplace (end users)
/plugin marketplace add shinerio/shinerio-marketplace
/plugin install shinerio-code-plugin@shinerio-marketplace

# Local development
claude --plugin-dir ./shinerio-marketplace
```

No build step required. To test changes, reload Claude Code with the local plugin directory.

## External Dependencies

- **Node.js**: Required for running MCP servers via `npx`
- **Python 3 + requests**: Required for `picgo_client.py` (image upload in embed-mindmap skill)
- **PicGO**: Desktop app providing image hosting API

## Documentation Maintenance

After completing new feature development or modifying existing features, update CLAUDE.md and README.md to reflect the changes if necessary.
