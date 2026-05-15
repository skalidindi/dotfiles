# Dotfiles

Personal macOS dotfiles for a development machine. The repo is organized as
GNU Stow packages plus a bootstrap script: static config is symlinked into
`$HOME`, while auth, sessions, caches, generated files, and other runtime state
stay ignored.

## Quick Start

```bash
git clone https://github.com/skalidindi/dotfiles.git ~/oss/dotfiles
cd ~/oss/dotfiles
./bootstrap.sh
agent-doctor
```

`agent-doctor` is the quick post-bootstrap check for the agent surfaces,
launcher commands, prompt sync, profile drift, and obvious runtime-state leaks.

## Bootstrap

`./bootstrap.sh` is the normal install and update path. It:

- installs Homebrew if it is missing;
- stows the configured dotfile packages into `$HOME`;
- runs `install-agent-assets` and `configure-oss-git` when available;
- runs `brew bundle --file=Brewfile`;
- installs the global agent and development CLIs this setup expects;
- decrypts `env/.env-secrets.gpg` into the ignored local `env/.env-secrets`
  file when the encrypted file is present.

Bootstrap behavior is split into numbered scripts under `installers/`. Use
`./bootstrap.sh --list` to inspect the exact run order, or run a single
installer directly when only one slice changed.

Re-run `./bootstrap.sh` after changing stowed config, helper scripts, or package
lists.

## Repo Layout

- `agents/` - shared Claude, Codex, and Cursor prompt assets, profiles,
  helper-agent prompts, modes, and skill source manifests.
- `claude/`, `codex/`, `cursor/` - tool-specific agent homes,
  templates, hooks, keybindings, and portable extensions. Runtime files inside
  these trees are intentionally ignored.
- `bin/.local/bin/` - local PATH helpers such as `zrun`, `agent-doctor`, and
  `agent-skill-profile`.
- `bash/`, `zsh/`, `nushell/`, `starship/` - shell configuration and prompt
  setup.
- `git/`, `jj/`, `gh/`, `lazygit/` - source-control configuration.
- `nvim/`, `tmux/`, `zellij/`, `ghostty/`, `yazi/` - editor, terminal,
  multiplexer, and file-manager configuration.
- `Brewfile` - Homebrew packages managed by bootstrap.
- `env/` - encrypted environment seed material. Keep decrypted files local and
  ignored.

## Stow

Install one package manually when you only want a narrow update:

```bash
stow -t "$HOME" -R zsh
stow -t "$HOME" -R nvim
stow -t "$HOME" -R --no-folding agents
```

`bootstrap.sh` uses `--no-folding` for packages where preserving a mixed local
directory matters, such as `agents`, `git`, and `nushell`.

## Agent Workflow

Shared portable agent assets live under `~/.agents`. Runtime state, auth,
sessions, caches, memories, and generated catalogs should stay local and
ignored.

Useful checks and maintenance commands:

```bash
agent-doctor
agent-runtime-guard
install-agent-assets
agent-skill-profile diff --target all
agent-skill-profile apply --target all --prune core
agent-skill-profile apply --target all heavy
```

For long-lived interactive agents, start or attach a zellij session manually,
then run the agent commands normally:

```bash
zellij
codex
claude
```

Agent CLIs resolve to installer-managed binaries; this repo does not track
wrapper files or shell aliases for `codex` and `claude`.

## Secrets And Runtime State

Do not commit:

- auth files, tokens, credentials, browser profiles, or OAuth caches;
- agent sessions, logs, histories, memories, todos, and local plans;
- downloaded plugin caches, generated model catalogs, and package installs;
- decrypted environment files.

If a file is static and safe to symlink, keep it in a stow package. If a tool
mutates it during normal use, track a template or installer behavior instead of
the live file.

## License

This project is open source and available under the [MIT License](LICENSE).
