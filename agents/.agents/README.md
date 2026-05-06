# Shared Agent Assets

This directory is the portable, cross-tool agent layer for Claude, Codex, Pi,
Cursor, and any future coding agent.

It is managed by GNU Stow through the `agents` package:

```bash
stow -t "$HOME" -R agents
```

The normal entrypoint is still the top-level bootstrap script, which stows this
package with the rest of the dotfiles.

## Contract

Track source-of-truth assets that should follow the user across machines:

- prompt fragments and shared operating guidance;
- active task notes that need to survive sessions;
- curated profile definitions for small, explicit agent setups;
- generated inventories that are safe to commit;
- helper documentation for syncing tool-specific agent directories.

Do not track mutable or machine-local runtime state:

- auth files, tokens, credentials, browser profiles, or OAuth caches;
- agent session logs, transcripts, memories, todos, and plans;
- plugin caches, generated model catalogs, and downloaded packages;
- per-project trust metadata or machine-specific absolute-path config;
- tool-owned files that are rewritten during normal use.

If a file is static and safe to symlink, keep it in a stow package. If a tool
mutates the file at runtime, track a template or default and merge it from an
installer instead.

## Profiles

Profiles describe what should be enabled by default. They are policy documents
for now; implementation scripts should read from them later rather than copying
ad hoc lists between Claude, Codex, Pi, and Cursor.

- `core` - minimal cross-agent behavior for day-to-day coding.
- `netflix` - Netflix-specific tools and docs layered on top of core.
- `heavy` - high-cost or special-purpose tools enabled only when useful.

## Task Notes

Use `tasks/` for active, durable notes only. Delete or archive a task note once
the durable learning has moved into a prompt, skill, plugin, or repo doc.

Suggested naming:

```text
tasks/agent-asset-cleanup.md
tasks/pi-mode-profile-rollout.md
```
