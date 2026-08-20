#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-stow-nushell.XXXXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

mkdir -p "$sandbox/bin" "$sandbox/home/.config/nushell"
cat > "$sandbox/bin/uname" <<'SH'
#!/usr/bin/env bash
printf 'Linux\n'
SH
cat > "$sandbox/bin/stow" <<'SH'
#!/usr/bin/env bash
:
SH
chmod +x "$sandbox/bin/uname" "$sandbox/bin/stow"

marker='# >>> work-dotfiles generated vendor scripts >>>'
printf '%s\n' "$marker" > "$sandbox/home/.config/nushell/config.nu"
HOME="$sandbox/home" PATH="$sandbox/bin:/usr/bin:/bin" bash "$root_dir/installers/010-stow.sh" >/dev/null

target="$sandbox/home/.config/nushell/config.nu"
backup="$target.work-generated.bak"
source="$root_dir/nushell/Library/Application Support/nushell/config.nu"
completions_source="$root_dir/nushell/Library/Application Support/nushell/completions"
[[ -L "$target" && "$(readlink "$target")" == "$source" ]] || {
  printf 'FAIL: Linux config should link to the OSS Nushell config\n' >&2
  exit 1
}
[[ -f "$backup" ]] || {
  printf 'FAIL: generated Work config should be backed up\n' >&2
  exit 1
}
[[ -L "$sandbox/home/.config/nushell/completions" && "$(readlink "$sandbox/home/.config/nushell/completions")" == "$completions_source" ]] || {
  printf 'FAIL: Linux completions should link to the OSS Nushell completions\n' >&2
  exit 1
}

printf 'PASS: Linux Nushell Stow tests\n'
