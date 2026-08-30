# Nix Clean Layout Design

## Goal

Turn the OSS dotfiles repository into a small, standalone macOS Home Manager
configuration. Home Manager owns portable command-line packages, declarative
configuration, and the helper commands it places in `~/.local/bin`. Homebrew
owns GUI applications, fonts, and the macOS- or work-specific tools that are
not portable OSS configuration.

## Decisions

- Keep a standalone Home Manager flake. Do not add nix-darwin or another
  system-management layer.
- Replace the general-purpose Nix development shell. It duplicates globally
  managed commands and makes runtime ownership ambiguous.
- Split `home-manager/oss.nix` by responsibility, not tool: package policy,
  static files, and programs with native Home Manager support.
- Move static source material into `config/`, preserving its destination shape
  below that directory. For example, `config/zsh/.zshrc` maps to `~/.zshrc`
  and `config/nvim` maps to `~/.config/nvim`.
- Move executable source helpers to `scripts/bin/`; Home Manager links these
  into `~/.local/bin`.
- Keep the single normal entrypoints as `./scripts/bootstrap` for a new or
  existing laptop and `./scripts/update` for dependency updates plus apply.
- Keep encrypted secret input at `env/.env-secrets.gpg`; `scripts/secrets`
  decrypts it atomically to the ignored, mode-0600 `$HOME/.env-secrets` file.

## Repository structure

```text
flake.nix
home-manager/
  hosts/skalidindi.nix
  modules/files.nix
  modules/packages.nix
  modules/programs.nix
config/
  agents/ bash/ fastfetch/ ghostty/ git/ lazygit/ nvim/ starship/
  tmux/ worktrunk/ yazi/ zellij/ zsh/
scripts/
  bootstrap
  update
  secrets
  bin/
tests/
```

`hosts/skalidindi.nix` is the only place that supplies the user name, home
directory derivation, Git identity, GPG key, and laptop-specific Git include.
Shared modules use only Home Manager values such as `config.home.homeDirectory`
and `$HOME`; they contain no `/Users/...` paths.

## Ownership

Home Manager's portable package list absorbs the OSS CLI tools currently
duplicated between the flake development shell and the Brewfile, including
editor/terminal utilities, search tools, prompt tools, Git tooling, and common
language runtimes. Neovim and tmux remain Home Manager programs.

Homebrew retains casks and fonts. It also retains the explicitly non-portable
or work/macOS-oriented formulae: Java tooling, desktop-integrated credential
and pinentry tooling, and work-specific utilities. Mutable user-level tools
continue to be installed by the bootstrap helper only when their language
runtime is intentionally retained; the helper must not assume that runtime was
installed by Homebrew.

The general dev shell is removed. `nix flake check` evaluates the actual Home
Manager configurations for both Apple Silicon and Intel macOS instead.

## Deployment and maintenance

`scripts/bootstrap` ensures Nix and Homebrew prerequisites are available,
installs the declarative package/configuration state, applies the detected
Darwin Home Manager target, then installs mutable helper assets and decrypts
the encrypted secret seed. `scripts/update` runs Homebrew update/upgrade,
updates Nix flake inputs, and invokes bootstrap so both owners are refreshed.

The Home Manager target name is selected from `uname -m`, so the regular
bootstrap path evaluates `oss-aarch64-darwin` on Apple Silicon and
`oss-x86_64-darwin` on Intel. The generic `oss` alias is removed to prevent a
silently incorrect architecture default.

## Deletions and preserved inputs

Delete the non-deployed `claude/`, `codex/`, and `cursor/` templates; deployed
shared agent assets remain in `config/agents`. Remove stale TPM/Cursor ignore
exceptions, the unused Git commit-template source, and test contracts tied to
the retired dev shell or installer numbering. Preserve all Home-Manager-linked
static configuration, encrypted secrets, Neovim's seeded plugin lock behavior,
and user-invocable Zellij layouts.

## Verification

Tests will replace path-specific assertions with structural and behavioral
checks for the new entrypoints, architecture selection, package ownership, and
secret safety. The final candidate must pass the complete test suite, `nix
flake check`, direct evaluation of both Home Manager targets, a live Home
Manager activation on the current architecture, and `brew bundle check`.

No test or activation may decrypt, print, or otherwise inspect a secret.
