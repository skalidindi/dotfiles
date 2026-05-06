import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { ReminderEmitter } from "./shared.js";

export function registerPreferEdit(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  let writesSinceReminder = 0;

  pi.on("tool_result", async (event) => {
    if (event.toolName !== "write" || event.isError) return;

    writesSinceReminder++;
    if (writesSinceReminder < 3) return;

    writesSinceReminder = 0;
    reminders.remind(
      "prefer-edit",
      "You've used write 3 times since the last reminder. Prefer edit for surgical changes to existing files.",
    );
  });
}
