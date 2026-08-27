# OSS Nix pilot design

## Status

Approved first slice. This design is intentionally limited to the public OSS
repository. It does not change the current bootstrap, Stow ownership, Homebrew
manifest, live home directory, or Netflix Work repository.

## Goal

Add a reversible Nix pilot that proves pinned OSS command-line tools and a
reproducible development shell on macOS before any dotfiles or laptop bootstrap
ownership moves from Stow/Homebrew to Nix.

## Why Nix, and why this slice

The current repository is a useful, transparent owner for static files, but its
package and runtime installation paths are intentionally mutable. Homebrew has
no lockfile here, several global tools request latest versions, and the full
bootstrap currently has ordering and clean-home failures. Nix can test the
strongest missing property first: an exact, replayable tool environment with a
lockfile.

This slice does not claim that Nix should own the whole laptop. GUI applications,
Apple identity, MDM-managed software, mutable agent state, and private Work
configuration remain outside its boundary until a later decision.

## Selected approach

Create a root Nix flake with:

- a stable, supported `nixpkgs` input locked in `flake.lock`;
- a default development shell for both `aarch64-darwin` and
  `x86_64-darwin`;
- a curated OSS CLI/runtime package set derived from the existing public
  configuration, including the shell/editor tools already used by this repo;
- evaluation checks that do not install, activate, or modify home-directory
  files.

The first package set is limited to tools with clear OSS ownership: Git,
Neovim, ripgrep, fd, fzf, bat, eza, jq, delta, starship, zellij, yazi, zoxide,
tree-sitter, uv, Python, Node.js, Rust, Stow, wget, and curl. GUI casks,
corporate binaries, agent CLIs, Homebrew services, and encrypted material are
not copied into this set.

The flake is an opt-in command surface. A user enters it with `nix develop`.
The existing `./bootstrap.sh` remains the only installer until a later slice
proves that a Nix-managed package set can replace an equivalent Homebrew slice.

## Repository changes in this slice

Create:

- `flake.nix`: inputs, supported systems, the default development shell, and
  evaluation checks.
- `flake.lock`: generated lock data for the selected `nixpkgs` revision.
- `docs/nix-pilot.md`: installation prerequisite, commands, ownership rules,
  clean-machine test procedure, and rollback/removal instructions.
- `tests/nix-pilot.sh`: an explicit opt-in validation script. It reports a
  clear prerequisite failure when Nix is not installed and never invokes an
  activation command.

Do not modify in this slice:

- `bootstrap.sh` or any numbered installer;
- `Brewfile`;
- any Stow package or existing home-directory target;
- the Work checkout;
- secret files, agent runtime state, or generated client configuration.

## Safety and ownership invariants

1. The pilot only evaluates or enters a shell. It does not run `darwin-rebuild`,
   `home-manager`, `stow`, `brew bundle`, `sudo`, or a shell-changing command.
2. No Nix expression writes credentials or mutable application state into the
   Nix store.
3. Nix does not manage a path currently owned by Stow.
4. The Work repository remains a later overlay decision, not an implicit flake
   input in the public repository.
5. Existing package installs remain untouched. Uninstalling or replacing a
   Homebrew package is explicitly out of scope.
6. The pilot must work without network access after its locked input and store
   paths are available; the documentation must distinguish first evaluation
   from subsequent offline evaluation.

## Validation

On a machine with Nix available, run:

```bash
nix flake check
nix develop --command bash -lc 'command -v git; command -v nvim; command -v rg; command -v python3; command -v node; command -v cargo'
bash tests/nix-pilot.sh
```

The test must verify successful flake evaluation, the presence of the expected
commands inside the development shell, and the absence of changes to the
repository or `$HOME`. It must not assert that the tools are globally
installed, because this pilot deliberately does not change global PATH state.

On this machine, Nix is currently not installed. Installing the official Nix
daemon is a separate user-approved machine change and is therefore a manual
prerequisite for the GREEN run; file creation and evaluation scaffolding do not
silently install it.

## Exit criteria for the next migration decision

Do not add Home Manager or nix-darwin until all of these are true:

- the flake evaluates and the shell test passes on this Apple Silicon Mac;
- the same locked flake evaluates on a clean temporary account or disposable
  machine;
- entering and leaving the shell leaves the existing Stow/Homebrew setup
  unchanged;
- the tool list has an explicit owner for every package;
- the user has reviewed whether Nix's version pinning and rollback benefits
  justify adopting a second configuration language.

If those criteria pass, the next slice will compare Home Manager against the
current OSS Stow packages. nix-darwin remains a later, separate slice for
macOS settings and launch agents. A failed pilot is removed by deleting only
the new flake files; the existing bootstrap remains the recovery path.

## Alternatives considered

### Keep Stow/Homebrew only

This is still the lowest-change path and remains the fallback. It does not
provide a package lock or generation rollback, so it cannot prove the strongest
reproducibility goal by itself.

### Chezmoi first

Chezmoi would improve templating and encrypted file handling, but it would not
provide the same package/runtime pinning or project dev-shell model. Introducing
it before testing Nix would add another ownership system to the exact area this
pilot is designed to measure.

### Full nix-darwin/Home Manager migration

That would address more of the laptop but would mix system activation, user
files, GUI applications, secrets, and Work overlays in the first change. The
blast radius is too large for the requested incremental rollout.

## Decision

Proceed with the opt-in OSS flake pilot only. Do not alter the current install
path or remove any existing tool until the pilot's clean-machine and ownership
tests provide evidence for the next decision.
