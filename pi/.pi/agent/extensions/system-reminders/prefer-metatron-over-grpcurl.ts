import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { commandFromEvent, isShellTool, type ReminderEmitter } from "./shared.js";

const GRPCURL_COMMAND = /(?:^|\n|[;|&]{1,2})\s*grpcurl\b/m;

export function registerPreferMetatronOverGrpcurl(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  pi.on("tool_call", async (event) => {
    const toolName = String(event.toolName ?? "");
    if (!isShellTool(toolName)) return;

    const command = commandFromEvent(event);
    if (!GRPCURL_COMMAND.test(command)) return;

    reminders.remind(
      "prefer-metatron-over-grpcurl",
      `You are trying to call \`grpcurl\` directly from a shell tool call.

Prefer the \`metatron\` CLI tool instead so requests use the right Netflix identity, certificates, and service routing.

If this is a JSON-gRPC/SBN service call, use a pattern like:

\`\`\`bash
metatron curl -a <service> -X POST \\
  https://<service>.cluster.<region>.test.cloud.netflix.net:7004/<proto.package.Service>/<Method> \\
  -H 'Content-Type: application/json+grpc' \\
  -d @request.json
\`\`\`

Original attempted command:

\`\`\`bash
${command}
\`\`\``,
      3,
    );
  });
}
