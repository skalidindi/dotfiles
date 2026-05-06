import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { ReminderEmitter } from "./shared.js";

export function registerSessionResumed(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  pi.on("session_start", async (event) => {
    if (event.reason !== "resume") return;

    reminders.remind(
      "session-resumed",
      "This session is being resumed. Application state may have changed since last time. Re-read relevant files before making assumptions about current state.",
    );
  });
}
