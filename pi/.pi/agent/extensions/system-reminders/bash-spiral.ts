import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { ReminderEmitter } from "./shared.js";

export function registerBashSpiral(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  let consecutiveFailures = 0;

  pi.on("tool_result", async (event) => {
    if (event.toolName !== "bash") return;

    consecutiveFailures = event.isError ? consecutiveFailures + 1 : 0;
    if (consecutiveFailures < 3) return;

    reminders.remind(
      "bash-spiral",
      "3 consecutive bash failures. Stop, re-read the error messages, and rethink your approach.",
      10,
    );
  });
}
