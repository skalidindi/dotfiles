# Research: `bgub/nix-macos-starter`

Snapshot reviewed: [`main` at `be8f6df`](https://github.com/bgub/nix-macos-starter/commit/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5), whose latest code commit is 2025-07-11. The comparison was limited to this OSS checkout; no Work dotfiles or secret contents were inspected.

## Recommendation

Adopt selectively: the starter's focused macOS-settings module, if those preferences are wanted, and possibly its Home Manager `mise` integration after an explicit runtime-ownership migration. Defer its wholesale layout and `nix-homebrew`. Reject its unsafe or non-reproducible defaults (`no_quarantine`, automatic upgrades/cleanup, floating inputs, and `latest` runtimes during activation).

## Findings

### Structure: useful pattern, not a better replacement

The starter separates `darwin/`, `home/`, and `hosts/<machine>/`, with host-specific Home Manager additions composed from the Darwin host ([README structure](https://github.com/bgub/nix-macos-starter/blob/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5/README.md#L54-L80), [host module](https://github.com/bgub/nix-macos-starter/blob/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5/hosts/my-macbook/configuration.nix#L7-L28)). This checkout already has the stronger equivalent boundary: shared `home-manager/modules/{files,packages,programs}.nix`, a separate Home Manager identity host, and a separate Darwin host. Keep the current layout; borrow only the per-machine convention if a second Mac is added.

### `mise`: defer the migration, do not layer it on

The starter enables Home Manager's `programs.mise`, Zsh integration, and auto-install, then runs `mise use --global` for Node, Bun, Deno, uv, and Rust during activation ([mise module](https://github.com/bgub/nix-macos-starter/blob/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5/home/mise.nix#L3-L31)). The current OSS package module already owns `nodejs`, `pnpm`, `python3`, `rustc`, and `uv`, while `Brewfile` retains `volta` ([packages](../home-manager/modules/packages.nix#L15-L24), [Brewfile](../Brewfile#L41-L59)). Adding `mise` now would create overlapping runtime owners.

If project-local runtime switching is valuable, make it a separate migration: choose one owner per runtime, pin versions in checked-in mise configuration, and avoid network-dependent `latest` installs in Home Manager activation. Do not copy the starter's activation commands wholesale.

### `nix-homebrew`: defer

The starter uses `nix-homebrew` to install/auto-migrate Homebrew and a Nix module to own casks, formulae, and taps ([flake inputs](https://github.com/bgub/nix-macos-starter/blob/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5/flake.nix#L3-L17), [Darwin integration](https://github.com/bgub/nix-macos-starter/blob/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5/darwin/default.nix#L9-L49)). This checkout intentionally keeps Homebrew installation/bootstrap imperative and `Brewfile` as its sole package source. Adopting nix-homebrew would be a package-owner migration, not a harmless structural improvement; it can be reconsidered only together with replacing the Brewfile boundary.

Also avoid copying the starter's Homebrew activation defaults: `upgrade = true`, `cleanup = "zap"`, and `caskArgs.no_quarantine = true` ([module](https://github.com/bgub/nix-macos-starter/blob/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5/darwin/homebrew.nix#L3-L16)). They make activation more destructive and weaken application quarantine.

### Other selective ideas

The split Darwin settings module is a good small addition if desired: it demonstrates Touch ID for sudo, Finder defaults, login-window settings, and a configuration revision ([settings](https://github.com/bgub/nix-macos-starter/blob/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5/darwin/settings.nix#L3-L34)). Add only preferences that are intentional for this Mac. Keep this checkout's release-aligned flake inputs and explicit architecture target; the starter uses floating `nixpkgs-unstable`, Home Manager `master`, and the unpinned nix-darwin input ([flake](https://github.com/bgub/nix-macos-starter/blob/be8f6df68c5cdeacc6e7f4d8a37b1c785b0fb9f5/flake.nix#L3-L16)).

