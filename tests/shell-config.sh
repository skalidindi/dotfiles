#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-shell.XXXXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

home="$sandbox/home"
mkdir -p \
  "$home/.nix-profile/bin" \
  "$home/.nix-profile/share/antidote" \
  "$home/.cargo/bin" \
  "$home/.npm-global/bin" \
  "$home/.volta/bin" \
  "$home/.local/bin" \
  "$home/.nub/bin" \
  "$home/.antigravity/antigravity/bin" \
  "$home/xp-env/bin" \
  "$home/bin"

for command_dir in \
  "$home/.nix-profile/bin" \
  "$home/.cargo/bin" \
  "$home/.npm-global/bin" \
  "$home/.volta/bin" \
  "$home/.local/bin" \
  "$home/.nub/bin" \
  "$home/.antigravity/antigravity/bin" \
  "$home/xp-env/bin"; do
  for command_name in cargo git node nvim; do
    printf '#!/usr/bin/env bash\n' >"$command_dir/$command_name"
    chmod +x "$command_dir/$command_name"
  done
done

printf '#!/usr/bin/env bash\n' >"$home/.local/bin/agent-doctor"
chmod +x "$home/.local/bin/agent-doctor"

cat >"$home/.nix-profile/bin/brew" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$HOME/fake-homebrew"
EOF
chmod +x "$home/.nix-profile/bin/brew"

if ! resolved_commands="$({
  HOME="$home" PATH="$home/.local/bin:$home/.nix-profile/bin:/usr/bin:/bin" /bin/bash -c '
    unset PYTHON_HOME
    source "$1"
    path_once="$PATH"
    source "$1"
    [[ "$PATH" == "$path_once" ]] || exit 1
    printf "%s\n" "$PATH" "$(command -v git)" "$(command -v agent-doctor)" "${PYTHON_HOME-unset}"
  ' _ "$root_dir/config/bash/.path"
})"; then
  fail "repeated shell startup should not accumulate PATH entries"
fi
resolved_path="$(sed -n '1p' <<<"$resolved_commands")"
resolved_git="$(sed -n '2p' <<<"$resolved_commands")"
resolved_agent_doctor="$(sed -n '3p' <<<"$resolved_commands")"
python_home="$(sed -n '4p' <<<"$resolved_commands")"

[[ "$resolved_path" == "$home/.nix-profile/bin:"* ]] ||
  fail "Home Manager packages should remain first on PATH"
[[ "$resolved_git" == "$home/.nix-profile/bin/git" ]] ||
  fail "legacy tool directories should not shadow Home Manager packages"
[[ "$resolved_agent_doctor" == "$home/.local/bin/agent-doctor" ]] ||
  fail "user-owned helpers should remain discoverable"
[[ "$python_home" == unset && "$resolved_path" != *'/opt/python/libexec'* ]] ||
  fail "shell startup should not retain the removed Homebrew Python path"

cat >"$home/.nix-profile/share/antidote/antidote.zsh" <<'EOF'
export ANTIDOTE_FROM_NIX_PROFILE=1
EOF

for shell_file in .aliases .bash_profile .exports .functions .path; do
  ln -s "$root_dir/config/bash/$shell_file" "$home/$shell_file"
done

cat >"$home/.cargo/env" <<'EOF'
export PATH="$HOME/.cargo/bin:$PATH"
EOF

for command_name in starship zoxide vivid; do
  cat >"$home/.nix-profile/bin/$command_name" <<'EOF'
#!/usr/bin/env bash
printf ':\n'
EOF
  chmod +x "$home/.nix-profile/bin/$command_name"
done

cat >"$home/.nix-profile/bin/tty" <<'EOF'
#!/usr/bin/env bash
printf '/dev/ttys001\n'
EOF
chmod +x "$home/.nix-profile/bin/tty"

for launcher in nub antigravity xp; do
  case "$launcher" in
    nub) launcher_dir="$home/.nub/bin" ;;
    antigravity) launcher_dir="$home/.antigravity/antigravity/bin" ;;
    xp) launcher_dir="$home/xp-env/bin" ;;
  esac
  printf '#!/usr/bin/env bash\n' >"$launcher_dir/$launcher"
  chmod +x "$launcher_dir/$launcher"
done

zsh_stderr="$sandbox/zsh.stderr"
if ! zsh_result="$({
  HOME="$home" TERM=dumb PATH="$home/.nix-profile/bin:/usr/bin:/bin" \
    /bin/zsh -c '
      source "$1"
      print -r -- "$ANTIDOTE_FROM_NIX_PROFILE"
      for command_name in cargo git node nvim; do
        command -v "$command_name"
      done
      print -r -- "$PATH"
    ' _ "$root_dir/config/zsh/.zshrc"
})" 2>"$zsh_stderr"; then
  fail "zsh should load Antidote from the Home Manager profile"
fi
[[ ! -s "$zsh_stderr" ]] ||
  fail "zsh should ignore a missing legacy Cargo environment"

[[ "$(sed -n '1p' <<<"$zsh_result")" == 1 ]] ||
  fail "zsh should load Antidote from the Home Manager profile"
for result_line in 2 3 4 5; do
  [[ "$(sed -n "${result_line}p" <<<"$zsh_result")" == "$home/.nix-profile/bin/"* ]] ||
    fail "the complete zsh startup chain should keep Home Manager tools authoritative"
done

zsh_path="$(sed -n '6p' <<<"$zsh_result")"
for launcher_dir in \
  "$home/.nub/bin" \
  "$home/.antigravity/antigravity/bin" \
  "$home/xp-env/bin"; do
  [[ ":$zsh_path:" == *":$launcher_dir:"* ]] ||
    fail "zsh should retain launcher path $launcher_dir"
done

printf 'PASS: shell startup keeps Home Manager tools authoritative\n'
