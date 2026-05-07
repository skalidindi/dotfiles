import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { editInputPaths, normalizeFilePath, type ReminderEmitter } from "./shared.js";

export function registerReadBeforeEdit(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  const readFiles = new Set<string>();

  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName === "read" && !event.isError) {
      const filePath = normalizeFilePath((event.input as any)?.path, ctx.cwd);
      if (filePath) readFiles.add(filePath);
      return;
    }

    if (event.toolName !== "edit" || event.isError) return;

    for (const originalPath of editInputPaths(event.input)) {
      const filePath = normalizeFilePath(originalPath, ctx.cwd);
      if (filePath && !readFiles.has(filePath)) {
        reminders.remind(
          `read-before-edit:${filePath}`,
          `You edited ${originalPath} without reading it first. Always read files before editing to avoid stale oldText.`,
        );
        break;
      }
    }
  });
}
