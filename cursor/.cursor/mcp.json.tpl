{
  "mcpServers": {
    "gen-ai-tool-registry": {
      "command": "uvx",
      "args": [
        "nflx-genai-tool-registry@latest"
      ],
      "env": {
        "REGISTRY_ENV": "prod",
        "REGISTRY_TOOLBOX_ID": "core_tools",
        "REGISTRY_URL_OVERRIDE": "mesh"
      }
    },
    "nflx-docs-manuals": {
      "command": "uvx",
      "args": [
        "mcp-nflx-manuals@latest"
      ]
    }
  }
}
