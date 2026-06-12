# Agents

This repo configures Luke's OpenCode agents.

## Primary Agents

### Developer
- Purpose: pair-programming and general implementation work.
- Focus: shipping correct code with tests and good hygiene.

### Architect
- Purpose: system design, refactoring strategy, and living docs.
- Focus: create/maintain `PLAN.md`, define boundaries/interfaces, reduce future ambiguity.

### Project Manager (PM)
- Purpose: execute multi-phase `PLAN.md` DAGs end-to-end by decomposing work into dependency-safe tasks, running subagents in parallel when safe, and tracking state in SQLite.
- Focus: phase/task orchestration, verification gates, dependency management, and progress tracking.

## Subagents (Used By PM)

- `@oracle`: deep debugging/complex reasoning.
- `@uiux`: Visual Engineer role for UI/UX and frontend work.
- `@verifier`: acceptance and gate verification.
- `@general`: generic execution when no specialist fits.

Project-specific specialists can be added by Architect policy in `PLAN.md` and discovered by PM at runtime.
