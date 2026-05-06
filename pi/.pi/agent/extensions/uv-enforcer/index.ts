import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const SEGMENT = String.raw`(?:^|\n|[;|&]{1,2})\s*(?:(?:command|exec)\s+)?(?:env\s+(?:\S+=\S+\s+)*)?`;
const PIP = new RegExp(`${SEGMENT}(?:\\S+/)?pip(?:3(?:\\.\\d+)?)?\\b`, "m");
const POETRY = new RegExp(`${SEGMENT}(?:\\S+/)?poetry\\b`, "m");
const PYTHON = new RegExp(
  `${SEGMENT}(?:\\S+/)?python(?:3(?:\\.\\d+)?)?\\b`,
  "m",
);

const MESSAGE = `Use uv instead of direct python/pip/poetry commands.

Examples:
  uv run python script.py
  uv run python -c 'print("hello")'
  uv run --with PACKAGE python script.py
  uv add PACKAGE
  uv add --dev PACKAGE
  uv sync
  uv venv

If pip semantics are truly required, use uv pip ... instead of pip directly.`;

function shouldBlock(command: string): boolean {
  return PIP.test(command) || POETRY.test(command) || PYTHON.test(command);
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event) => {
    if (event.toolName !== "bash") return;

    const command = String(
      (event.input as { command?: unknown }).command ?? "",
    );
    if (!shouldBlock(command)) return;

    return { block: true, reason: MESSAGE };
  });
}
