#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
packages_module="$root_dir/home-manager/modules/packages.nix"
brewfile="$root_dir/Brewfile"
nix_bin="${NIX_BIN:-/nix/var/nix/profiles/default/bin/nix}"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

contains_line() {
  local needle="$1"
  local lines="$2"

  grep -Fxq "$needle" <<<"$lines"
}

home_manager_packages="$({
  sed -nE 's/^[[:space:]]*pkgs\.([A-Za-z0-9_.+-]+)[[:space:]]*(#.*)?$/\1/p' "$packages_module"
} | sort -u)"
brew_formulae="$({
  sed -nE 's/^[[:space:]]*brew "([^"]+)".*$/\1/p' "$brewfile"
} | sort -u)"

required_home_manager_packages="$(cat <<'EOF'
ansible
antidote
bat
btop
cargo
cargo-flamegraph
curl
delta
eza
fastfetch
fd
ffmpeg
fzf
git
gnupg
go
httpie
imagemagick
jless
jq
lazygit
lua
neovim
nmap
nodejs
pnpm
python3
ripgrep
ruff
rustc
starship
television
tree
tree-sitter
ty
uv
vivid
wget
worktrunk
yazi
yt-dlp
zellij
zoxide
zsh
EOF
)"

while IFS= read -r package; do
  contains_line "$package" "$home_manager_packages" ||
    fail "Home Manager should own nixpkgs package $package"
done <<<"$required_home_manager_packages"

portable_brew_formulae="$(cat <<'EOF'
ansible
antidote
bat
btop
eza
fastfetch
fd
ffmpeg
fzf
git
git-delta
gnupg
go
httpie
imagemagick
jless
jq
lazygit
lua
nmap
ripgrep
rust
starship
television
tree
tree-sitter-cli
uv
vivid
wget
worktrunk
yazi
yt-dlp
zellij
zoxide
zsh
EOF
)"

while IFS= read -r formula; do
  if contains_line "$formula" "$brew_formulae"; then
    fail "portable CLI $formula should not be owned by Homebrew"
  fi
done <<<"$portable_brew_formulae"

retained_brew_formulae="$(cat <<'EOF'
agavra/tap/tuicr
awscli
coursier
github-mcp-server
googleworkspace-cli
gradle
helm
herdr
kompose
maven
mysql
openjdk
pinentry
pinentry-mac
reattach-to-user-namespace
ssh-copy-id
tw93/tap/mole
volta
EOF
)"

while IFS= read -r formula; do
  contains_line "$formula" "$brew_formulae" ||
    fail "Homebrew should retain macOS/work tool $formula"
done <<<"$retained_brew_formulae"

while IFS= read -r formula; do
  contains_line "$formula" "$retained_brew_formulae" ||
    fail "Homebrew formula $formula is outside the retained macOS/work boundary"
done <<<"$brew_formulae"

for java_tool in coursier gradle maven openjdk; do
  contains_line "$java_tool" "$brew_formulae" ||
    fail "Homebrew should retain Java tool $java_tool"
  if contains_line "$java_tool" "$home_manager_packages"; then
    fail "Java tool $java_tool should not also be owned by Home Manager"
  fi
done

if grep -Eq '(^|[[:space:]])devShells[[:space:]]*=' "$root_dir/flake.nix"; then
  fail "the flake should not expose development shells"
fi

global_tools="$root_dir/scripts/global-tools"
[[ -x "$global_tools" ]] ||
  fail "mutable agent tooling should be installed by scripts/global-tools"
[[ ! -e "$root_dir/installers/040-global-tools.sh" ]] ||
  fail "the numbered global-tools installer should be retired"
[[ ! -e "$root_dir/installers/060-bat-theme.sh" && ! -e "$root_dir/scripts/bat-theme" ]] ||
  fail "the imperative bat theme downloader should be removed"

for mutable_agent_tool in '@anthropic-ai/claude-code' '@openai/codex' 'hunkdiff'; do
  grep -Fq "npm install -g --prefix \"\$HOME/.local\" $mutable_agent_tool" "$global_tools" ||
    fail "global-tools should preserve mutable agent package $mutable_agent_tool"
done

if grep -Eq '(cargo install|uv tool install|volta install)' "$global_tools"; then
  fail "Nix-packaged language tools should not also be installed imperatively"
fi
if grep -Eiq '(Brewfile|brew install|Homebrew)' "$global_tools"; then
  fail "global-tools runtime diagnostics should be package-manager neutral"
fi

helper_test_home="$(mktemp -d)"
trap 'rm -rf "$helper_test_home"' EXIT
mkdir -p "$helper_test_home/fake-bin" "$helper_test_home/fake-hunk-skill"
printf '%s\n' 'fake Hunk skill' >"$helper_test_home/fake-hunk-skill/SKILL.md"
cat >"$helper_test_home/fake-bin/npm" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

prefix=''
package=''
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --prefix)
      prefix="$2"
      shift 2
      ;;
    install|-g)
      shift
      ;;
    *)
      package="$1"
      shift
      ;;
  esac
done

if [[ "$package" == 'hunkdiff' ]]; then
  mkdir -p "$prefix/bin"
  cat >"$prefix/bin/hunk" <<'HUNK'
#!/usr/bin/env bash
if [[ "${1:-}" == 'skill' && "${2:-}" == 'path' ]]; then
  printf '%s\n' "$HOME/fake-hunk-skill/SKILL.md"
fi
HUNK
  chmod +x "$prefix/bin/hunk"
fi
EOF
chmod +x "$helper_test_home/fake-bin/npm"

HOME="$helper_test_home" PATH="$helper_test_home/fake-bin:/usr/bin:/bin" \
  /bin/bash "$global_tools" >/dev/null
[[ -f "$helper_test_home/.agents/skills/hunk-review/SKILL.md" ]] ||
  fail "global-tools should sync the Hunk skill installed under the mutable user prefix"

[[ -x "$nix_bin" ]] || fail "Nix is required to evaluate package ownership"
nix_args=(--extra-experimental-features 'nix-command flakes')
required_count="$(wc -l <<<"$required_home_manager_packages" | tr -d ' ')"

for system in aarch64-darwin x86_64-darwin; do
  evaluated_packages="$({
    "$nix_bin" "${nix_args[@]}" eval --raw \
      "$root_dir#homeConfigurations.\"oss-$system\".config.home.packages" \
      --apply 'packages: builtins.concatStringsSep "\n" (map toString packages)'
  })"
  evaluated_count="$(wc -l <<<"$evaluated_packages" | tr -d ' ')"
  (( evaluated_count >= required_count )) ||
    fail "the $system Home Manager target evaluated fewer packages than required"

  duplicate_package="$(sort <<<"$evaluated_packages" | uniq -d | head -n 1)"
  [[ -z "$duplicate_package" ]] ||
    fail "the $system Home Manager target includes a package twice: $duplicate_package"

  grep -Eq '/[^/]*-tmux-[^/]*$' <<<"$evaluated_packages" ||
    fail "the $system Home Manager target should include tmux through programs.tmux"
done

printf 'PASS: portable CLI ownership is singular and both package sets evaluate\n'
