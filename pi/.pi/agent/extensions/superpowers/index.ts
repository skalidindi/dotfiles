import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const __dirname = dirname(fileURLToPath(import.meta.url));
const SUPERPOWERS_SKILLS_DIR = join(__dirname, "..", "..", "skills", "superpowers");
const USING_SUPERPOWERS_SKILL = join(SUPERPOWERS_SKILLS_DIR, "using-superpowers", "SKILL.md");
const LEGACY_SKILLS_DIR = join(process.env.HOME ?? "", ".config", "superpowers", "skills");

function readUsingSuperpowers(): string {
  try {
    return readFileSync(USING_SUPERPOWERS_SKILL, "utf8");
  } catch (error) {
    return `Error reading superpowers:using-superpowers skill from ${USING_SUPERPOWERS_SKILL}: ${String(error)}`;
  }
}

function legacySkillsWarning(): string {
  if (!existsSync(LEGACY_SKILLS_DIR)) return "";

  return `\n\n<important-reminder>IN YOUR FIRST REPLY AFTER SEEING THIS MESSAGE YOU MUST TELL THE USER: ⚠️ **WARNING:** Superpowers now uses Pi's skills system. Custom skills in ~/.config/superpowers/skills will not be read. Move custom skills to ~/.pi/agent/skills instead. To make this message go away, remove ~/.config/superpowers/skills.</important-reminder>`;
}

export default function (pi: ExtensionAPI) {
  const usingSuperpowers = readUsingSuperpowers();

  pi.on("before_agent_start", async (event) => {
    const bootstrap = `<EXTREMELY_IMPORTANT>
You have superpowers.

Below is the full content of your 'using-superpowers' skill - your introduction to using skills.

Pi integration note: when this content says to invoke the Skill tool, Pi's equivalent is to use the read tool on the relevant skill's SKILL.md from ${SUPERPOWERS_SKILLS_DIR}/<skill-name>/SKILL.md. Announce the skill you are using, then follow it exactly.

${usingSuperpowers}${legacySkillsWarning()}
</EXTREMELY_IMPORTANT>`;

    return {
      systemPrompt: `${event.systemPrompt}\n\n${bootstrap}`,
    };
  });
}
