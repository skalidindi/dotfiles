# Nix-Darwin Design

## Goal

Add a minimal macOS system layer without changing the established ownership
boundary: nix-darwin owns Nix system configuration and activates Home Manager;
Home Manager owns portable user configuration and CLI tools; Homebrew owns its
existing GUI, font, and macOS/work package manifest.

## Design

- Add release-aligned `nix-darwin` to the flake, following the existing
  `nixpkgs-26.05-darwin` input.
- Define the Apple Silicon `darwinConfigurations` target. It imports the
  existing Home Manager host and shared modules through
  `home-manager.darwinModules.home-manager`.
- Keep account-specific `system.primaryUser`, state version, and Nix feature
  settings in a Darwin host module. Do not add speculative macOS defaults.
- Make `scripts/bootstrap` invoke the architecture-specific `darwin-rebuild
  switch`, then retain the existing Homebrew installer and `brew bundle`
  application. `scripts/update` must succeed through the Nix/Darwin apply
  before mutating Homebrew.
- Retain `Brewfile` as Homebrew's only package source. `nix-homebrew` is
  intentionally absent: its Homebrew-installation/tap pinning function would
  add locked inputs and a second migration without improving the present
  Homebrew-owned boundary.

## Constraints

- Never inspect or decrypt secret material during validation.
- Do not modify `/Users/skalidindi/work/dotfiles`.
- Preserve the two public commands: `./scripts/bootstrap` and
  `./scripts/update`.
- Preserve Home Manager's current host/shared identity boundary; shared modules
  must not contain an absolute user-home path.
- Support Apple Silicon only; reject unsupported architectures before
  activation.

## Verification

- Shell tests cover Darwin target selection and confirm Nix/Darwin activation
  occurs before Homebrew mutation.
- `nix flake check --all-systems` evaluates the Apple Silicon Darwin output.
- The live current-architecture `darwin-rebuild switch` completes.
- `brew bundle check --file="$PWD/Brewfile" --no-upgrade --verbose` passes.
