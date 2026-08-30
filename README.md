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
launcher commands, prompt sync, and obvious runtime-state leaks.

## Bootstrap

`./bootstrap.sh` is the normal install and update path. Install Nix first when
setting up a new laptop so Home Manager can activate during bootstrap. It:

- installs Homebrew if it is missing;
- stows the configured dotfile packages into `$HOME`;
- activates Home Manager when Nix is installed;
- runs `install-agent-assets` and `configure-oss-git` when available;
- runs `brew bundle --file=Brewfile`;
- installs the global agent and development CLIs this setup expects;
- decrypts `env/.env-secrets.gpg` atomically into the ignored `$HOME/.env-secrets`
  file when the encrypted file is present.

Bootstrap behavior is split into numbered scripts under `installers/`. Use
`./bootstrap.sh --list` to inspect the exact run order, or run a single
installer directly when only one slice changed.

Re-run `./bootstrap.sh` after changing stowed config, helper scripts, or package
lists.

## Nix development shell

The repository includes an opt-in Nix flake for OSS command-line tools,
development runtimes, and selected static configuration. It does not replace
`bootstrap.sh` or install packages globally.

Install Nix with the official macOS daemon installer, then reopen the terminal.
From the repository root, validate and enter the shell with:

```bash
nix --extra-experimental-features 'nix-command flakes' flake check
bash tests/nix-pilot.sh
nix --extra-experimental-features 'nix-command flakes' develop
```

The first invocation downloads the locked packages into the Nix store. While
inside `nix develop`, those versions take precedence over Homebrew versions.
Run `exit` to leave the shell. Homebrew remains the source for GUI applications,
Work tools, and global tools. Home Manager owns the migrated static configs;
GNU Stow owns the remaining dotfiles.

To add a tool to the shell, add its nixpkgs attribute to `flake.nix`, then run
the flake check and `bash tests/nix-pilot.sh`. Update pinned package versions
only when intended:

```bash
nix --extra-experimental-features 'nix-command flakes' flake lock --update-input nixpkgs
```

Review and commit `flake.lock` with that update.

### Home Manager

Home Manager currently owns `~/.config/starship.toml`, `~/.config/zellij`,
`~/.config/yazi`, `~/.config/fastfetch`, `~/.config/ghostty`, and
`~/.config/lazygit`, plus the static `herdr/config.toml` and
`worktrunk/config.toml` files. It also owns the shell startup files, shared
agent assets, the OSS Git files under `~/.config/git`, the Neovim configuration,
and tmux with its plugins. Home Manager installs Neovim and tmux through Nix;
Homebrew owns the other executables. Bootstrap removes the legacy Stow
links and activates Home Manager automatically when Nix is installed. To
migrate an existing machine manually, remove the old links, then apply the
configuration:

```bash
stow -t "$HOME" -D agents bash git nvim tmux zsh starship zellij yazi fastfetch ghostty lazygit herdr worktrunk
NIX_CONFIG="extra-experimental-features = nix-command flakes" \
  nix run .#home-manager -- switch --flake .#oss
```

The flake also exposes `.#homeConfigurations.oss-x86_64-darwin` for Intel
macOS. Do not add another Stow package for files managed by Home Manager.
The account-specific username and home path live in
`home-manager/hosts/skalidindi.nix`; copy that host module when using a
different macOS account.

## Repo Layout

- `agents/` - shared Claude, Codex, and Cursor prompt assets and skill source
  manifests.
- `claude/`, `codex/`, `cursor/` - tool-specific agent homes,
  templates, hooks, keybindings, and portable extensions. Runtime files inside
  these trees are intentionally ignored.
- `bin/.local/bin/` - local PATH helpers such as `zrun` and `agent-doctor`.
- `bash/`, `zsh/`, `starship/` - shell configuration and prompt
  setup.
- `git/` - layered source-control configuration.
- `nvim/`, `tmux/`, `zellij/`, `ghostty/`, `yazi/` - editor, terminal,
  multiplexer, and file-manager configuration.
- `Brewfile` - Homebrew packages managed by bootstrap.
- `env/` - encrypted environment seed material. Keep decrypted files local and
  ignored.

## Stow

Install one package manually when you only want a narrow update:

```bash
stow -t "$HOME" -R tmux
stow -t "$HOME" -R nvim
stow -t "$HOME" -R bin
```

The remaining Stow package is `bin`; its mixed static scripts and runtime state
are intentionally kept outside Home Manager for now.

## Agent Workflow

Shared portable agent assets live under `~/.agents`. Runtime state, auth,
sessions, caches, memories, and generated catalogs should stay local and
ignored.

Useful checks and maintenance commands:

```bash
agent-doctor
agent-runtime-guard
install-agent-assets
restore-skills-sh
restore-skills-sh --apply
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

If a file is static and safe to symlink, keep it in a Home Manager module. If a
tool mutates it during normal use, track a template or installer behavior
instead of the live file. Keep each target owned by exactly one system.

## License

This project is open source and available under the [MIT License](LICENSE).
