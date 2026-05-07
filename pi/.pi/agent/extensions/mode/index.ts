import { existsSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { basename, join } from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

type ModeState = {
  activeMode?: string;
};

const AGENT_DIR = process.env.PI_CODING_AGENT_DIR || join(homedir(), ".pi", "agent");
const SHARED_MODE_DIR = join(homedir(), ".agents", "modes");
const PI_MODE_DIR = join(AGENT_DIR, "modes");
const STATE_PATH = join(AGENT_DIR, "mode-state.json");

function modeDir(): string {
  return existsSync(SHARED_MODE_DIR) ? SHARED_MODE_DIR : PI_MODE_DIR;
}

function modePath(mode: string): string {
  return join(modeDir(), `${mode}.md`);
}

function listModes(): string[] {
  const dir = modeDir();
  if (!existsSync(dir)) return [];

  return readdirSync(dir)
    .filter((file) => file.endsWith(".md"))
    .map((file) => basename(file, ".md"))
    .sort();
}

function readMode(mode: string): string | undefined {
  const path = modePath(mode);
  if (!existsSync(path)) return undefined;
  return readFileSync(path, "utf8").trim();
}

function readState(): ModeState {
  if (!existsSync(STATE_PATH)) return {};

  try {
    return JSON.parse(readFileSync(STATE_PATH, "utf8")) as ModeState;
  } catch {
    return {};
  }
}

function writeState(state: ModeState): void {
  mkdirSync(AGENT_DIR, { recursive: true });
  writeFileSync(STATE_PATH, `${JSON.stringify(state, null, 2)}\n`, "utf8");
}

function clearState(): void {
  if (existsSync(STATE_PATH)) rmSync(STATE_PATH);
}

function modeSystemPrompt(mode: string, content: string): string {
  return `<agent-mode name="${mode}">
${content}
</agent-mode>`;
}

export default function modeExtension(pi: ExtensionAPI) {
  pi.registerCommand("mode", {
    description: "Switch workflow mode. Usage: /mode [pair|auto|off]",
    handler: async (args, ctx) => {
      const requested = args.trim();

      if (!requested) {
        const active = readState().activeMode || "off";
        const modes = listModes();
        ctx.ui.notify(`Active mode: ${active}. Available: ${modes.join(", ") || "none"}`, "info");
        return;
      }

      if (requested === "off" || requested === "none") {
        clearState();
        pi.sendMessage(
          {
            customType: "agent-mode",
            content: "Agent mode disabled. Continue with the normal base instructions.",
            display: true,
            details: { mode: "off" },
          },
          { deliverAs: "steer" },
        );
        return;
      }

      const content = readMode(requested);
      if (!content) {
        ctx.ui.notify(`Unknown mode: ${requested}. Available: ${listModes().join(", ") || "none"}`, "error");
        return;
      }

      writeState({ activeMode: requested });
      pi.sendMessage(
        {
          customType: "agent-mode",
          content: modeSystemPrompt(requested, content),
          display: true,
          details: { mode: requested },
        },
        { deliverAs: "steer" },
      );
      ctx.ui.notify(`Mode set to ${requested}`, "info");
    },
  });

  pi.on("before_agent_start", async (event) => {
    const activeMode = readState().activeMode;
    if (!activeMode) return;

    const content = readMode(activeMode);
    if (!content) return;

    return {
      systemPrompt: `${event.systemPrompt}\n\n${modeSystemPrompt(activeMode, content)}`,
    };
  });
}
