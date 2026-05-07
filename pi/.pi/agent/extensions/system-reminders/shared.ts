import * as path from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export interface ReminderEmitter {
  tick(): void;
  remind(key: string, message: string, cooldownEvents?: number): void;
}

export function createReminderEmitter(pi: ExtensionAPI): ReminderEmitter {
  let eventTick = 0;
  const lastReminderTick = new Map<string, number>();

  return {
    tick() {
      eventTick++;
    },

    remind(key: string, message: string, cooldownEvents = 0) {
      if (!message) return;

      const lastTick = lastReminderTick.get(key) ?? -Infinity;
      if (eventTick - lastTick < cooldownEvents) return;
      lastReminderTick.set(key, eventTick);

      pi.sendMessage(
        {
          customType: "system-reminder",
          content: message,
          display: true,
          details: { key },
        },
        { deliverAs: "steer" },
      );
    },
  };
}

export function contentText(content: unknown): string {
  if (Array.isArray(content)) {
    return content
      .map((item) => {
        if (typeof item === "string") return item;
        if (item && typeof item === "object" && "text" in item) {
          return String((item as { text?: unknown }).text ?? "");
        }
        return "";
      })
      .join("\n");
  }
  return String(content ?? "");
}

export function messageText(message: any): string {
  return contentText(message?.content ?? message?.message?.content ?? message?.data?.content ?? "");
}

export function commandFromEvent(event: any): string {
  return String(event?.input?.command ?? event?.args?.command ?? event?.input?.cmd ?? event?.args?.cmd ?? "");
}

export function isShellTool(toolName: string): boolean {
  return toolName === "bash" || toolName === "zone_exec" || toolName.endsWith(".bash") || toolName.endsWith(".zone_exec");
}

export function toolNameMatches(toolName: string, name: string): boolean {
  return toolName === name || toolName.endsWith(`.${name}`);
}

export function normalizeFilePath(filePath: unknown, cwd?: string): string | undefined {
  if (typeof filePath !== "string" || filePath.length === 0) return undefined;
  return path.normalize(path.isAbsolute(filePath) ? filePath : path.resolve(cwd ?? process.cwd(), filePath));
}

export function editInputPaths(input: any): string[] {
  const paths: string[] = [];

  if (typeof input?.path === "string") paths.push(input.path);

  if (Array.isArray(input?.multi)) {
    for (const item of input.multi) {
      const itemPath = typeof item?.path === "string" ? item.path : input?.path;
      if (typeof itemPath === "string") paths.push(itemPath);
    }
  }

  return [...new Set(paths)];
}
