#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-secrets.XXXXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

mkdir -p "$sandbox/home" "$sandbox/bin"
cat >"$sandbox/bin/gpg" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
if [[ "${FAKE_GPG_MODE:-success}" == failure ]]; then
  printf 'partial secret\n'
  exit 1
fi
printf 'secret value\n'
EOF
chmod +x "$sandbox/bin/gpg"

HOME="$sandbox/home" PATH="$sandbox/bin:$PATH" "$root_dir/scripts/secrets" >/dev/null

[[ "$(cat "$sandbox/home/.env-secrets")" == "secret value" ]] || {
  printf 'FAIL: secrets should be written to the home file shells source\n' >&2
  exit 1
}

if [[ "$(stat -f '%Lp' "$sandbox/home/.env-secrets")" != 600 ]]; then
  printf 'FAIL: secrets should be mode 0600\n' >&2
  exit 1
fi

printf 'existing secret\n' >"$sandbox/home/.env-secrets"
if HOME="$sandbox/home" PATH="$sandbox/bin:$PATH" FAKE_GPG_MODE=failure \
  "$root_dir/scripts/secrets" >/dev/null 2>&1; then
  printf 'FAIL: failed decryption should fail the installer\n' >&2
  exit 1
fi

[[ "$(cat "$sandbox/home/.env-secrets")" == "existing secret" ]] || {
  printf 'FAIL: failed decryption should preserve the existing secret file\n' >&2
  exit 1
}

rm -f "$sandbox/home/.env-secrets"
ln -s "$root_dir/env/.env-secrets" "$sandbox/home/.env-secrets"
HOME="$sandbox/home" PATH="$sandbox/bin:$PATH" "$root_dir/scripts/secrets" >/dev/null

[[ ! -L "$sandbox/home/.env-secrets" ]] || {
  printf 'FAIL: legacy secrets symlink should be replaced with a regular home file\n' >&2
  exit 1
}
[[ "$(cat "$sandbox/home/.env-secrets")" == "secret value" ]] || {
  printf 'FAIL: migrated secrets should be written to the home file\n' >&2
  exit 1
}
unexpected_target="$sandbox/unexpected/.env-secrets"
mkdir -p "$(dirname "$unexpected_target")"
printf 'unrelated secret\n' >"$unexpected_target"
rm -f "$sandbox/home/.env-secrets"
ln -s "$unexpected_target" "$sandbox/home/.env-secrets"

if HOME="$sandbox/home" PATH="$sandbox/bin:$PATH" \
  "$root_dir/scripts/secrets" >/dev/null 2>&1; then
  printf 'FAIL: unexpected secrets symlink should stop the helper\n' >&2
  exit 1
fi

[[ -L "$sandbox/home/.env-secrets" ]] || {
  printf 'FAIL: unexpected secrets symlink should be preserved\n' >&2
  exit 1
}
[[ "$(cat "$unexpected_target")" == "unrelated secret" ]] || {
  printf 'FAIL: unexpected symlink target should not be overwritten\n' >&2
  exit 1
}

printf 'PASS: secrets tests\n'
