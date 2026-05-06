{
  "mcpServers": {
    "gen-ai-tool-registry": {
      "transport": "stdio",
      "command": "uvx",
      "args": [
        "nflx-genai-tool-registry@latest"
      ],
      "env": {
        "REGISTRY_ENV": "prod",
        "REGISTRY_TOOLBOX_ID": "core_tools",
        "REGISTRY_URL_OVERRIDE": "mesh"
      },
      "timeoutMs": 600000
    },
    "nflx-docs-manuals": {
      "transport": "stdio",
      "command": "uvx",
      "args": [
        "mcp-nflx-manuals@latest"
      ],
      "timeoutMs": 600000
    }
  }
}
