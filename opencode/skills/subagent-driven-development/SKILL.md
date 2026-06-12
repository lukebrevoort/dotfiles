---
name: subagent-driven-development
description: Execute implementation plans with independent tasks using fresh subagents and grouped verification between implementation waves, enabling fast iteration with quality gates. Use when executing implementation plans that can be broken into relatively independent tasks, especially for feature implementation, refactoring, or bug fixes where quality assurance between steps is important.
version: 1.0
---

# Subagent-Driven Development

This skill provides a structured workflow for executing implementation plans with built-in quality gates and grouped verification at each implementation wave.

## Overview

Subagent-Driven Development (SDD) breaks implementation plans into discrete tasks, executes independent tasks with fresh subagents, then verifies each completed DAG-safe group in one pass. This ensures:

- **Quality at every wave**: Each completed implementation group is verified before dependent work proceeds
- **Clean context**: Fresh subagents prevent context pollution
- **Fast iteration**: Issues are caught after each implementation wave, not only at the end
- **Deterministic progress**: Clear success criteria for each step

## When to Use

Use this skill when:

- You have a detailed implementation plan with relatively independent tasks
- Quality assurance between steps is important
- Tasks can be completed in a single session
- You want automatic grouped verification between implementation waves

Don't use when:

- Tasks are highly interdependent (use regular PM flow instead)
- Speed is more important than quality verification
- The plan is exploratory or undefined

## Workflow

### 1. Task Decomposition

Break the implementation plan into tasks with these properties:

- **Independence**: Can be understood and implemented in isolation
- **Completeness**: Has clear start and end state
- **Verifiability**: Has explicit acceptance criteria
- **Atomicity**: Single responsibility (one logical change)

### 2. Task Types

Every task should have a type:

- `impl` - Implementation (code changes)
- `verify` - Verification (checks acceptance criteria)
- `fix` - Bug fix (code correction)
- `test` - Test writing
- `docs` - Documentation
- `research` - Investigation

### 3. Task Structure

Each task must include:

```yaml
task_id: "phase-X.task-Y.type-description"
title: "Clear, actionable title"
type: "impl|verify|fix|test|docs|research"
owner: "@subagent-name"
description: |
  ## Context
  [Where this fits in the bigger picture]

  ## Assignment
  [Specific task details]

  ## Files
  - path/to/file1
  - path/to/file2

  ## Constraints
  - [Any specific constraints]
dependencies: ["task-id-1", "task-id-2"]
acceptance_criteria: |
  1. [Criterion 1]
  2. [Criterion 2]
  3. [Criterion 3]
```

### 4. The SDD Pattern

Implementation work MUST follow this grouped pattern:

```
[Implementation Wave: one or more impl/fix/refactor tasks] -> [Single Verification Task for that wave] -> [Next dependent work]
```

Example:

```
task-01.impl-api-endpoint
task-02.impl-auth-middleware
  -> task-03.verify-batch-api
    -> task-04.impl-frontend-integration
    -> task-05.impl-e2e-config
      -> task-06.verify-batch-integration
```

## Quality Gates

### Gate 1: Pre-Implementation

Before starting implementation:

- [ ] Task is well-understood
- [ ] Acceptance criteria are clear
- [ ] Dependencies are satisfied
- [ ] Files to modify are identified

### Gate 2: Implementation

Implementation subagent must:

- [ ] Follow acceptance criteria exactly
- [ ] Write clean, maintainable code
- [ ] Include tests if specified
- [ ] Verify their own work before reporting
- [ ] Report what was done and any issues

### Gate 3: Verification

Verification subagent must:

- [ ] Check all acceptance criteria
- [ ] Verify all covered tasks as one batch
- [ ] Review code quality
- [ ] Verify tests pass
- [ ] Check for regressions
- [ ] Run MCP-based runtime validation (build/run/interact) when feasible
- [ ] Report PASS or specific failures

### Gate 4: Integration

Before marking complete:

- [ ] Verified code integrates with existing code
- [ ] No breaking changes (or they're acceptable)
- [ ] Documentation updated if needed

## Subagent Prompt Templates

### Implementation Subagent Prompt

```
## Task: [Task Title]

### Context
[High-level context]

### Your Assignment
[Specific implementation task]

### Files to Modify
- path/to/file1
- path/to/file2

### Acceptance Criteria (MUST SATISFY)
1. [Criterion 1]
2. [Criterion 2]
3. [Criterion 3]

### Constraints
- [Any constraints]

### Quality Standards
- Follow existing code patterns
- Write clear, readable code
- Handle errors appropriately
- Add tests if specified
- No console.logs or debug code in production

### Before You Report Success
- [ ] Implementation is complete
- [ ] You've verified it works
- [ ] Code compiles/parses without errors
- [ ] Tests pass (if applicable)
- [ ] Acceptance criteria are met

### Report Format
Provide:
1. **Summary**: What you implemented
2. **Files Changed**: List with brief description of changes
3. **Verification Steps**: How you verified it works
4. **Issues Encountered**: Any problems or deviations from plan
5. **Acceptance Criteria Check**: How each criterion was met
```

### Verification Subagent Prompt

```
## Verification Task: [Batch Verify Title]

### Implementation Batch to Verify
Covered tasks:
- [Task ID A]
- [Task ID B]
Files: [List of files across covered tasks]

### Acceptance Criteria
1. [Criterion 1]
2. [Criterion 2]
3. [Criterion 3]

### Your Assignment
Verify that the implementation meets all acceptance criteria and follows quality standards.

### Verification Checklist
- [ ] All acceptance criteria are met
- [ ] Covered tasks are validated together
- [ ] Code is readable and well-structured
- [ ] Follows project conventions
- [ ] No obvious bugs or issues
- [ ] Tests exist and pass (if required)
- [ ] Build/run successful (if applicable)
- [ ] MCP-driven runtime interaction completed (if feasible)
- [ ] No debug code or console.logs left in
- [ ] Integration with existing code is appropriate

### Report Format
Use the Verifier Agent output format:
- Summary (PASS/NEEDS_FIXES/REJECTED)
- Acceptance criteria check (each criterion with status)
- Code quality assessment
- Specific issues found (file:line references)
- Verdict and next steps
```

## Parallel Execution

Tasks can be parallelized when:

- They have no shared dependencies
- They don't modify the same files
- They're in the same phase of work

Use file locking to prevent conflicts:

1. Acquire locks on all files you'll modify
2. If blocked, defer the task
3. Release locks immediately after completion

## Error Handling

### Task Failure

When a task fails:

1. **First failure**: Reset to PENDING, record error, retry
2. **Second failure**: Analyze if it's a pattern or one-off
3. **Third failure**: Mark FAILURE, block dependent tasks

### Verification Failure

When verification fails:

1. Mark covered implementation group as NEEDS_FIXES
2. Create fix task(s) with specific issues to address
3. Fix task(s) depend on verification results
4. Re-run one grouped verification task after fixes complete

### Recovery Options

When the DAG is blocked:

1. **Skip and continue**: Mark blocked tasks as SKIPPED, continue with independent work
2. **Fix and retry**: Create fix tasks for blocking issues
3. **Revise plan**: Adjust the plan based on what was learned

## Best Practices

### Task Sizing

- **Small tasks** (< 30 min): Good for focused work, easy verification
- **Medium tasks** (30-60 min): Balanced, most common
- **Large tasks** (> 60 min): Break down if possible

### Verification Strategy

- Always verify implementation waves/groups
- Can skip verification for research/docs tasks
- Use @verifier once per completed implementation group
- Use @reviewer for significant architectural changes
- Use @oracle for complex debugging verification

### Communication

- Report progress after each task completion
- Flag issues immediately, don't wait
- Be specific about what's blocking
- Celebrate wins briefly, then move on

## Example Workflow

### Feature Implementation Example

```yaml
# Task 1: Research
task_id: "phase-1.task-01.research-auth"
type: "research"
owner: "@researcher"
dependencies: []

# Task 2: Design
task_id: "phase-1.task-02.design-auth"
type: "design"
owner: "@architect"
dependencies: ["phase-1.task-01.research-auth"]

# Task 3: Implement backend (group A)
task_id: "phase-1.task-03.impl-auth-service"
type: "impl"
owner: "@general"
dependencies: ["phase-1.task-02.design-auth"]

# Task 4: Implement UI (group A)
task_id: "phase-1.task-04.impl-login-ui"
type: "impl"
owner: "@uiux"
dependencies: ["phase-1.task-02.design-auth"]

# Task 5: Single verify for group A (gates next tasks)
task_id: "phase-1.task-05.verify-auth-batch-a"
type: "verify"
owner: "@verifier"
dependencies: ["phase-1.task-03.impl-auth-service", "phase-1.task-04.impl-login-ui"]

# Task 6: Integration tests
task_id: "phase-1.task-06.test-auth-flow"
type: "test"
owner: "@general"
dependencies: ["phase-1.task-05.verify-auth-batch-a"]
```

## Integration with PM DB

Use the PM MCP server to:

- Create tasks with `pm_create_tasks`
- Add dependencies with `pm_add_dependencies`
- Claim tasks with `pm_claim_task`
- Update status with `pm_update_task_status`
- Lock files with `pm_lock_files`

## Metrics to Track

- Tasks completed vs planned
- Verification pass rate
- Average task duration
- Retry rate
- Blocked time
