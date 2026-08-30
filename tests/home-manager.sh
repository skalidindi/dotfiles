#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
nix_bin="/nix/var/nix/profiles/default/bin/nix"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

for module in files packages programs; do
  [[ -f "$root_dir/home-manager/modules/$module.nix" ]] ||
    fail "Home Manager should define a focused $module module"
done

[[ ! -e "$root_dir/home-manager/oss.nix" ]] ||
  fail "the monolithic Home Manager module should be removed"

host_module="$root_dir/home-manager/hosts/skalidindi.nix"
shared_modules="$root_dir/home-manager/modules"

for identity_setting in \
  'home.username' \
  'home.homeDirectory = "/Users/${config.home.username}"' \
  'Santosh Kalidindi' \
  'skalidindi8@gmail.com' \
  '5EFA48B9657D7C02' \
  'git/.gitconfig.oss-base' \
  'git/.gitconfig.oss-laptop' \
  'includeIf'; do
  grep -Fq "$identity_setting" "$host_module" ||
    fail "the host module should own $identity_setting"
done

for forbidden_identity in \
  'home.username' \
  '/Users/' \
  'Santosh Kalidindi' \
  'skalidindi8@gmail.com' \
  '5EFA48B9657D7C02' \
  'git/.gitconfig.oss-laptop'; do
  if grep -RFq "$forbidden_identity" "$shared_modules"; then
    fail "shared modules should not own $forbidden_identity"
  fi
done

[[ ! -e "$root_dir/config/git/.gitconfig.oss-base" ]] ||
  fail "personal Git identity should be declared by the host module"
[[ ! -e "$root_dir/config/git/.gitconfig.oss-laptop" ]] ||
  fail "the laptop Git include should be declared by the host module"

files_module="$shared_modules/files.nix"
programs_module="$shared_modules/programs.nix"
packages_module="$shared_modules/packages.nix"

grep -Fq '../../config/' "$files_module" ||
  fail "static Home Manager sources should come from config/"
grep -Fq '../../scripts/bin/' "$files_module" ||
  fail "managed helpers should come from scripts/bin/"
grep -Fq '../../config/' "$programs_module" ||
  fail "program configuration should come from config/"

for legacy_source in '../agents/' '../bash/' '../bin/' '../git/' '../nvim/' '../tmux/'; do
  if grep -RFq "$legacy_source" "$shared_modules"; then
    fail "shared modules should not reference legacy source $legacy_source"
  fi
done

grep -Fq 'git/.gitconfig.common' "$files_module" ||
  fail "the files module should own the common Git configuration"
grep -Fq 'git/ignore' "$files_module" ||
  fail "the files module should own the global Git ignore file"
grep -Fq 'programs.tmux' "$programs_module" ||
  fail "the programs module should own tmux configuration and plugins"
for tmux_setting in \
  'prefix = "C-Space";' \
  'keyMode = "vi";' \
  'mouse = true;' \
  'extraConfig = builtins.readFile ../../config/tmux/tmux.conf;'; do
  grep -Fq "$tmux_setting" "$programs_module" ||
    fail "the programs module should preserve tmux setting: $tmux_setting"
done

for tmux_plugin in sensible yank resurrect continuum dracula vim-tmux-navigator; do
  grep -Eq "^[[:space:]]+$tmux_plugin$" "$programs_module" ||
    fail "the programs module should preserve the $tmux_plugin tmux plugin"
done

grep -Fq 'nvimLazyLock' "$programs_module" ||
  fail "the programs module should preserve Neovim lazy-lock seeding"
grep -Fq 'baseNameOf path != "lazy-lock.json"' "$programs_module" ||
  fail "the managed Neovim tree should leave lazy-lock.json writable"
grep -Fq 'home.activation.nvimLazyLock = lib.hm.dag.entryAfter [ "linkGeneration" ]' "$programs_module" ||
  fail "Neovim lazy-lock seeding should run after link generation"
grep -Fq 'lock="$HOME/.config/nvim/lazy-lock.json"' "$programs_module" ||
  fail "Neovim lazy-lock seeding should target the Home Manager user's config"
grep -Fq 'if [ ! -e "$lock" ]' "$programs_module" ||
  fail "Neovim lazy-lock seeding should remain first-install-only"
grep -Fq 'cp ${../../config/nvim/lazy-lock.json} "$lock"' "$programs_module" ||
  fail "Neovim lazy-lock seeding should copy the repository seed into the guarded target"
grep -Fq 'pkgs.neovim' "$packages_module" ||
  fail "the packages module should retain Neovim ownership"

for helper in agent-doctor agent-runtime-guard configure-oss-git install-agent-assets restore-skills-sh zrun; do
  grep -Fq ".local/bin/$helper" "$files_module" ||
    fail "the files module should own the $helper helper"
done

for module in hosts/skalidindi modules/files modules/packages modules/programs; do
  grep -Fq "./home-manager/$module.nix" "$root_dir/flake.nix" ||
    fail "the flake should import $module.nix"
done

if grep -Eq '(^|[[:space:]])devShells[[:space:]]*=' "$root_dir/flake.nix"; then
  fail "the flake should not expose development shells"
fi

if [[ ! -x "$nix_bin" ]]; then
  printf 'SKIP: Nix is not installed\n'
  exit 77
fi

nix_args=(--extra-experimental-features 'nix-command flakes')

target_names="$("$nix_bin" "${nix_args[@]}" eval --raw "$root_dir#homeConfigurations" \
  --apply 'configs: builtins.concatStringsSep "," (builtins.attrNames configs)')"
[[ "$target_names" == 'oss-aarch64-darwin,oss-x86_64-darwin' ]] ||
  fail "Home Manager should expose only explicit Apple Silicon and Intel targets"

"$nix_bin" "${nix_args[@]}" eval --raw \
  "$root_dir#homeConfigurations.\"oss-aarch64-darwin\".activationPackage.drvPath" >/dev/null
"$nix_bin" "${nix_args[@]}" eval --raw \
  "$root_dir#homeConfigurations.\"oss-x86_64-darwin\".activationPackage.drvPath" >/dev/null
"$nix_bin" "${nix_args[@]}" eval --raw \
  "$root_dir#packages.aarch64-darwin.home-manager.name" >/dev/null

git_profile="$("$nix_bin" "${nix_args[@]}" eval --raw \
  "$root_dir#homeConfigurations.\"oss-aarch64-darwin\".config.xdg.configFile.\"git/.gitconfig.oss-base\".text")"
signing_key="$(printf '%s' "$git_profile" | git config --file /dev/stdin --get user.signingKey || true)"
gpg_sign="$(printf '%s' "$git_profile" | git config --file /dev/stdin --type=bool --get commit.gpgSign || true)"
[[ "$signing_key" == '5EFA48B9657D7C02' ]] ||
  fail "the generated Git profile should select the host GPG key through user.signingKey"
[[ "$gpg_sign" == 'true' ]] ||
  fail "the generated Git profile should enable commit signing"

printf 'PASS: Home Manager modules, identity boundary, and explicit targets\n'
