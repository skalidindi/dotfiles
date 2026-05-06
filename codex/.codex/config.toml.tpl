model = "gpt-5.5"
model_auto_compact_token_limit = 945000
model_catalog_json = "~/.codex/model-catalog.json"
model_context_window = 1050000
model_provider = "openai-chat-completions"
model_reasoning_effort = "xhigh"
personality = "pragmatic"
tool_output_token_limit = 128000

[features]
codex_hooks = true
external_migration = true
memories = true
prevent_idle_sleep = true

[marketplaces.claude-plugins-official]
source_type = "git"
source = "https://github.com/anthropics/claude-plugins-official.git"

[marketplaces.js-platform-claude-code]
source_type = "git"
source = "https://git.netflix.net/corp/js-platform-claude-code.git"

[mcp_servers.gen-ai-tool-registry]
args = ["nflx-genai-tool-registry@latest"]
command = "uvx"

[mcp_servers.gen-ai-tool-registry.env]
REGISTRY_ENV = "prod"
REGISTRY_TOOLBOX_ID = "core_tools"
REGISTRY_URL_OVERRIDE = "mesh"

[mcp_servers.nflx-docs-manuals]
args = ["mcp-nflx-manuals@latest"]
command = "uvx"

[model_providers.openai-chat-completions]
base_url = "http://mgp.local.dev.netflix.net:9123/proxy/clineskalidindi/v1"
env_key = "OPENAI_API_KEY"
name = "Netflix Model Gateway"
wire_api = "responses"

[plugins."context7@claude-plugins-official"]
enabled = true

[plugins."hookify@claude-plugins-official"]
enabled = true

[plugins."pr-review-toolkit@claude-plugins-official"]
enabled = true

[plugins."superpowers@claude-plugins-official"]
enabled = true

[plugins."hawkins-professional@js-platform-claude-code"]
enabled = true

[plugins."jetpack-plugin@js-platform-claude-code"]
enabled = true

[shell_environment_policy]
inherit = "core"

[shell_environment_policy.set]
ANTHROPIC_BASE_URL = "http://claudecode.local.dev.netflix.net:9123/"
CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1"
CLAUDE_CODE_ENABLE_TELEMETRY = "1"
DISABLE_AUTOUPDATER = "1"
OTEL_EXPORTER_OTLP_ENDPOINT = "http://claudemetricscollector.cluster.us-east-1.prod.cloud.netflix.net:4318"
OTEL_EXPORTER_OTLP_PROTOCOL = "grpc"
OTEL_LOGS_EXPORT_INTERVAL = "5000"
OTEL_METRICS_EXPORTER = "otlp"
OTEL_METRIC_EXPORT_INTERVAL = "10000"
OTEL_RESOURCE_ATTRIBUTES = "user.netflix_email=skalidindi@netflix.com,runtime_environment=local"
