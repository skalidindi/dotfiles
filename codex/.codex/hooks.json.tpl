{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.local/share/agent-uv-enforcer/uv-hook.py"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "[ -x \"$HOME/.superset/hooks/notify.sh\" ] && \"$HOME/.superset/hooks/notify.sh\" || true"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "[ -x \"$HOME/.superset/hooks/notify.sh\" ] && \"$HOME/.superset/hooks/notify.sh\" || true"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "[ -x \"$HOME/.superset/hooks/notify.sh\" ] && \"$HOME/.superset/hooks/notify.sh\" || true"
          }
        ]
      }
    ]
  }
}
