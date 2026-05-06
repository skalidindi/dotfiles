import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const SEGMENT = String.raw`(?:^|\n|[;|&]{1,2})\s*`;

const DANGEROUS_PATTERNS: Array<[RegExp, string]> = [
  [new RegExp(`${SEGMENT}(?:\\S+/)?rm\\s+.*-[^\\s]*r[^\\s]*f`, "m"), "rm with recursive force delete"],
  [new RegExp(`${SEGMENT}(?:\\S+/)?rm\\s+.*-[^\\s]*f[^\\s]*r`, "m"), "rm with recursive force delete"],
  [new RegExp(`${SEGMENT}(?:\\S+/)?rm\\s+-r\\b`, "m"), "rm recursive delete"],
  [new RegExp(`${SEGMENT}(?:\\S+/)?rm\\s+(?!.*\\.)(/|~/?(?:\\s|$))`, "m"), "rm on root or home"],
  [new RegExp(`${SEGMENT}git\\s+reset\\s+--hard\\b`, "m"), "git reset --hard"],
  [new RegExp(`${SEGMENT}git\\s+push\\s+.*--force\\b`, "m"), "git push --force"],
  [new RegExp(`${SEGMENT}git\\s+push\\s+.*-f\\b`, "m"), "git push -f"],
  [new RegExp(`${SEGMENT}git\\s+clean\\s+.*-f`, "m"), "git clean -f"],
  [new RegExp(`${SEGMENT}git\\s+checkout\\s+\\.\\s*$`, "m"), "git checkout ."],
  [new RegExp(`${SEGMENT}git\\s+restore\\s+\\.\\s*$`, "m"), "git restore ."],
  [new RegExp(`${SEGMENT}git\\s+branch\\s+.*-D\\b`, "m"), "git branch -D"],
  [new RegExp(`${SEGMENT}dd\\s+.*if=`, "m"), "dd raw disk operation"],
  [new RegExp(`${SEGMENT}mkfs\\b`, "m"), "mkfs format filesystem"],
  [new RegExp(`${SEGMENT}fdisk\\b`, "m"), "fdisk partition editor"],
  [new RegExp(`${SEGMENT}parted\\b`, "m"), "parted partition editor"],
  [new RegExp(`${SEGMENT}chmod\\s+.*-R\\s+777\\b`, "m"), "chmod -R 777"],
  [new RegExp(`${SEGMENT}chown\\s+.*-R\\s+.*\\s+/(etc|usr|bin|sbin|lib|var)\\b`, "m"), "chown -R on system path"],
];

const CD_PREFIX_RE = /^\s*cd\s+\S/;
const CD_THEN_OP_RE = /^\s*cd\s+[^&|;]+\s*(&&|\|\||;)/;

function commandFromEvent(event: any): string {
  return String(event?.input?.command ?? event?.args?.command ?? event?.input?.cmd ?? event?.args?.cmd ?? "");
}

function isShellTool(toolName: string): boolean {
  return toolName === "bash" || toolName === "zone_exec" || toolName.endsWith(".bash") || toolName.endsWith(".zone_exec");
}

function dangerousReason(command: string): string | null {
  for (const [pattern, description] of DANGEROUS_PATTERNS) {
    if (pattern.test(command)) return `Dangerous command blocked: ${description}.`;
  }
  return null;
}

function cdPrefixReason(command: string): string | null {
  if (!CD_PREFIX_RE.test(command) || !CD_THEN_OP_RE.test(command)) return null;

  return [
    "Compound `cd <dir> && <cmd>` is blocked.",
    "",
    "Use an explicit working-directory flag instead:",
    "- git -C <dir> ...",
    "- npm --prefix <dir> ...",
    "- make -C <dir> ...",
    "- cargo --manifest-path <dir>/Cargo.toml ...",
    "",
    "This keeps tool and Agent Beach approval policies matched to the real command.",
  ].join("\n");
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event) => {
    const toolName = String(event?.toolName ?? "");
    if (!isShellTool(toolName)) return;

    const command = commandFromEvent(event);
    if (!command) return;

    const reason = dangerousReason(command) ?? cdPrefixReason(command);
    if (!reason) return;

    return { block: true, reason };
  });
}
