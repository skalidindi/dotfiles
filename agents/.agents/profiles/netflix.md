# Netflix Agent Profile

Netflix-specific layer applied on top of `core`.

## Keep Enabled

- GitHub Enterprise support for `github.netflix.net` / `git.netflix.net`.
- Netflix docs and code search:
  - NECP for platform questions;
  - Manuals and Slack retrieval for source-backed internal docs;
  - Sourcegraph for cross-repo code search.
- Engineering operations:
  - Jira;
  - Metrics, Radar/logs, tracing, and observability;
  - Metatron, security, Wall-E, Mesh, Swagger, and service access guidance.
- UI platform helpers when working in the matching repos:
  - Jetpack;
  - Hawkins Professional;
  - JavaScript client context;
  - Java/Python project context.

## Keep Scoped

- MCP servers should be configured once per agent from a shared inventory, but
  endpoint ids, auth state, and volatile gateway URLs are machine-local unless
  they are intentionally stable.
- Netflix-specific skills should prefer live docs, local repo files, or MCP
  source-of-truth lookups over model memory.
- High-privilege or write-capable internal tools should be opt-in by task, not
  part of the always-loaded core.
