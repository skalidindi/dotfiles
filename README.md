# Dotfiles

Personal macOS dotfiles for a development machine. `nix-darwin` is the system
activation layer and activates Home Manager, which owns portable command-line
packages, static configuration, and helper scripts. Homebrew owns GUI
applications, fonts, and the macOS- or Work-specific tools outside the portable
Home Manager boundary. Auth, sessions, caches, generated files, and other
runtime state stay local and ignored.

## Fresh laptop setup

Clone the repository, then run the one normal installation command:

```bash
git clone https://github.com/skalidindi/dotfiles.git ~/oss/dotfiles
cd ~/oss/dotfiles
./scripts/bootstrap
```

Bootstrap installs Nix when it is absent and activates the Nix/Darwin target
for the current Mac architecture first. It then installs Homebrew when needed,
applies the Brewfile, installs mutable agent CLIs, and restores the local agent
and Git integration. If Nix installation or Nix/Darwin activation fails,
bootstrap stops before any Homebrew package mutation. If
`env/.env-secrets.gpg` exists, it also decrypts that file atomically into the
ignored `$HOME/.env-secrets` file.

The Nix installer can complete before its profile is visible to the current
shell. Bootstrap checks the standard Nix profile directly, but if Nix is still
unavailable, open a fresh terminal and run `./scripts/bootstrap` again as the
error instructs.

## Normal maintenance

From the repository root, run:

```bash
./scripts/update
```

Update first verifies that Nix and Homebrew are available, updates the locked
Nix inputs, and runs `./scripts/bootstrap` to activate Nix/Darwin and reapply
the complete configuration before Homebrew update or upgrade. Review and commit
an intentional `flake.lock` change after maintenance. This command does not
pull repository changes.

## Package and configuration ownership

- `nix-darwin` is the system activation layer. It configures Nix and activates
  the Home Manager user configuration; it does not manage Homebrew packages.
- Home Manager is the user configuration layer. It installs portable CLI
  packages from
  `home-manager/modules/packages.nix`.
- Home Manager links static configuration from `config/` and executable helpers
  from `scripts/bin/`.
- `Brewfile` remains the sole Homebrew package source. It owns macOS
  applications, fonts, Java tooling, and the retained macOS or Work-adjacent
  formulae.
- `nix-homebrew` is intentionally absent. Homebrew installation and tap
  management would add a second package-owner migration without improving the
  existing Brewfile boundary.
- `scripts/global-tools` owns mutable npm-installed agent CLIs and the Hunk
  agent skill.
- `scripts/secrets` owns the optional encrypted environment-file migration and
  decryption step.

Each target should have one owner. Files that applications mutate during normal
use should remain local or be seeded once rather than linked as immutable
configuration.

## Nix/Darwin hosts

The flake exposes explicit `oss-aarch64-darwin` and
`oss-x86_64-darwin` configurations. `./scripts/bootstrap` selects one from the
current machine architecture.

`home-manager/hosts/skalidindi.nix` owns the Home Manager account identity and
OSS Git identity. `darwin/hosts/skalidindi.nix` owns the system primary user and
derived macOS home directory. To use this repository for another macOS account,
add both host modules and a matching flake target rather than putting identity
data in shared modules.

## Repository layout

- `config/` contains declarative shell, editor, terminal, Git, and agent files.
- `darwin/hosts/` contains account-specific nix-darwin system configuration.
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
for test in tests/*.sh; do bash "$test" || exit 1; done
```

Validate every flake output and both Nix/Darwin targets:

```bash
nix --extra-experimental-features 'nix-command flakes' flake check --all-systems
bash tests/home-manager.sh
```

Apply the current architecture configuration when validating a real macOS home:

```bash
target="oss-$(nix --extra-experimental-features 'nix-command flakes' eval --impure --raw --expr builtins.currentSystem)"
sudo env NIX_CONFIG="extra-experimental-features = nix-command flakes" \
  nix run .#darwin-rebuild -- switch --flake ".#$target"
```

Check that the current Homebrew installation satisfies the Brewfile without
upgrading anything:

```bash
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$PWD/Brewfile" --no-upgrade --verbose
```

## Advanced troubleshooting

Shared portable agent assets are installed under `~/.agents`. Runtime state,
auth, sessions, caches, memories, generated catalogs, and decrypted environment
files must stay local and ignored. These diagnostic and repair helpers are not
part of normal setup or maintenance:

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
