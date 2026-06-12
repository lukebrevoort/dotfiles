# AGENTS.md — Portable Development Environment

## Project Context

This repository configures Luke's personal and employer-owned macOS development
environments. The target full stack is Ghostty + Neovim/LazyVim + AeroSpace +
Bash, with Codex, OpenCode, Claude Code, and Cursor available through isolated
personal and work profiles.

All implementation follows `PLAN.md`.

## Non-Negotiable Boundaries

- Never commit credentials, OAuth tokens, company code, internal documentation,
  proprietary prompts, test data, or employer-specific architecture.
- Do not assume that an available integration is approved for company data.
- Work and personal identities, AI state, histories, credentials, and project
  roots must remain isolated.
- Use `$HOME`, command discovery, and profile configuration instead of fixed
  usernames or `/opt/homebrew` assumptions.
- Unknown policy-sensitive integrations are disabled by default.
- Existing uncommitted user changes must not be discarded.

## Agent Roles

### Architect

- Owns `PLAN.md`, `AGENTS.md`, architectural decisions, and isolation policy.
- Interviews the user, defines phase dependencies, and updates living docs.
- Does not implement phases unless explicitly asked to change roles.

### Project Manager

- Decomposes selected phases into dependency-safe tasks.
- Tracks execution, dispatches specialists, and enforces phase gates.
- Must place security and identity tasks before company repository access.

### Developer

- Implements setup scripts, shell configuration, package manifests, editor
  configuration, and AI wrappers.
- Uses existing patterns and keeps changes within assigned phase scope.

### Security Reviewer

- Reviews secrets handling, OAuth/account separation, Git identity, filesystem
  permissions, remote MCP access, and data leakage paths.
- Produces blocking findings for credential exposure or work/personal crossover.
- Must review Phases 0, 4, 6, and 7.

### Reviewer

- Reviews correctness, portability, maintainability, keybinding conflicts, and
  policy consistency.
- Treats hard-coded home paths and silent fallback to personal accounts as bugs.

### Verifier

- Runs syntax checks, dry-runs, clean-home tests, symlink validation, package
  audits, shell startup tests, and profile acceptance criteria.
- Reports concrete evidence and does not modify implementation during a gate.

### Experiment Evaluator

- Designs reproducible evaluation support for AI orchestration experiments.
- Focuses on metrics, seeds, artifacts, comparisons, traceability, and bounded
  concurrency.
- Never introduces company-specific formats or data into this repository.

## Workflow

1. Architect maintains `PLAN.md` from user requirements.
2. User selects an implementation phase.
3. PM decomposes the phase and identifies parallel-safe work.
4. Developer or specialist subagents implement tasks.
5. Security Reviewer checks policy-sensitive phases.
6. Verifier runs the phase acceptance gate.
7. Architect records completed decisions and remaining risks.

## Required Implementation Practices

- Provide an intermediate user update before editing files.
- Use `apply_patch` for manual edits.
- Prefer idempotent scripts and support `--dry-run`.
- Back up conflicting user files before replacing or linking them.
- Do not print secret values in logs or health checks.
- Keep the minimal profile functional throughout development.
- Test both Apple Silicon and Intel Homebrew path discovery logically, even when
  only one architecture is locally available.
