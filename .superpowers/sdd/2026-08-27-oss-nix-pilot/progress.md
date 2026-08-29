# OSS Nix pilot verification ledger

## 2026-08-29

- Branch: `feature/skalidindi/nix-oss-pilot`
- Boundary: `git diff HEAD~3 --name-status` contains only the OSS pilot files
  (`docs/nix-pilot.md`, the plan, `flake.nix`, `flake.lock`, and
  `tests/nix-pilot.sh`). The pre-existing untracked
  `docs/2026-08-27-macos-bootstrap-tooling-audit.md` remains untouched.
- `git diff --check`: exit 0.
- `bash tests/agent-entrypoints.sh`: exit 0.
- `bash tests/agent-runtime-guard.sh`: exit 0.
- `bash tests/agent-state.sh`: exit 0.
- `bash tests/bootstrap-installers.sh`: exit 0.
- `bash tests/nix-pilot.sh`: exit 0; flake evaluated and expected commands
  resolved inside `nix develop`.
- `bash tests/stow-agent-prompts.sh`: exit 0.
- `nix flake check --all-systems --no-build`: exit 0; both Darwin systems
  evaluate. Nixpkgs warns that 26.05 is the final Intel macOS-supporting
  release.
- No Home Manager, nix-darwin, Homebrew, Stow, Work overlay, or live `$HOME`
  state was changed.
