---
name: learn-quiz
description: Use when wrapping up a coding session or when the user wants to understand, review, explain, or be quizzed on code changes from the session.
---

# Learn Quiz

Help the user deeply understand the code changes from this session. Treat this as teaching, not a status report.

## Workflow

1. Build a short Markdown checklist of what the user should understand. Keep it in the conversation unless the user asks for a file or a handoff artifact already exists.
2. Start by asking the user to restate their current understanding. Use that answer to decide where to drill in.
3. Teach incrementally. Do not move to the next section until the current one is understood.
4. Ask one question at a time. Prefer open-ended questions; use multiple choice when it helps isolate a misconception. If using multiple choice, vary the position of the correct answer and do not reveal it before the user answers.
5. Use concrete code, diffs, tests, runtime behavior, or the debugger when that would make the explanation clearer.
6. End only after the user has demonstrated understanding, or after they explicitly choose to stop. If they stop early, list the unchecked items.

## Checklist Topics

Cover both high-level motivation and low-level mechanics:

- Problem: what was broken or missing, why it existed, and which alternatives or branches were considered.
- Solution: what changed, why this design was chosen, edge cases, tradeoffs, and tests or verification.
- Impact: what behavior, users, systems, workflows, risks, or future work the changes affect.

Keep asking "why" until the user can explain the reason behind the change, not just repeat what changed.
