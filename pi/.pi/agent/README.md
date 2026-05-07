# Pi Agent Dotfiles

This directory contains the Pi agent assets that should follow this dotfiles
checkout.

## Stow Boundary

`stow -t "$HOME" -R pi` links `~/.pi` back into this repo. That is useful for
static Pi assets such as keybindings, extension source, skills, and prompts.

Runtime files that Pi mutates should not be tracked. They are ignored either by
the repo root `.gitignore` or this directory's `.gitignore`.

Workflow modes are available through the local `mode` extension:

```text
/mode
/mode pair
/mode auto
/mode off
```

Mode content is read from `~/.agents/modes` when available and from
`~/.pi/agent/modes` as a fallback. `install-agent-assets` maintains the shared
`agents/` and `modes/` symlinks.

## Tracked

- `README.md` - this policy.
- `.gitignore` - Pi-local runtime ignores.
- `keybindings.json` - portable keybindings.
- `extensions/` - portable Pi behavior that is safe to commit.
- `skills/` - portable Pi skills that are safe to commit.
- `git/.gitignore` - keeps Pi-installed git packages out of the repo.

## Runtime Only

- `auth.json`
- `sessions/`
- `settings.json`
- `mcp.json`
- shared `agents/` and `modes/` symlinks
- installed packages under `git/`
- logs, caches, temporary files, and generated package state

## Install

The top-level `bootstrap.sh` runs:

```bash
install-agent-assets
```

You can rerun it directly after changing shared agent assets:

```bash
~/.local/bin/install-agent-assets
```

The installer must be idempotent. It should preserve local settings and only add
new defaults from tracked shared assets.
