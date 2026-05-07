# Shared Agent Assets

This directory is the portable, cross-tool agent layer for Claude, Codex,
Cursor, and future coding agents.

It is managed by GNU Stow through the `agents` package:

```bash
stow -t "$HOME" -R --no-folding agents
```

The normal entrypoint is still the top-level bootstrap script, which stows this
package with the rest of the dotfiles and then runs `install-agent-assets`.

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
mutates the file at runtime, track a template or installer behavior instead of
the live file.

## Install And Check

```bash
./bootstrap.sh
install-agent-assets
agent-doctor
```

`install-agent-assets` syncs the shared base prompt into the Claude and Codex
prompt files, links shared helper agents and modes into supported agent homes,
and merges tracked hook templates into local hook config.

## Profiles

Profiles describe what should be enabled by default.

- `core` - minimal cross-agent behavior for day-to-day coding.
- `heavy` - high-cost or special-purpose tools enabled only when useful.

Use `agent-skill-profile` to inspect or apply those profiles:

```bash
agent-skill-profile diff --target all
agent-skill-profile apply --target all --prune core
agent-skill-profile apply --target all heavy
```

`--prune` moves extras into `~/.agents/disabled-skills/<target>/<timestamp>/`;
it does not delete them.

## Prompts

`prompts/base.md` is the shared source for the short global prompt. Agent-native
files such as `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` should stay in
sync with it, but they remain explicit files because each tool discovers a
different filename.

## Helper Agents

`agents/` contains portable helper-agent prompts. They are intentionally
read-only and are not part of every default prompt. Use them as targeted
delegation templates when the active agent supports custom agents or subagents:

- `research` - non-local or cross-repo research
- `critique` - second opinion on plans and risky choices
- `review` - final review before claiming done
- `audit` - focused security review
- `index` - local capability router

## Modes

`modes/` contains lightweight prompt guidance for working style:

- `pair` - collaborative, short-turn, interactive mode
- `auto` - autonomous, deeper-work mode

These are shared prompt assets, not a guarantee that every agent has a native
mode-switching UI. Use `agent-mode pair` or `agent-mode auto` to print the
guidance, and use tool-native mode support where available.

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
