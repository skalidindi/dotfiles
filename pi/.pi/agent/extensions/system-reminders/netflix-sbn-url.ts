import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { commandFromEvent, isShellTool, type ReminderEmitter } from "./shared.js";

const VIP_TEST_URL =
  /https?:\/\/([a-zA-Z0-9-]+)\.vip\.([a-zA-Z0-9-]+)\.test\.cloud\.netflix\.net(?::\d+)?(\/[^\s"'<>]*)?/;

function normalizeTranscoderPath(requestPath: string | undefined): string {
  if (!requestPath || requestPath === "/" || requestPath === "/healthcheck") {
    return "/<proto.package.Service>/<Method>";
  }

  return requestPath.replace(/^\/grpc\//, "/");
}

export function registerNetflixSbnUrl(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  pi.on("tool_call", async (event) => {
    const toolName = String(event.toolName ?? "");
    if (!isShellTool(toolName)) return;

    const command = commandFromEvent(event);
    const match = command.match(VIP_TEST_URL);
    if (!match) return;

    const service = match[1];
    const region = match[2];
    const requestPath = normalizeTranscoderPath(match[3]);
    const suggestion = [
      `metatron curl -a ${service} -X POST \\`,
      `  https://${service}.cluster.${region}.test.cloud.netflix.net:7004${requestPath} \\`,
      "  -H 'Content-Type: application/json+grpc' \\",
      "  -d @request.json",
    ].join("\n");

    reminders.remind(
      "netflix-sbn-url",
      `You are trying to call a Netflix test service via a direct VIP URL from a developer machine.

Do not use:
- https://SERVICE.vip.REGION.test.cloud.netflix.net:8443/...
- https://SERVICE.vip.REGION.test.cloud.netflix.net:7004/...
- https://SERVICE.test.netflix.net:7004/...
- /grpc/... paths
- Content-Type: application/json for JSON-gRPC transcoder calls

Use the developer-machine SBN/mesh JSON-gRPC pattern instead:

\`\`\`bash
${suggestion}
\`\`\`

Rules of thumb:
- Host: SERVICE.cluster.REGION.test.cloud.netflix.net
- Port for metatron curl/API calls: 7004
- Path: /<proto.package.Service>/<Method>
- Content-Type: application/json+grpc
- Use \`metatron curl -a SERVICE\`
- For Swagger/browser UI, use HTTPS 443 without metatron curl, e.g.:
  https://SERVICE.cluster.REGION.test.cloud.netflix.net/swagger-ui/index.html

Original attempted command:

\`\`\`bash
${command}
\`\`\``,
      3,
    );
  });
}
