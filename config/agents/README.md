# Shared Agent Assets

This directory is the portable, cross-tool agent layer for Claude, Codex,
Cursor, and future coding agents.

This legacy source is retained for reference only. Work dotfiles own and
materialize the live `~/.agents` tree on both laptops and Dev Workspaces.
The OSS Home Manager configuration no longer links this directory.

## Contract

Track source-of-truth assets that should follow the user across machines:

- prompt fragments and shared operating guidance;
- active task notes that need to survive sessions;
- generated inventories that are safe to commit;
- helper documentation for syncing tool-specific agent directories.

Do not track mutable or machine-local runtime state:

- auth files, tokens, credentials, browser profiles, or OAuth caches;
- agent session logs, transcripts, memories, todos, and plans;
- plugin caches, generated model catalogs, and downloaded packages;
- per-project trust metadata or machine-specific absolute-path config;
- tool-owned files that are rewritten during normal use.

If a file is static and safe to symlink, keep it in the Home Manager module. If
a tool mutates the file at runtime, track a template or installer behavior
instead of the live file.

## Install And Check

Use the Work dotfiles installer to install and refresh these assets.

Work's installer renders the shared base prompt into each tool's local prompt
file and keeps runtime-owned files out of this repository.

## Prompts

`prompts/base.md` is the shared source for the short global prompt. Agent-native
files such as `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` should stay in
sync with it, but they remain explicit files because each tool discovers a
different filename.

## Task Notes

Use `tasks/` for active, durable notes only. Delete or archive a task note once
the durable learning has moved into a prompt, skill, plugin, or repo doc.

Suggested naming:

```text
tasks/agent-asset-cleanup.md
```

## External Skill Sources

Some opt-in skills are installed by `skills.sh` into `~/.agents/skills`. Track
their source manifest here as `skills.sh.sources.json` instead of treating the
installed skill folders as the durable source of truth.

The live `~/.agents/.skill-lock.json` is tool-owned runtime state. The tracked
sources file records which third-party skills we care about, but intentionally
does not pin versions. Restores use latest by default.

Preview or run the restore commands with:

```bash
restore-skills-sh
restore-skills-sh --apply
```
