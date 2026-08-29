# OSS Nix pilot

This is an opt-in development environment for the public OSS dotfiles. It is
not the laptop installer yet. The existing `./bootstrap.sh`, Stow packages,
Homebrew applications, and Netflix Work overlay remain authoritative.

## Prerequisite

Install Nix using the official macOS installer and complete its daemon setup.
This repository does not install Nix or change system state for you. The
installer adds the Nix profile hook to new shells; reopen your terminal before
running the commands below if `nix` is not yet on `PATH`.

## Try the pilot

From the repository root:

```bash
nix_args=(--extra-experimental-features 'nix-command flakes')
nix "${nix_args[@]}" flake check
nix "${nix_args[@]}" develop
```

Inside the development shell, the flake provides the OSS command-line tools
used by this repository, including Git, Neovim, ripgrep, fd, fzf, bat, eza,
delta, jq, starship, zellij, yazi, zoxide, tree-sitter, uv, Python, Node.js,
Rust, Stow, wget, and curl. The shell is isolated from the global Homebrew and
Volta installations. Leave it with `exit`.

The opt-in validation command checks the lockfile, evaluates the flake, and
checks each expected command inside the Nix shell:

```bash
bash tests/nix-pilot.sh
```

Without Nix, the test exits 77 with an explicit prerequisite message. It never
installs packages, runs `sudo`, changes the default shell, invokes Homebrew or
Stow, activates Home Manager or nix-darwin, or edits `$HOME`.

## Ownership rules

The pilot owns no home-directory path. Keep these boundaries until a later
approved migration slice:

| Area | Current owner | Pilot behavior |
| --- | --- | --- |
| Static dotfiles | GNU Stow | Leave unchanged |
| GUI applications | Homebrew casks, App Store, or MDM | Leave unchanged |
| Netflix tools and configuration | private Work overlay | Leave unchanged |
| Mutable agent state | the owning agent installers | Leave unchanged |
| Credentials and secret values | local keychain, 1Password, or GPG | Never place in the flake or Nix store |
| CLI development environment | this Nix flake, only inside `nix develop` | Opt-in |

Do not add Home Manager or nix-darwin until the pilot has passed on this Mac
and in a clean temporary account. Never let Nix and Stow manage the same target
path.

## What success means

The first success gate is `nix flake check` plus a passing `tests/nix-pilot.sh`.
The second gate is a clean-machine run with the same locked `flake.lock`,
followed by a check that entering and leaving the shell produces no repository
or home-directory changes. The lockfile makes the input revision reproducible;
the Nix store must still contain the referenced derivations for an offline run.

Only after those gates should we compare a Home Manager module against the
existing OSS Stow packages. macOS settings and launch agents are a separate
nix-darwin decision. Work authentication, Apple ID sign-in, MDM approval, VPN
setup, and GUI permissions remain manual boundaries.

## Removing the pilot

The pilot is reversible. Remove only `flake.nix`, `flake.lock`, this document,
and `tests/nix-pilot.sh` from the repository. No existing Homebrew package,
Stow link, Work file, or live configuration is changed by the pilot.
