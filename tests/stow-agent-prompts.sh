#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
installer="$root_dir/installers/010-stow.sh"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-agent-prompts-stow.XXXXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

mkdir -p "$sandbox/home"
stow --dir="$root_dir" --target="$sandbox/home" --restow --no-folding agents

for prompt in base.md pull-request.md; do
  target="$sandbox/home/.agents/prompts/$prompt"
  source="$root_dir/agents/.agents/prompts/$prompt"

  [[ -L "$target" ]] || {
    printf 'FAIL: expected Stow symlink: %s\n' "$target" >&2
    exit 1
  }
  [[ "$(realpath "$target")" == "$source" ]] || {
    printf 'FAIL: prompt symlink should resolve to %s\n' "$source" >&2
    exit 1
  }
done

transition="$sandbox/transition"
work_prompt="$transition/work/stow/agents/.agents/prompts/pull-request.md"
mkdir -p "$transition/home/.agents/prompts" "$(dirname "$work_prompt")"
cp "$root_dir/agents/.agents/prompts/pull-request.md" "$work_prompt"
ln -s "$work_prompt" "$transition/home/.agents/prompts/pull-request.md"

HOME="$transition/home" bash "$installer" >/dev/null

target="$transition/home/.agents/prompts/pull-request.md"
source="$root_dir/agents/.agents/prompts/pull-request.md"
[[ "$(realpath "$target")" == "$source" ]] || {
  printf 'FAIL: OSS Stow should take ownership from the matching Work fallback\n' >&2
  exit 1
}

divergent="$sandbox/divergent"
work_prompt="$divergent/work/stow/agents/.agents/prompts/pull-request.md"
mkdir -p "$divergent/home/.agents/prompts" "$(dirname "$work_prompt")"
printf 'locally changed prompt\n' > "$work_prompt"
ln -s "$work_prompt" "$divergent/home/.agents/prompts/pull-request.md"

if HOME="$divergent/home" bash "$installer" >/dev/null 2>&1; then
  printf 'FAIL: OSS Stow should not replace a divergent Work fallback\n' >&2
  exit 1
fi
[[ "$(realpath "$divergent/home/.agents/prompts/pull-request.md")" == "$(realpath "$work_prompt")" ]] || {
  printf 'FAIL: divergent Work fallback should be preserved\n' >&2
  exit 1
}

printf 'PASS: agent prompt Stow tests\n'
