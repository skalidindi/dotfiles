# Darwin revision and CI design

## Goal

Expose the Git revision of the active nix-darwin generation and reject invalid
changes before they reach `main`, without changing package ownership, Homebrew,
secrets, or macOS settings.

## Design

`flake.nix` will pass `self` to the Darwin host module through
`specialArgs`. `darwin/hosts/skalidindi.nix` will set
`system.configurationRevision` to `self.rev or self.dirtyRev or null`. A build
from a committed checkout records the commit; a dirty checkout records its
dirty revision; source snapshots without Git metadata leave the field unset.

`.github/workflows/verify.yml` will run on pushes and pull requests targeting
`main`. The sole job uses `macos-14`, which GitHub documents as an ARM64 macOS
runner. It checks out the repository, installs Nix with the current pinned
Determinate installer action, then runs the existing fail-fast shell suite and
`nix flake check --all-systems`.

## Boundaries

- CI performs evaluation and shell tests only. It never runs `darwin-rebuild
  switch`, `scripts/bootstrap`, `scripts/update`, Homebrew, or secret helpers
  against the runner's system.
- The workflow does not update `flake.lock`, open pull requests, or upload
  caches.
- The existing Brewfile remains the only Homebrew package source.
- The change remains Apple Silicon-only; the workflow has no Intel matrix.

## Validation

- Add a focused assertion that the Darwin host sets `configurationRevision` and
  the flake provides `self` to the Darwin modules.
- Add a structural test for the CI workflow's ARM runner, triggers, installer,
  shell suite, and flake check command.
- Run the full shell suite and `nix flake check --all-systems` locally.
