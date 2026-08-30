# Nix-Darwin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make nix-darwin the minimal macOS activation layer while retaining Home Manager and the Brewfile ownership boundaries.

**Architecture:** `flake.nix` will construct an explicit nix-darwin system per Darwin architecture and import the existing Home Manager configuration as its user layer. A Darwin-only host module owns system identity and Nix settings. Bootstrap selects one architecture-specific Darwin target and invokes its flake-provided `darwin-rebuild` package before any Homebrew mutation.

**Tech Stack:** Nix flakes, nix-darwin 26.05, Home Manager 26.05, Bash, Homebrew Bundle.

**Spec:** `docs/superpowers/specs/2026-08-30-nix-darwin-design.md`

## Global Constraints

- Do not add nix-homebrew or duplicate the Brewfile package list in Nix.
- Do not modify `/Users/skalidindi/work/dotfiles`.
- Do not read, decrypt, or print encrypted secret contents.
- Keep `./scripts/bootstrap` and `./scripts/update` as the normal interface.
- Require successful Nix/Darwin activation before any Homebrew mutation.

---

### Task 1: Define the Darwin configuration

**Files:**
- Create: `darwin/hosts/skalidindi.nix`
- Modify: `flake.nix`
- Modify: `tests/home-manager.sh`

**Interfaces:**
- Consumes: the existing `home-manager/hosts/skalidindi.nix` and shared modules.
- Produces: `darwinConfigurations.oss-aarch64-darwin` and `darwinConfigurations.oss-x86_64-darwin`, plus a flake `darwin-rebuild` package per system.

- [x] **Step 1: Write the failing structural assertions**

Add checks that the flake declares release-aligned nix-darwin, exports both Darwin targets, and that the Darwin host module contains `system.primaryUser`, a Darwin state version, and flake feature settings without a hard-coded `/Users/<username>` path.

- [x] **Step 2: Run the focused test to verify it fails**

Run: `bash tests/home-manager.sh`

Expected: FAIL because the current flake has no `darwinConfigurations` output.

- [x] **Step 3: Implement the minimal Darwin system**

Use `darwin.lib.darwinSystem` for each supported architecture. Import the nix-darwin Home Manager module and assign the existing host/shared modules to the `skalidindi` user. Create the narrow Darwin host module with `system.primaryUser = "skalidindi"`, `system.stateVersion`, and `nix.settings.experimental-features = [ "nix-command" "flakes" ]`.

- [x] **Step 4: Run the focused test to verify it passes**

Run: `bash tests/home-manager.sh`

Expected: PASS after evaluating both Darwin targets.

### Task 2: Route the public commands through nix-darwin

**Files:**
- Modify: `scripts/bootstrap`
- Modify: `scripts/update`
- Modify: `tests/bootstrap-installers.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: the `darwin-rebuild` package and architecture target names from Task 1.
- Produces: Nix/Darwin-first bootstrap and update behavior using the existing public script paths.

- [x] **Step 1: Write failing bootstrap fixture assertions**

Change the fake-Nix fixture to record `nix run .#darwin-rebuild -- switch --flake .#oss-<architecture>` and assert that it precedes every Brew command for bootstrap and update.

- [x] **Step 2: Run the fixture to verify it fails**

Run: `bash tests/bootstrap-installers.sh`

Expected: FAIL because the scripts currently invoke the standalone Home Manager runner.

- [x] **Step 3: Implement the command transition**

Replace the Home Manager runner with a helper that invokes the flake's `darwin-rebuild` package using the selected target. Keep Homebrew discovery, Brewfile application, mutable helper execution, and secret handling unchanged. Update maintenance ordering so `nix flake update` and Darwin activation occur before `brew update`, `brew upgrade`, or Bundle mutation.

- [x] **Step 4: Run the fixture to verify it passes**

Run: `bash tests/bootstrap-installers.sh`

Expected: PASS for both architectures and every failure-order branch.

### Task 3: Update ownership documentation and verify the candidate

**Files:**
- Modify: `README.md`
- Modify: `tests/package-ownership.sh`
- Modify: `docs/superpowers/specs/2026-08-30-nix-darwin-design.md`
- Modify: `docs/superpowers/plans/2026-08-30-nix-darwin.md`

**Interfaces:**
- Consumes: the new flake and script contract.
- Produces: documentation and tests that describe one Nix/Darwin system activation, one Home Manager user owner, and one retained Brewfile source.

- [x] **Step 1: Add assertions for single-owner package boundaries**

Keep the existing Brewfile formula classification test and add checks that neither nix-darwin nor its host module declares `homebrew.` or `nix-homebrew` package ownership.

- [x] **Step 2: Run the focused ownership test to verify it fails**

Run: `bash tests/package-ownership.sh`

Expected: FAIL until the explicit no-duplicate-owner contract is added.

- [x] **Step 3: Update documentation and ownership checks**

Describe nix-darwin as the system activation layer, Home Manager as the user layer, and the Brewfile as the retained Homebrew source. State that `nix-homebrew` is intentionally absent. Update the plan checkboxes as work completes.

- [ ] **Step 4: Run the full verification gate**

Run: `for test in tests/*.sh; do bash "$test" || exit 1; done`

Run: `nix --extra-experimental-features 'nix-command flakes' flake check --all-systems`

Run: `sudo nix run .#darwin-rebuild -- switch --flake .#oss-$(nix eval --impure --raw --expr builtins.currentSystem)`

Run: `HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$PWD/Brewfile" --no-upgrade --verbose`

Expected: every command exits 0; the live switch is recorded separately because it changes system state.
