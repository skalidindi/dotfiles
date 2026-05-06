# Pi Agent Dotfiles

This directory contains the Pi assets that should follow this dotfiles checkout.

## Stow Boundary

`stow -t "$HOME" -R pi` links `~/.pi` back into this repo. That is useful for
static Pi assets such as keybindings, extension source, skills, prompts, and
templates.

Runtime files that Pi mutates should not be tracked. Keep those as ignored
local files under the stowed tree, seeded by `install-agent-assets`.

## Tracked

- `README.md` - this policy.
- `.gitignore` - Pi-local runtime ignores.
- `settings.json.tpl` - fresh-machine defaults for `settings.json`.
- `keybindings.json` - portable keybindings.
- `extensions/` and `skills/` - portable Pi behavior that is safe to commit.
- `git/.gitignore` - keeps Pi-installed git packages out of the repo.

## Runtime Only

- `settings.json` - copied or merged from `settings.json.tpl`, then mutated by
  Pi during normal use.
- `auth.json`
- `sessions/`
- `memory/`
- installed packages under `git/`
- logs, caches, temporary files, and generated package state

## Install

The top-level `bootstrap.sh` runs:

```bash
install-agent-assets
```

You can rerun it directly after changing templates:

```bash
~/.local/bin/install-agent-assets
```

The installer must be idempotent. It should preserve local settings and only add
new defaults from tracked templates.
