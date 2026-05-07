import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import {
  commandFromEvent,
  contentText,
  messageText,
  toolNameMatches,
  type ReminderEmitter,
} from "./shared.js";

const RECENT_PENDING_MS = 15 * 60 * 1000;
const RECENT_SUSPICIOUS_CANCEL_MS = 2 * 60 * 1000;

interface PendingRequest {
  command: string;
  createdAt: number;
  cancellationAllowed: boolean;
}

function requestIdFromQueuedResult(event: any, text: string): string | undefined {
  return event?.details?.requestId ?? text.match(/Queued \(id: ([a-f0-9-]+)\)/i)?.[1];
}

function requestIdFromZoneExecResult(text: string): string | undefined {
  return text.match(/Zone execution result \(id: ([a-f0-9-]+)\):/i)?.[1];
}

function queuedResultSuggestsCancellation(text: string): boolean {
  return /Consider cancelling this request and retrying with a simple command\./i.test(text);
}

function pruneOldPending(pending: Map<string, PendingRequest>): void {
  const now = Date.now();
  for (const [id, request] of pending) {
    if (now - request.createdAt > RECENT_PENDING_MS) pending.delete(id);
  }
}

function pendingSummary(pending: Map<string, PendingRequest>): string {
  return [...pending.entries()]
    .slice(0, 3)
    .map(([id, request]) => `- ${id}: ${request.command || "<unknown command>"}`)
    .join("\n");
}

export function registerZoneExecApprovalDiscipline(pi: ExtensionAPI, reminders: ReminderEmitter): void {
  const pending = new Map<string, PendingRequest>();
  let queuedReminderShown = false;
  let lastSuspiciousCancelAt = -Infinity;

  pi.on("tool_result", async (event) => {
    const toolName = String(event.toolName ?? "");
    const text = contentText(event.content);
    pruneOldPending(pending);

    if (toolNameMatches(toolName, "zone_exec") && !event.isError) {
      const requestId = requestIdFromQueuedResult(event, text);
      if (!requestId) return;

      const command = commandFromEvent(event);
      const cancellationAllowed = queuedResultSuggestsCancellation(text);
      pending.set(requestId, {
        command,
        createdAt: Date.now(),
        cancellationAllowed,
      });

      if (cancellationAllowed) return;

      const afterSuspiciousCancel = Date.now() - lastSuspiciousCancelAt < RECENT_SUSPICIOUS_CANCEL_MS;
      if (queuedReminderShown && !afterSuspiciousCancel) return;

      queuedReminderShown = true;
      reminders.remind(
        "zone-exec-pending",
        `zone_exec request ${requestId} is pending human approval. Do not cancel it merely because it is taking time or because you want to poll for status. Cancel only if the request is wrong, obsolete, duplicate, or the user explicitly asks. Otherwise continue unrelated local work, or stop issuing tools and wait for the zone_exec_result notification.

Pending request:
- ${requestId}: ${command || "<unknown command>"}`,
      );
      return;
    }

    if (toolNameMatches(toolName, "zone_exec_cancel")) {
      const inputId = (event.input as any)?.id ?? (event as any)?.args?.id;
      const cancelledId = text.match(/Cancelled request ([a-f0-9-]+)/i)?.[1];
      const notFoundId = text.match(/Request ([a-f0-9-]+) not found or already resolved/i)?.[1];
      const targetId = String(inputId ?? cancelledId ?? notFoundId ?? "");
      const target = targetId ? pending.get(targetId) : undefined;

      if (/No pending requests\./i.test(text)) {
        pending.clear();
        return;
      }

      if (cancelledId) pending.delete(cancelledId);
      if (notFoundId) pending.delete(notFoundId);
      if (target?.cancellationAllowed) return;

      const actualCancellation = Boolean(cancelledId || inputId);
      if (!actualCancellation) return;

      lastSuspiciousCancelAt = Date.now();
      const summary = pending.size > 0 ? `\n\nRecent pending requests still known:\n${pendingSummary(pending)}` : "";
      reminders.remind(
        "zone-exec-cancel-discipline",
        `You used zone_exec_cancel while approval requests may still be pending. Do not cancel human approval requests just because they are taking time. Cancellation is appropriate only when the request is wrong, obsolete, duplicate, or the user explicitly asked. If you are waiting for approval, stop issuing tools and wait for the zone_exec_result notification. Do not submit duplicate zone_exec requests just because a request is still pending.${summary}`,
      );
    }
  });

  pi.on("message_end", async (event) => {
    const resolvedId = requestIdFromZoneExecResult(messageText(event.message));
    if (resolvedId) pending.delete(resolvedId);
  });
}
