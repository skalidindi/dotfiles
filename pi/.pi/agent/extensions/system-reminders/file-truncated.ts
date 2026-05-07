import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { ReminderEmitter } from "./shared.js";

export function registerFileTruncated(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  pi.on("tool_result", async (event) => {
    if (event.toolName !== "read" || event.isError) return;
    if (!(event as any).details?.truncation?.truncated) return;

    reminders.remind(
      "file-truncated",
      `Note: ${(event.input as any)?.path || "unknown"} was too large and has been truncated. Use the read tool with offset to read more of the file if you need.`,
    );
  });
}
