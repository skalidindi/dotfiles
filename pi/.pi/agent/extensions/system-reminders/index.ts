import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { registerBashSpiral } from "./bash-spiral.js";
import { registerFileChurn } from "./file-churn.js";
import { registerFileEmpty } from "./file-empty.js";
import { registerFileTruncated } from "./file-truncated.js";
import { registerNetflixSbnUrl } from "./netflix-sbn-url.js";
import { registerPreferEdit } from "./prefer-edit.js";
import { registerPreferMetatronOverGrpcurl } from "./prefer-metatron-over-grpcurl.js";
import { registerReadBeforeEdit } from "./read-before-edit.js";
import { registerSessionResumed } from "./session-resumed.js";
import { createReminderEmitter } from "./shared.js";
import { registerZoneExecApprovalDiscipline } from "./zone-exec-approval-discipline.js";

export default function (pi: ExtensionAPI) {
  const reminders = createReminderEmitter(pi);

  // One monotonic event clock shared by cooldown logic.
  pi.on("session_start", () => reminders.tick());
  pi.on("tool_call", () => reminders.tick());
  pi.on("tool_result", () => reminders.tick());
  pi.on("message_end", () => reminders.tick());

  registerBashSpiral(pi, reminders);
  registerFileChurn(pi, reminders);
  registerFileEmpty(pi, reminders);
  registerFileTruncated(pi, reminders);
  registerNetflixSbnUrl(pi, reminders);
  registerPreferEdit(pi, reminders);
  registerPreferMetatronOverGrpcurl(pi, reminders);
  registerReadBeforeEdit(pi, reminders);
  registerSessionResumed(pi, reminders);
  registerZoneExecApprovalDiscipline(pi, reminders);
}
