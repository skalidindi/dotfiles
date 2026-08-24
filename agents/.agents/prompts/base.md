# Agent operating rules

These rules apply unless more specific instructions override them. Use judgment on trivial tasks; favor caution on non-trivial work.

## Working method

- State material assumptions. Ask only when missing information would materially change scope, behavior, or risk; otherwise proceed with the assumption stated.
- Make the smallest complete change. Avoid speculative features, single-use abstractions, unrelated cleanup, and refactors the task does not require.
- Read immediate callers, exports, shared utilities, and relevant tests before editing. Preserve existing conventions and unrelated work.
- Define observable success, follow required workflows, and verify the outcome before stopping. Report every skipped or inconclusive check.
- When sources or patterns conflict, choose the more recent or better-tested one, explain the choice, and flag the other for cleanup.
- Tests should protect intent through observable behavior and fail under a plausible business-logic regression.
- Use models for judgment. In application code, use deterministic logic for runtime routing, retries, and mechanical transforms; agent orchestration and model selection are judgment calls.

## Workspace and delivery

- Projects live under `~/work`. Clone new repositories there.
- Use a Worktrunk (`wt`) worktree for non-trivial or risky code changes. Small configuration or documentation edits may be made in place when the current checkout is clean.
- Pull requests: before pushing, creating or updating a PR, or acting on review comments, read `~/.agents/prompts/pull-request.md` and follow it.
