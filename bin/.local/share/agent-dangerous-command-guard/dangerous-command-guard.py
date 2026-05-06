#!/usr/bin/env python3
"""PreToolUse hook: block dangerous shell commands with a clear reason."""

from __future__ import annotations

import json
import os
import re
import sys
from typing import Any


DANGEROUS_PATTERNS: list[tuple[re.Pattern[str], str]] = [
    (re.compile(r"\brm\s+.*-[^\s]*r[^\s]*f"), "rm with recursive force delete"),
    (re.compile(r"\brm\s+.*-[^\s]*f[^\s]*r"), "rm with recursive force delete"),
    (re.compile(r"\brm\s+-r\b"), "rm recursive delete"),
    (re.compile(r"\brm\s+(?!.*\.)(/|\s+~/?(\s|$))"), "rm on root or home"),
    (re.compile(r"\bgit\s+reset\s+--hard\b"), "git reset --hard"),
    (re.compile(r"\bgit\s+push\s+.*--force\b"), "git push --force"),
    (re.compile(r"\bgit\s+push\s+.*-f\b"), "git push -f"),
    (re.compile(r"\bgit\s+clean\s+.*-f"), "git clean -f"),
    (re.compile(r"\bgit\s+checkout\s+\.\s*$"), "git checkout ."),
    (re.compile(r"\bgit\s+restore\s+\.\s*$"), "git restore ."),
    (re.compile(r"\bgit\s+branch\s+.*-D\b"), "git branch -D"),
    (re.compile(r"\bdd\s+.*if="), "dd raw disk operation"),
    (re.compile(r"\bmkfs\b"), "mkfs format filesystem"),
    (re.compile(r"\bfdisk\b"), "fdisk partition editor"),
    (re.compile(r"\bparted\b"), "parted partition editor"),
    (re.compile(r"\bchmod\s+.*-R\s+777\b"), "chmod -R 777"),
    (re.compile(r"\bchown\s+.*-R\s+.*\s+/(etc|usr|bin|sbin|lib|var)\b"), "chown -R on system path"),
]


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
        ("tool_input", "command"),
        ("tool_input", "cmd"),
        ("toolInput", "command"),
        ("toolInput", "cmd"),
        ("input", "command"),
        ("input", "cmd"),
        ("arguments", "command"),
        ("arguments", "cmd"),
        ("command",),
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


def split_commands(command: str) -> list[str]:
    segments: list[str] = []
    current: list[str] = []
    in_single_quote = False
    in_double_quote = False
    i = 0

    while i < len(command):
        ch = command[i]

        if ch == "'" and not in_double_quote:
            in_single_quote = not in_single_quote
            current.append(ch)
            i += 1
            continue
        if ch == '"' and not in_single_quote:
            in_double_quote = not in_double_quote
            current.append(ch)
            i += 1
            continue

        if in_single_quote or in_double_quote:
            current.append(ch)
            i += 1
            continue

        if ch == ";" or ch == "|":
            segments.append("".join(current))
            current = []
            if ch == "|" and i + 1 < len(command) and command[i + 1] == "|":
                i += 1
            i += 1
            continue
        if ch == "&" and i + 1 < len(command) and command[i + 1] == "&":
            segments.append("".join(current))
            current = []
            i += 2
            continue

        current.append(ch)
        i += 1

    if current:
        segments.append("".join(current))

    return [segment.strip() for segment in segments if segment.strip()]


def strip_quoted_content(segment: str) -> str:
    segment = re.sub(
        r"<<-?\s*['\"]?(\w+)['\"]?.*?\n.*?\1",
        lambda match: f"<<{match.group(1)}",
        segment,
        flags=re.DOTALL,
    )
    result: list[str] = []
    i = 0
    while i < len(segment):
        ch = segment[i]
        if ch == "$" and i + 1 < len(segment) and segment[i + 1] == "'":
            i += 2
            while i < len(segment) and segment[i] != "'":
                i += 2 if segment[i] == "\\" and i + 1 < len(segment) else 1
            i += 1
            continue
        if ch == "'":
            i += 1
            while i < len(segment) and segment[i] != "'":
                i += 1
            i += 1
            continue
        if ch == '"':
            i += 1
            while i < len(segment) and segment[i] != '"':
                i += 2 if segment[i] == "\\" and i + 1 < len(segment) else 1
            i += 1
            continue
        result.append(ch)
        i += 1
    return "".join(result)


def dangerous_reason(command: str) -> str | None:
    for segment in split_commands(command):
        stripped = strip_quoted_content(segment)
        for pattern, description in DANGEROUS_PATTERNS:
            if pattern.search(stripped):
                return description
    return None


def main() -> int:
    if os.environ.get("AGENT_DANGEROUS_COMMAND_ALLOW") == "1":
        return 0

    command = command_from_hook_input(sys.stdin.read())
    reason = dangerous_reason(command)
    if not reason:
        return 0

    message = (
        f"Dangerous command blocked: {reason}.\n\n"
        "Ask the user for an explicit safer path, or rerun only after setting "
        "AGENT_DANGEROUS_COMMAND_ALLOW=1 with a clear user-approved reason."
    )
    payload = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": message,
        },
        "permissionDecision": "deny",
        "permissionDecisionReason": message,
        "decision": "block",
        "reason": message,
    }
    print(json.dumps(payload))
    print(message, file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
