#!/usr/bin/env python3
"""Claude/Codex PreToolUse hook: block direct python/pip/poetry and point agents at uv."""

from __future__ import annotations

import json
import re
import sys
from typing import Any

SEGMENT = r"(?:^|\n|[;|&]{1,2})\s*(?:(?:command|exec)\s+)?(?:env\s+(?:\S+=\S+\s+)*)?"
PIP = re.compile(rf"{SEGMENT}(?:\S+/)?pip(?:3(?:\.\d+)?)?\b")
POETRY = re.compile(rf"{SEGMENT}(?:\S+/)?poetry\b")
PYTHON = re.compile(rf"{SEGMENT}(?:\S+/)?python(?:3(?:\.\d+)?)?\b")

MESSAGE = """Use uv instead of direct python/pip/poetry commands.

Examples:
  uv run python script.py
  uv run python -c 'print("hello")'
  uv run --with PACKAGE python script.py
  uv add PACKAGE
  uv add --dev PACKAGE
  uv sync
  uv venv

If pip semantics are truly required, use uv pip ... instead of pip directly."""


def get(obj: Any, *path: str) -> Any:
    for key in path:
        if not isinstance(obj, dict):
            return None
        obj = obj.get(key)
    return obj


def command_from_hook_input(raw: str) -> str:
    try:
        data = json.loads(raw or "{}")
    except json.JSONDecodeError:
        return raw

    for path in (
        ("tool_input", "command"),  # Claude
        ("tool_input", "cmd"),
        ("toolInput", "command"),
        ("toolInput", "cmd"),
        ("input", "command"),
        ("input", "cmd"),
        ("arguments", "command"),
        ("arguments", "cmd"),
        ("command",),  # Codex variants
        ("cmd",),
    ):
        value = get(data, *path)
        if isinstance(value, str):
            return value
        if isinstance(value, list):
            values = [str(v) for v in value]
            for i, item in enumerate(values[:-1]):
                if item in {"-c", "-lc"}:
                    return values[i + 1]
            return " ".join(values)
    return ""


def blocked(command: str) -> bool:
    return bool(PIP.search(command) or POETRY.search(command) or PYTHON.search(command))


def main() -> int:
    command = command_from_hook_input(sys.stdin.read())
    if not blocked(command):
        return 0

    payload = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": MESSAGE,
        },
        # Codex also treats exit code 2/stderr as a block; these fields are for
        # hook runtimes that read JSON output.
        "permissionDecision": "deny",
        "permissionDecisionReason": MESSAGE,
        "decision": "block",
        "reason": MESSAGE,
    }
    print(json.dumps(payload))
    print(MESSAGE, file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
