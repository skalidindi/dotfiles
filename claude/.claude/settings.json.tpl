{
  "apiKeyHelper": "echo sk-1234",
  "enabledPlugins": {
    "context7@claude-plugins-official": true,
    "hawkins-professional@js-platform-claude-code": true,
    "hookify@claude-plugins-official": true,
    "jetpack-plugin@js-platform-claude-code": true,
    "pr-review-toolkit@claude-plugins-official": true,
    "superpowers@claude-plugins-official": true
  },
  "env": {
    "ANTHROPIC_BASE_URL": "http://claudecode.local.dev.netflix.net:9123/",
    "CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY": "1",
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "DISABLE_AUTOUPDATER": "1",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://claudemetricscollector.cluster.us-east-1.prod.cloud.netflix.net:4318",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "grpc",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORT_INTERVAL": "5000",
    "OTEL_LOG_TOOL_DETAILS": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_METRIC_EXPORT_INTERVAL": "10000",
    "OTEL_RESOURCE_ATTRIBUTES": "user.netflix_email=skalidindi@netflix.com,runtime_environment=local"
  },
  "extraKnownMarketplaces": {
    "js-platform-claude-code": {
      "source": {
        "source": "git",
        "url": "https://git.netflix.net/corp/js-platform-claude-code.git"
      }
    }
  },
  "hooks": {
    "PreToolUse": [
      {
        "hooks": [
          {
            "command": "$HOME/.local/share/agent-dangerous-command-guard/dangerous-command-guard.py",
            "type": "command"
          }
        ],
        "matcher": "Bash"
      },
      {
        "hooks": [
          {
            "command": "$HOME/.local/share/agent-uv-enforcer/uv-hook.py",
            "type": "command"
          }
        ],
        "matcher": "Bash"
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "command": "[ -n \"$SUPERSET_HOME_DIR\" ] && [ -x \"$SUPERSET_HOME_DIR/hooks/notify.sh\" ] && \"$SUPERSET_HOME_DIR/hooks/notify.sh\" || true",
            "type": "command"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "command": "[ -n \"$SUPERSET_HOME_DIR\" ] && [ -x \"$SUPERSET_HOME_DIR/hooks/notify.sh\" ] && \"$SUPERSET_HOME_DIR/hooks/notify.sh\" || true",
            "type": "command"
          }
        ]
      }
    ]
  },
  "includeCoAuthoredBy": false,
  "model": "opus[1m]",
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test:*)",
      "Read(~/.zshrc)"
    ],
    "deny": [
      "Read(/Users/skalidindi/.claude/google_credentials.json)",
      "Read(/Users/skalidindi/.cursor/google_credentials.json)",
      "Read(~/.slack_secret_xoxp)",
      "Read(~/.slack_secret_xoxb)",
      "Read(~/.slack_secret_xapp)"
    ]
  },
  "preferredNotifChannel": "terminal_bell",
  "skipDangerousModePermissionPrompt": true
}
