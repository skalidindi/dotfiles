# Dotfiles

Personal macOS dotfiles for a development machine. Home Manager owns portable
command-line packages, static configuration, and helper scripts. Homebrew owns
GUI applications, fonts, and the macOS- or Work-specific tools outside the
portable Home Manager boundary. Auth, sessions, caches, generated files, and
other runtime state stay local and ignored.

## Fresh laptop setup

Clone the repository, then run the one normal installation command:

```bash
git clone https://github.com/skalidindi/dotfiles.git ~/oss/dotfiles
cd ~/oss/dotfiles
./scripts/bootstrap
```

Bootstrap installs Homebrew and Nix when either is absent, applies the Brewfile,
activates the Home Manager target for the current Mac architecture, installs
mutable agent CLIs, and restores the local agent and Git integration. If
`env/.env-secrets.gpg` exists, it also decrypts that file atomically into the
ignored `$HOME/.env-secrets` file.

The Nix installer can complete before its profile is visible to the current
shell. Bootstrap checks the standard Nix profile directly, but if Nix is still
unavailable, open a fresh terminal and run `./scripts/bootstrap` again as the
error instructs.

After installation, `agent-doctor` gives a quick status report for the agent
surfaces, launcher commands, and runtime-state boundaries.

## Normal maintenance

From the repository root, run:

```bash
./scripts/update
```

Update runs Homebrew update and upgrade, updates the locked Nix inputs, then
runs `./scripts/bootstrap` to reapply the complete configuration. Review and
commit an intentional `flake.lock` change after maintenance. This command does
not pull repository changes.

## Package and configuration ownership

- Home Manager installs portable CLI packages from
  `home-manager/modules/packages.nix`.
- Home Manager links static configuration from `config/` and executable helpers
  from `scripts/bin/`.
- `Brewfile` owns macOS applications, fonts, Java tooling, and the retained
  macOS or Work-adjacent formulae.
- `scripts/global-tools` owns mutable npm-installed agent CLIs and the Hunk
  agent skill.
- `scripts/secrets` owns the optional encrypted environment-file migration and
  decryption step.

Each target should have one owner. Files that applications mutate during normal
use should remain local or be seeded once rather than linked as immutable
configuration.

## Home Manager hosts

The flake exposes explicit `oss-aarch64-darwin` and
`oss-x86_64-darwin` configurations. `./scripts/bootstrap` selects one from the
current machine architecture.

The account-specific username, home directory, and OSS Git identity live in
`home-manager/hosts/skalidindi.nix`. To use this repository for another macOS
account, add a host module and matching flake target rather than putting identity
data in the shared modules.

## Repository layout

- `config/` contains declarative shell, editor, terminal, Git, and agent files.
- `home-manager/hosts/` contains account-specific Home Manager configuration.
- `home-manager/modules/` defines shared file, package, and program ownership.
- `scripts/bin/` contains portable helpers installed into `$HOME/.local/bin`.
- `scripts/bootstrap` performs installation and applies the full configuration.
- `scripts/update` handles package and flake maintenance.
- `Brewfile` lists Homebrew-owned applications and retained formulae.
- `env/` contains encrypted environment seed material. Plaintext stays ignored.
- `tests/` contains shell tests for layout, ownership, entrypoints, and behavior.

## Local verification

Run the shell tests sequentially:

```bash
for test in tests/*.sh; do bash "$test"; done
```

Validate every flake output and both Home Manager targets:

```bash
nix --extra-experimental-features 'nix-command flakes' flake check --all-systems
bash tests/home-manager.sh
```

Apply the current architecture configuration when validating a real macOS home:

```bash
export NIX_CONFIG="extra-experimental-features = nix-command flakes"
nix run .#home-manager -- switch --flake .#oss-$(nix eval --impure --raw --expr builtins.currentSystem)
```

Check that the current Homebrew installation satisfies the Brewfile without
upgrading anything:

```bash
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$PWD/Brewfile" --no-upgrade --verbose
```

## Agent runtime state

Shared portable agent assets are installed under `~/.agents`. Runtime state,
auth, sessions, caches, memories, generated catalogs, and decrypted environment
files must stay local and ignored. Useful checks and helpers are:

```bash
agent-doctor
agent-runtime-guard
install-agent-assets
restore-skills-sh
restore-skills-sh --apply
```

For long-lived interactive agents, start or attach a zellij session manually,
then run the agent normally. Codex and Claude are installer-managed binaries;
this repository does not track wrapper files or aliases for them.

## License

This project is open source and available under the [MIT License](LICENSE).
