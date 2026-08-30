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
launcher commands, prompt sync, and obvious runtime-state leaks. Run
`agent-skill-profile diff --target all` separately when you want to inspect
profile drift.

## Bootstrap

`./bootstrap.sh` is the normal install and update path. It:

- installs Homebrew if it is missing;
- stows the configured dotfile packages into `$HOME`;
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

The repository includes an opt-in Nix flake for OSS command-line tools and
development runtimes. It does not replace `bootstrap.sh`, install packages
globally, or manage files in `$HOME`.

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
Work tools, and global tools. GNU Stow remains the source for static dotfiles.

To add a tool to the shell, add its nixpkgs attribute to `flake.nix`, then run
the flake check and `bash tests/nix-pilot.sh`. Update pinned package versions
only when intended:

```bash
nix --extra-experimental-features 'nix-command flakes' flake lock --update-input nixpkgs
```

Review and commit `flake.lock` with that update.

### Home Manager pilot

Home Manager currently owns only `~/.config/starship.toml`; Homebrew still
owns the `starship` executable and Stow owns the rest of the dotfiles. On the
first activation, remove the legacy Starship Stow link, then apply the
configuration:

```bash
stow -t "$HOME" -D starship
NIX_CONFIG="extra-experimental-features = nix-command flakes" \
  nix run .#home-manager -- switch --flake .#oss
```

The flake also exposes `.#homeConfigurations.oss-x86_64-darwin` for Intel
macOS. Do not add another Stow package for files managed by Home Manager.
The account-specific username and home path live in
`home-manager/hosts/skalidindi.nix`; copy that host module when using a
different macOS account.

## Repo Layout

- `agents/` - shared Claude, Codex, and Cursor prompt assets, profiles, task
  notes, and skill source manifests.
- `claude/`, `codex/`, `cursor/` - tool-specific agent homes,
  templates, hooks, keybindings, and portable extensions. Runtime files inside
  these trees are intentionally ignored.
- `bin/.local/bin/` - local PATH helpers such as `zrun`, `agent-doctor`, and
  `agent-skill-profile`.
- `bash/`, `zsh/`, `starship/` - shell configuration and prompt
  setup.
- `git/`, `gh/`, `lazygit/` - source-control configuration.
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
directory matters, such as `agents`, `git`, and `worktrunk`.

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
