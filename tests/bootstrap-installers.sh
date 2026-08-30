#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-bootstrap.XXXXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

for script in scripts/bootstrap scripts/update scripts/secrets; do
  [[ -x "$root_dir/$script" ]] || fail "$script should be an executable entrypoint"
done

[[ ! -e "$root_dir/bootstrap.sh" ]] ||
  fail "the retired root bootstrap script should not exist"
[[ ! -e "$root_dir/installers" ]] ||
  fail "the numbered installer directory should not exist"

mkdir -p "$sandbox/bin" "$sandbox/home/.local/bin" "$sandbox/homebrew/bin"
command_log="$sandbox/commands.log"
: >"$command_log"

cat >"$sandbox/bin/uname" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "${FAKE_ARCH:?FAKE_ARCH is required}"
EOF

cat >"$sandbox/bin/brew" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'brew %s\n' "$*" >>"$BOOTSTRAP_COMMAND_LOG"

if [[ "${FAKE_FAILURE:-}" == "brew-${1:-}" ]]; then
  exit 42
fi

case "${1:-}" in
  shellenv)
    printf ':\n'
    ;;
  bundle|update|upgrade)
    ;;
  *)
    printf 'unexpected brew command: %s\n' "$*" >&2
    exit 64
    ;;
esac
EOF

cat >"$sandbox/bin/nix" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'nix %s\n' "$*" >>"$BOOTSTRAP_COMMAND_LOG"

if [[ "${FAKE_FAILURE:-}" == "nix-${1:-}" ]]; then
  exit 42
fi

if [[ "${1:-}" == run && "${FAKE_NIX_OMIT_NPM:-0}" != 1 ]]; then
  mkdir -p "$HOME/.nix-profile/bin"
  cat >"$HOME/.nix-profile/bin/npm" <<'NPM'
#!/usr/bin/env bash
set -euo pipefail
printf 'npm %s\n' "$*" >>"$BOOTSTRAP_COMMAND_LOG"
NPM
  chmod +x "$HOME/.nix-profile/bin/npm"
fi
EOF

cat >"$sandbox/bin/gpg" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'gpg %s\n' "$*" >>"$BOOTSTRAP_COMMAND_LOG"
printf 'test material\n'
EOF

cat >"$sandbox/home/.local/bin/install-agent-assets" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'agent-assets\n' >>"$BOOTSTRAP_COMMAND_LOG"
EOF

cat >"$sandbox/home/.local/bin/configure-oss-git" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'configure-oss-git\n' >>"$BOOTSTRAP_COMMAND_LOG"
EOF

chmod +x "$sandbox/bin"/* "$sandbox/home/.local/bin"/*
ln -s "$sandbox/bin/brew" "$sandbox/homebrew/bin/brew"
export HOMEBREW_PREFIX="$sandbox/homebrew"

assert_log_order() {
  local expected
  local line
  local previous_line=0

  for expected in "$@"; do
    line="$(grep -n -F -m 1 "$expected" "$command_log" | cut -d: -f1 || true)"
    [[ -n "$line" ]] || fail "expected command was not run: $expected"
    (( line > previous_line )) || fail "commands ran out of order near: $expected"
    previous_line="$line"
  done
}

run_bootstrap() {
  HOME="$sandbox/home" \
    PATH="$sandbox/bin:/usr/bin:/bin" \
    BOOTSTRAP_COMMAND_LOG="$command_log" \
    FAKE_ARCH="$1" \
    FAKE_NIX_OMIT_NPM="${2:-0}" \
    "$root_dir/scripts/bootstrap" >/dev/null
}

run_bootstrap arm64
assert_log_order \
  'nix run .#home-manager -- switch --flake .#oss-aarch64-darwin' \
  'brew shellenv' \
  "brew bundle --file=$root_dir/Brewfile" \
  'agent-assets' \
  'configure-oss-git' \
  'npm install -g --prefix /' \
  'gpg --decrypt '

: >"$command_log"
run_bootstrap x86_64
grep -Fxq 'nix run .#home-manager -- switch --flake .#oss-x86_64-darwin' "$command_log" ||
  fail "x86_64 should select the Intel Home Manager target"

: >"$command_log"
rm -f "$sandbox/home/.nix-profile/bin/npm"
if run_bootstrap arm64 1 2>/dev/null; then
  fail "bootstrap should fail when Home Manager does not provide npm"
fi
if grep -Fq 'npm install' "$command_log"; then
  fail "bootstrap should not report npm installs when npm is unavailable"
fi

: >"$command_log"
if HOME="$sandbox/home" \
  PATH="$sandbox/bin:/usr/bin:/bin" \
  BOOTSTRAP_COMMAND_LOG="$command_log" \
  FAKE_ARCH=arm64 \
  FAKE_FAILURE=nix-run \
  "$root_dir/scripts/bootstrap" >/dev/null 2>&1; then
  fail "bootstrap should stop when Home Manager activation fails"
fi
[[ "$(cat "$command_log")" == 'nix run .#home-manager -- switch --flake .#oss-aarch64-darwin' ]] ||
  fail "bootstrap should activate Home Manager before mutating Homebrew packages"

: >"$command_log"
if HOME="$sandbox/home" \
  PATH="$sandbox/bin:/usr/bin:/bin" \
  BOOTSTRAP_COMMAND_LOG="$command_log" \
  FAKE_ARCH=unsupported-cpu \
  "$root_dir/scripts/bootstrap" >/dev/null 2>&1; then
  fail "an unsupported architecture should stop bootstrap"
fi
if grep -Fq 'nix run' "$command_log"; then
  fail "an unsupported architecture should stop before Home Manager activation"
fi

: >"$command_log"
HOME="$sandbox/home" \
  PATH="$sandbox/bin:/usr/bin:/bin" \
  BOOTSTRAP_COMMAND_LOG="$command_log" \
  FAKE_ARCH=arm64 \
  "$root_dir/scripts/update" >/dev/null
assert_log_order \
  'brew update' \
  'brew upgrade' \
  'nix flake update' \
  'nix run .#home-manager -- switch --flake .#oss-aarch64-darwin'

: >"$command_log"
if HOME="$sandbox/home" \
  PATH="$sandbox/bin:/usr/bin:/bin" \
  NIX_BIN="$sandbox/missing-nix" \
  BOOTSTRAP_COMMAND_LOG="$command_log" \
  FAKE_ARCH=arm64 \
  "$root_dir/scripts/update" >/dev/null 2>&1; then
  fail "update should require Nix before package-manager mutation"
fi
[[ ! -s "$command_log" ]] ||
  fail "update should discover Nix before brew update or upgrade"

: >"$command_log"
if HOME="$sandbox/home" \
  PATH="$sandbox/bin:/usr/bin:/bin" \
  BOOTSTRAP_COMMAND_LOG="$command_log" \
  FAKE_ARCH=arm64 \
  FAKE_FAILURE=brew-update \
  "$root_dir/scripts/update" >/dev/null 2>&1; then
  fail "update should stop when brew update fails"
fi
[[ "$(cat "$command_log")" == 'brew update' ]] ||
  fail "update should not continue after a failed brew update"

: >"$command_log"
if HOME="$sandbox/home" \
  PATH="$sandbox/bin:/usr/bin:/bin" \
  BOOTSTRAP_COMMAND_LOG="$command_log" \
  FAKE_ARCH=arm64 \
  FAKE_FAILURE=brew-upgrade \
  "$root_dir/scripts/update" >/dev/null 2>&1; then
  fail "update should stop when brew upgrade fails"
fi
[[ "$(cat "$command_log")" == $'brew update\nbrew upgrade' ]] ||
  fail "update should not bootstrap after a failed brew upgrade"

: >"$command_log"
if HOME="$sandbox/home" \
  PATH="$sandbox/bin:/usr/bin:/bin" \
  BOOTSTRAP_COMMAND_LOG="$command_log" \
  FAKE_ARCH=arm64 \
  FAKE_FAILURE=nix-flake \
  "$root_dir/scripts/update" >/dev/null 2>&1; then
  fail "update should stop when nix flake update fails"
fi
[[ "$(cat "$command_log")" == $'brew update\nbrew upgrade\nnix flake update' ]] ||
  fail "update should not bootstrap after a failed nix flake update"

printf 'PASS: bootstrap and update commands select supported targets and stop on failure\n'
