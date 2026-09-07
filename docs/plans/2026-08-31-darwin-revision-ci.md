# Darwin revision and CI implementation plan

> Implement this plan task by task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Record the Git revision in the active nix-darwin generation and validate the Apple Silicon flake on every GitHub push and pull request.

**Architecture:** Pass the flake's `self` value to nix-darwin through `specialArgs`, so the Darwin host can derive `system.configurationRevision` without hardcoding repository metadata. A single GitHub Actions workflow runs on GitHub's ARM64 macOS runner and only evaluates the flake and existing shell tests.

**Tech Stack:** Nix flakes, nix-darwin 26.05, Bash tests, GitHub Actions, Determinate Nix installer action v22.

**Spec:** `docs/specs/2026-08-31-darwin-revision-ci-design.md`

## Global Constraints

- Support only `aarch64-darwin`; do not reintroduce an Intel target or matrix.
- Do not add nix-homebrew, modify the Brewfile, run Homebrew in CI, or change package ownership.
- Do not inspect, decrypt, or expose secrets.
- CI never invokes `darwin-rebuild switch`, `scripts/bootstrap`, or `scripts/update`.
- Pin third-party GitHub Actions to the reviewed v5 and v22 commits.

---

### Task 1: Record the Darwin configuration revision

**Files:**

- Modify: `flake.nix:30-42`
- Modify: `darwin/hosts/skalidindi.nix:1-9`
- Modify: `tests/home-manager.sh:120-140`

**Interfaces:**

- Consumes: `self.rev` and `self.dirtyRev` supplied by the flake to
  nix-darwin modules.
- Produces: `darwinConfigurations.oss-aarch64-darwin.config.system.configurationRevision`.

- [ ] **Step 1: Write the failing configuration-revision check**

  Add an evaluation in `tests/home-manager.sh` that reads the Darwin
  configuration revision and fails if it is empty. Before the implementation,
  the attribute does not exist, so Nix evaluation must fail.

- [ ] **Step 2: Run the focused test to verify it fails**

  Run: `bash tests/home-manager.sh`

  Expected: a Nix evaluation error that `system.configurationRevision` is
  missing.

- [ ] **Step 3: Pass flake metadata and set the revision**

  Add `specialArgs = { inherit self; };` to `mkDarwinConfiguration` in
  `flake.nix`. Accept `self` in `darwin/hosts/skalidindi.nix`, then add:

  ```nix
  system.configurationRevision = self.rev or self.dirtyRev or null;
  ```

- [ ] **Step 4: Run the focused test to verify it passes**

  Run: `bash tests/home-manager.sh`

  Expected: `PASS: Home Manager modules, Apple Silicon Darwin integration, and identity boundary`.

- [ ] **Step 5: Commit the revision slice**

  ```bash
  git add flake.nix darwin/hosts/skalidindi.nix tests/home-manager.sh
  git commit -m "feat: record Darwin configuration revision"
  ```

### Task 2: Add an Apple Silicon CI verification gate

**Files:**

- Create: `.github/workflows/verify.yml`
- Create: `tests/ci-workflow.sh`

**Interfaces:**

- Consumes: the existing `tests/*.sh` suite and flake's Apple Silicon-only
  check.
- Produces: a read-only GitHub Actions status check named `Verify` for pushes
  and pull requests to `main`.

- [ ] **Step 1: Write the failing CI-workflow test**

  Create `tests/ci-workflow.sh`. It must require `.github/workflows/verify.yml`
  to declare both `push` and `pull_request` triggers scoped to `main`,
  `permissions: contents: read`, `runs-on: macos-14`, the reviewed checkout
  and Nix-installer commits, the fail-fast shell-test loop, and
  `nix flake check --all-systems`. It must reject `darwin-rebuild switch`,
  `scripts/bootstrap`, `scripts/update`, and `brew` commands.

- [ ] **Step 2: Run the CI-workflow test to verify it fails**

  Run: `bash tests/ci-workflow.sh`

  Expected: failure because `.github/workflows/verify.yml` does not exist.

- [ ] **Step 3: Add the read-only workflow**

  Create `.github/workflows/verify.yml` with a single `Verify` job. Use
  `macos-14`, `actions/checkout@fbc6f3992d24b796d5a048ff273f7fcc4a7b6c09`,
  and `DeterminateSystems/nix-installer-action@ef8a148080ab6020fd15196c2084a2eea5ff2d25`.
  The final step runs:

  ```bash
  for test in tests/*.sh; do bash "$test" || exit 1; done
  nix --extra-experimental-features 'nix-command flakes' flake check --all-systems
  ```

- [ ] **Step 4: Run the CI-workflow test to verify it passes**

  Run: `bash tests/ci-workflow.sh`

  Expected: `PASS: CI workflow validates the Apple Silicon Nix configuration without activation`.

- [ ] **Step 5: Commit the CI slice**

  ```bash
  git add .github/workflows/verify.yml tests/ci-workflow.sh
  git commit -m "ci: verify Darwin configuration"
  ```

### Task 3: Verify the combined change and publish it

**Files:**

- Verify: all tracked files changed by Tasks 1 and 2

**Interfaces:**

- Consumes: both committed feature slices.
- Produces: a green local validation record and `origin/main` containing the
  two commits.

- [ ] **Step 1: Run the complete shell suite**

  Run: `for test in tests/*.sh; do bash "$test" || exit 1; done`

  Expected: each test prints its `PASS:` line, including `tests/ci-workflow.sh`.

- [ ] **Step 2: Run the flake evaluation**

  Run: `nix --extra-experimental-features 'nix-command flakes' flake check --all-systems`

  Expected: exit status 0, with no Intel Darwin evaluation.

- [ ] **Step 3: Inspect the staged history and whitespace**

  Run: `git log --oneline origin/main..HEAD` and `git diff --check origin/main...HEAD`

  Expected: the two feature commits only and no whitespace errors.

- [ ] **Step 4: Push main**

  Run: `git push origin main`

  Expected: `origin/main` advances with both commits.
