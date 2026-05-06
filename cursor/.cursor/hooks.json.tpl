{
  "version": 1,
  "hooks": {
    "beforeSubmitPrompt": [
      {
        "command": "[ -x \"$HOME/.superset/hooks/cursor-hook.sh\" ] && \"$HOME/.superset/hooks/cursor-hook.sh\" Start || true"
      }
    ],
    "stop": [
      {
        "command": "[ -x \"$HOME/.superset/hooks/cursor-hook.sh\" ] && \"$HOME/.superset/hooks/cursor-hook.sh\" Stop || true"
      }
    ],
    "beforeShellExecution": [
      {
        "command": "[ -x \"$HOME/.superset/hooks/cursor-hook.sh\" ] && \"$HOME/.superset/hooks/cursor-hook.sh\" PermissionRequest || true"
      }
    ],
    "beforeMCPExecution": [
      {
        "command": "[ -x \"$HOME/.superset/hooks/cursor-hook.sh\" ] && \"$HOME/.superset/hooks/cursor-hook.sh\" PermissionRequest || true"
      }
    ]
  }
}
