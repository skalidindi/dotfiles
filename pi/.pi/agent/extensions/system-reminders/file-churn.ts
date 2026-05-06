import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { editInputPaths, normalizeFilePath, type ReminderEmitter } from "./shared.js";

export function registerFileChurn(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  const editCounts = new Map<string, number>();

  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName !== "edit" || event.isError) return;

    for (const originalPath of editInputPaths(event.input)) {
      const filePath = normalizeFilePath(originalPath, ctx.cwd);
      if (!filePath) continue;

      const count = (editCounts.get(filePath) ?? 0) + 1;
      editCounts.set(filePath, count);

      if (count >= 5) {
        reminders.remind(
          `file-churn:${filePath}`,
          `You've edited ${originalPath} ${count} times. Step back and consider a different approach.`,
          10,
        );
      }
    }
  });
}
