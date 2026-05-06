# Core Agent Profile

Small default profile for every coding agent.

## Keep Enabled

- Shared base prompt: direct collaboration, evidence-first claims, scope
  discipline, read-before-edit, and risk-scaled verification.
- `zrun` and `agent-awake` launcher workflow for long-running Claude/Codex
  sessions on local macOS.
- Minimal safety hooks:
  - block direct `python`/`pip`/`poetry` in favor of `uv`;
  - warn or block destructive shell commands before they run;
  - prefer surgical edits over full-file rewrites where the tool supports it.
- Core development skills:
  - git/GitHub workflow;
  - Python and JavaScript/TypeScript basics;
  - Mermaid and lightweight documentation helpers;
  - source lookup helpers that do not pull in heavy external state.

## Keep Out

- Product-specific skills that only apply to one repo or team.
- Personal data integrations such as mail, calendar, or broad Google Workspace
  write access.
- Browser automation, presentations, spreadsheets, and document-generation
  runtimes unless explicitly requested.
- Session memories, generated catalogs, plugin caches, and local auth.
