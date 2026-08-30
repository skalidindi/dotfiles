#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
nix_bin="/nix/var/nix/profiles/default/bin/nix"

if [[ ! -x "$nix_bin" ]]; then
  printf 'SKIP: Nix is not installed\n'
  exit 77
fi

nix_args=(--extra-experimental-features 'nix-command flakes')

"$nix_bin" "${nix_args[@]}" eval --raw "$root_dir#homeConfigurations.oss.activationPackage.drvPath" >/dev/null
"$nix_bin" "${nix_args[@]}" eval --raw "$root_dir#homeConfigurations.\"oss-x86_64-darwin\".activationPackage.drvPath" >/dev/null
"$nix_bin" "${nix_args[@]}" eval --raw "$root_dir#packages.aarch64-darwin.home-manager.name" >/dev/null

grep -Fq 'home-manager' "$root_dir/flake.nix" || {
  printf 'FAIL: flake should declare Home Manager\n' >&2
  exit 1
}

grep -Fq 'starship.toml' "$root_dir/home-manager/oss.nix" || {
  printf 'FAIL: Home Manager should own the Starship config\n' >&2
  exit 1
}

for config_dir in zellij yazi fastfetch ghostty lazygit herdr worktrunk; do
  grep -Fq "${config_dir}" "$root_dir/home-manager/oss.nix" || {
    printf 'FAIL: Home Manager should own the %s config\n' "$config_dir" >&2
    exit 1
  }
done

for home_file in .aliases .bash_profile .exports .functions .path .zshrc .zsh_plugins.txt .agents/README.md .agents/prompts/base.md git/.gitconfig.common; do
  grep -Fq "$home_file" "$root_dir/home-manager/oss.nix" || {
    printf 'FAIL: Home Manager should own the %s file\n' "$home_file" >&2
    exit 1
  }
done

grep -Fq 'home.username' "$root_dir/home-manager/hosts/skalidindi.nix" || {
  printf 'FAIL: account identity should live in a host module\n' >&2
  exit 1
}

if grep -Fq 'home.username' "$root_dir/home-manager/oss.nix"; then
  printf 'FAIL: shared OSS module should not hardcode an account identity\n' >&2
  exit 1
fi

grep -Fq 'programs.tmux' "$root_dir/home-manager/oss.nix" || {
  printf 'FAIL: Home Manager should own tmux configuration and plugins\n' >&2
  exit 1
}

grep -Fq 'pkgs.neovim' "$root_dir/home-manager/oss.nix" || {
  printf 'FAIL: Home Manager should install Neovim\n' >&2
  exit 1
}

for helper in agent-doctor agent-runtime-guard configure-oss-git install-agent-assets restore-skills-sh zrun; do
  grep -Fq ".local/bin/$helper" "$root_dir/home-manager/oss.nix" || {
    printf 'FAIL: Home Manager should own the %s helper\n' "$helper" >&2
    exit 1
  }
done

printf 'PASS: Home Manager tests\n'
