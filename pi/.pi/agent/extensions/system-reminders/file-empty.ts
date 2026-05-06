import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { contentText, type ReminderEmitter } from "./shared.js";

export function registerFileEmpty(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  pi.on("tool_result", async (event) => {
    if (event.toolName !== "read" || event.isError) return;

    const text = contentText(event.content);
    if (text.trim() !== "") return;

    reminders.remind(
      "file-empty",
      `Warning: the file ${(event.input as any)?.path || "unknown"} exists but the contents are empty.`,
    );
  });
}
