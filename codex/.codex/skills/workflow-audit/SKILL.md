---
name: workflow-audit
description: Use when the user asks to audit recent Codex work, review prior sessions or memories, identify repeated manual workflows, or propose new skills, subagents, hooks, scripts, rules, or automations from recurring patterns.
---

# Workflow Audit

Find recurring manual work in recent Codex activity and turn it into concrete reusable artifacts. Treat this as evidence gathering, not brainstorming from vibes.

## When to use

Use this when the user asks to:
- audit recent work for skill or automation opportunities
- inspect prior sessions, memories, rollouts, or recurring manual steps
- decide whether a workflow should become a skill, subagent, hook, script, rule, or automation

Do not use this for normal code review, one-off tech debt audits, or generic productivity advice.

## Procedure

1. Define the audit window. If the user did not specify one, inspect the most recent relevant memory entries and the current task context before expanding further.
2. Gather evidence from the narrowest useful sources:
   - `codex/.codex/memories/MEMORY.md`
   - directly relevant files in `codex/.codex/memories/rollout_summaries/`
   - existing artifacts under `codex/.codex/skills/`, `codex/.codex/automations/`, and `codex/.codex/rules/`
   - current repo diffs or task logs when the audit is about the active workspace
3. Cluster repeated work. Look for repeated command sequences, long diagnosis paths, recurring explanations, fragile manual migrations, validation rituals, local policy decisions, and places where agents repeatedly need the same context.
4. Classify each candidate:
   - **Skill**: judgment-heavy recurring workflow that benefits from procedural guidance
   - **Script or automation**: deterministic transform, retry loop, report generation, or command sequence
   - **Hook or rule**: enforceable guardrail that should fail before bad work lands
   - **Subagent**: independent research, review, or validation task with a clear boundary
   - **Memory or instruction**: local preference, repo convention, or decision record rather than a reusable workflow
5. Prioritize by repetition, risk, time saved, and implementation cost. Prefer three high-signal candidates over a long list.
6. Report each recommendation with:
   - evidence from the audited work
   - proposed artifact type and name
   - why that artifact is the right form
   - the smallest next step
   - uncertainty or missing evidence
7. If the user asked to create the artifact, create only the requested or clearly highest-value item. For skills, use the local skill authoring guidance first and keep the new skill minimal.

## Output shape

Lead with the strongest candidates. Separate "create now" from "defer" when evidence is thin.

Avoid quoting whole prior sessions. Cite file paths, session ids, commands, or short evidence snippets instead.

## Pitfalls

- Do not turn a one-off solution into a skill.
- Do not copy an external prompt verbatim when a smaller local skill will do.
- Do not read broad history dumps when targeted `rg` queries and relevant rollout summaries answer the question.
- Do not recommend a skill when a script, hook, or rule would make the behavior deterministic.
- Do not ignore existing skills; update or extend the nearest existing artifact when that is the simpler fit.
