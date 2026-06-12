---
name: qna
description: For interviewing the user on design details, implementation ideas, and questions
version: 1.0
---

# QnA Skill: Intentional User Interview Framework

## Purpose

This skill provides a structured approach for the Architect agent to interview users about their projects, capturing comprehensive specifications through direct, specific, and intentional questions.

## Core Principles

### 1. Default-Driven Questions

**Every question MUST include a default answer.** If the user doesn't respond or provides minimal input, assume the default is correct and proceed.

**Format:**

```
Question: [Specific, direct question]
Default: [Well-reasoned default based on best practices/common patterns]
```

### 2. Intentional Depth

- **Avoid obvious questions** - Don't ask what can be inferred from existing code or documentation
- **Target ambiguity** - Focus on areas where implementation choices significantly impact architecture
- **Probe tradeoffs** - Explicitly ask about decisions between competing approaches
- **Uncover constraints** - Identify technical, business, or resource limitations early

### 3. Specificity Over Generality

Ask questions that lead to actionable specifications:

- ❌ "How should we handle errors?"
- ✅ "Should validation errors return 400 with structured JSON error objects (default), or use problem+json RFC 7807?"

### 4. Progressive Refinement

Start broad, then drill down:

1. **System boundaries** - What's in scope vs out of scope?
2. **Core workflows** - What are the primary user journeys?
3. **Technical constraints** - What technologies, patterns, or standards are required?
4. **Edge cases** - What happens when things go wrong?
5. **Non-functional requirements** - Performance, security, scalability expectations

## Question Categories

### Technical Implementation

Focus on concrete decisions that affect architecture:

- Data models and persistence strategy
- API contracts and versioning
- Authentication/authorization approach
- State management patterns
- Error handling and observability
- Testing strategy

**Example:**

```
Q: For user sessions, should we use JWT tokens (stateless) or server-side sessions (stateful)?
Default: JWT with 15min access tokens + 7day refresh tokens, signed with RS256
```

### UI & UX

Capture interaction patterns and user expectations:

- Navigation flows and information architecture
- Form validation and feedback patterns
- Loading states and optimistic updates
- Mobile responsiveness requirements
- Accessibility targets (WCAG level)

**Example:**

```
Q: When a user submits a form, should we show inline validation on blur, on submit, or on change?
Default: Validate on blur for each field, re-validate on change after first blur
```

### Concerns & Tradeoffs

Surface potential risks and decision rationale:

- Performance vs maintainability
- Flexibility vs simplicity
- Build vs buy decisions
- Technical debt tolerance

**Example:**

```
Q: For real-time updates, should we implement WebSockets (more complex, truly real-time) or polling (simpler, near real-time)?
Default: Start with polling every 30s, migrate to WebSockets if latency becomes a user complaint
```

### Constraints & Requirements

Identify non-negotiable boundaries:

- Budget and timeline
- Team expertise and preferences
- Existing system integrations
- Compliance requirements (GDPR, SOC2, etc.)
- Browser/platform support matrix

**Example:**

```
Q: What's the minimum supported browser version?
Default: Last 2 versions of Chrome, Firefox, Safari, Edge (per browserslist defaults)
```

## Interview Process

### Phase 1: Context Gathering (3-5 questions)

Read existing `PLAN.md`, `AGENT.md`, code, and documentation before asking anything. First questions should establish:

1. Project scope and primary goals
2. Target users and key workflows
3. Critical success metrics
4. Hard constraints (time, budget, tech stack)

### Phase 2: Deep Dive (8-15 questions)

Drill into technical and design details:

- System architecture and component boundaries
- Data flow and state management
- Integration points and external dependencies
- Error scenarios and recovery strategies
- Security and privacy considerations

### Phase 3: Edge Cases & Polish (5-10 questions)

Cover less obvious but important details:

- Scalability and performance targets
- Monitoring and observability
- Deployment and rollback strategies
- Documentation and knowledge transfer
- Future extensibility plans

### Phase 4: Validation (2-3 questions)

Confirm understanding:

- Summarize key decisions and ask for confirmation
- Highlight any apparent contradictions
- Identify any remaining ambiguities

## Output Expectations

After completing the interview, synthesize findings into `PLAN.md`:

1. **Executive Summary** - 2-3 sentences on what we're building and why
2. **System Architecture** - High-level component diagram and data flow
3. **Technical Decisions** - Key choices with rationale (including defaults assumed)
4. **Implementation Phases** - Breakdown into deliverable increments
5. **Open Questions** - Any unresolved ambiguities (should be minimal)
6. **Success Criteria** - How we'll know when each phase is complete

## Style Guidelines

### DO

✅ Ask one question at a time (or group tightly related questions)
✅ Provide context for why you're asking
✅ Offer 2-3 specific options when appropriate
✅ State your default assumption clearly
✅ Move forward confidently with defaults if user is brief

### DON'T

❌ Ask open-ended questions without guardrails ("What do you want?")
❌ Ask questions already answered in existing docs
❌ Present more than 3 options (decision paralysis)
❌ Wait for perfect information before proceeding
❌ Ask permission to continue ("Should I keep asking questions?")

## Example Question Flow

```
Q1: This looks like a task management system for development teams. Should it support
    multiple workspaces/organizations, or is it single-tenant per deployment?
    Default: Multi-tenant with organization isolation (most flexible for SaaS)

Q2: For the task board view, should we implement drag-and-drop reordering? If yes,
    should position persist immediately (optimistic) or wait for server confirmation?
    Default: Yes with optimistic updates + rollback on failure

Q3: When a task is assigned to a user, should they receive notifications? If so,
    what channels: in-app only, email, push, webhook?
    Default: In-app + email (digest mode: immediate for @mentions, hourly for assignments)
```

## Success Metrics

A successful QnA session produces:

- Actionable specifications with minimal ambiguity
- Clear technical direction for implementation
- Documented rationale for key decisions
- Realistic scope and phase breakdown
- Confidence to begin implementation without constant check-ins

Remember: **The goal is not to ask every possible question, but to ask the RIGHT questions that eliminate future ambiguity and enable confident autonomous implementation.**
