# PLAN.md — Portable Personal and Work Development Environment

> **Status**: Implementation underway; bootstrap foundation complete
> **Owner**: Architect agent
> **Last updated**: 2026-06-12

## Objective

Turn this repository into a reliable, interactive macOS bootstrap that can set up
a productive development environment on a managed work laptop within one day,
while keeping personal and employer identities, credentials, AI history, agent
instructions, integrations, and project data isolated.

The primary work profile is optimized for AI orchestration and Python, while
remaining useful for unfamiliar languages and repositories.

## Confirmed Requirements

- The work laptop is macOS with administrator access.
- Homebrew and third-party AI development tools are permitted.
- Primary AI clients: Codex, OpenCode, Claude Code, and Cursor.
- AI usage emphasizes multi-agent orchestration, tool connections, evaluation,
  testing, planning, and autonomous multi-file work.
- Authentication uses employer-managed accounts rather than personal accounts.
- Work and personal environments must be separated as completely as practical.
- Company repositories may contain their own evolving `AGENTS.md` and related
  project instructions.
- Integrations should be broad, but each must be deliberately authenticated and
  approved for company data.
- Expected work is primarily Python on Mytra's orchestration team, including
  testing AI orchestration algorithms for optimized spacing.
- Setup should be interactive and explain choices while it runs.
- Preferred full environment: Ghostty + AeroSpace + Bash + Neovim.
- Minimal fallback: Apple Terminal + Zsh + Neovim.
- First-day setup must reach a useful baseline quickly; refinements can follow.

## Architecture Decisions

### AD-1: Profile-Based Installation

The installer will expose these profiles:

| Profile | Purpose | Shell | UI |
| --- | --- | --- | --- |
| `personal` | Existing personal machine | Bash | Ghostty + AeroSpace |
| `work` | Employer-owned laptop | Bash | Ghostty + AeroSpace |
| `minimal` | Restricted or recovery setup | Zsh | Apple Terminal |

Profiles choose packages, copied configuration, AI configuration, and
optional integrations. They do not contain credentials.

### AD-2: Bash Replaces Fish

Bash is the primary shell for personal and work profiles. Fish configuration and
functions will be retired after equivalent Bash behavior exists.

Required Bash capabilities:

- Homebrew shell environment initialization for Apple Silicon and Intel Macs.
- Starship prompt and zoxide initialization when installed.
- `EDITOR` and `VISUAL` set to Neovim.
- Portable `proj`, `dev`, `oc`, and `lg` functions.
- Profile detection without embedding a username or home directory.
- Optional local files loaded from untracked profile-specific locations.

The repository should prefer a current Homebrew Bash rather than macOS's old
system Bash where company policy allows it. The minimal profile keeps Zsh.

### AD-3: Strict Work and Personal Isolation

The repository may share non-sensitive editor, terminal, theme, and shell
defaults. Work and personal laptops install different profiles into standard
application paths. The following must remain machine-specific:

- AI provider accounts and tokens.
- Git identities, signing keys, and credential helpers.
- GitHub CLI accounts.
- Agent conversation history and caches.
- MCP credentials and OAuth sessions.
- Company-specific agent instructions.
- Company repositories and generated artifacts.
- Browser profiles used by AI tools.

Target local layout:

```text
~/.config/dotfiles/profile                 # "personal", "work", or "minimal"
~/.config/dotfiles/local.sh                # untracked machine overrides
~/.config/dotfiles/work.env                # untracked work-only environment
~/.config/dotfiles/personal.env            # untracked personal environment
~/.config/opencode/                        # active OpenCode configuration
~/.claude/                                 # active Claude settings/state
~/.codex/                                  # active Codex config/auth/sessions
~/Developer/work/                          # company repositories
~/Developer/personal/                      # personal repositories
```

The selected profile is installed as real files. Applications use their normal
config paths, while credentials and machine-local overrides remain untracked.

### AD-4: Repository Instructions Are Local to Each Project

Global agent instructions should be neutral and safety-oriented. Company context
must live in company-controlled repositories or untracked work-only files.

No Mytra source code, internal documentation, prompts, credentials, test data,
or proprietary architecture may be committed to this public/personal dotfiles
repository.

### AD-5: Interactive, Idempotent Bootstrap

The entry point will be:

```bash
./setup
```

It should:

1. Detect macOS version, architecture, admin access, Homebrew, and existing files.
2. Ask for `personal`, `work`, or `minimal`.
3. Show the packages and configuration selected by that profile.
4. Support `--dry-run`, `--non-interactive`, and `--profile`.
5. Install packages through a version-controlled `Brewfile`.
6. Back up conflicting files before installing copies.
7. Run health checks after each stage.
8. Pause for browser-based logins rather than requesting secrets in the terminal.
9. Produce a final report of completed, skipped, and failed steps.
10. Be safe to rerun.

### AD-6: Layered AI Setup

AI clients are installed first; integrations are enabled in a later stage.
Being technically available is not sufficient justification to connect an
integration to employer data.

Each client receives:

- A work wrapper and personal wrapper where state relocation is supported.
- A neutral global baseline.
- Repository-local instructions.
- A documented login step using the intended employer or personal identity.
- A health check that reports account/configuration roots without printing
  tokens.
- No hard-coded model names that make setup fail when provider catalogs change.

### AD-7: MCP and Connector Allowlist

Integrations are managed by profile and risk:

| Tier | Examples | Work default |
| --- | --- | --- |
| Local development | filesystem, Git, test runners, language servers | Enable |
| Public technical knowledge | official docs, Context7, public code search | Enable |
| Browser automation | Playwright, Chrome DevTools | Ask |
| Company systems | GitHub, Slack, Notion, issue trackers | Ask and authenticate |
| Personal systems | personal Gmail, Notion, calendars | Disable in work |
| Arbitrary remote MCP | unknown third-party servers | Disable |

Every enabled integration must document what data it can read, what it can
write, where authentication is stored, and how to revoke access.

### AD-8: Fast Baseline Before Full Customization

The first-day critical path is intentionally short:

1. Xcode Command Line Tools and Homebrew.
2. Git identity and employer authentication.
3. Bash or minimal Zsh.
4. Neovim and core CLI tools.
5. One functioning AI client, preferably the employer-supported option.
6. Clone and validate a company repository.

Ghostty, AeroSpace, all AI clients, MCP integrations, custom agents, and visual
polish follow once the baseline works.

### AD-9: No Secrets in Git

Tracked files may contain variable names and documentation only. Secrets should
prefer system keychains and client-managed OAuth. Environment files are a
fallback and must be mode `0600`.

The installer and doctor must scan tracked content for likely secrets and
hard-coded home-directory paths.

## Target Repository Structure

```text
dotfiles/
  AGENTS.md
  PLAN.md
  GUIDE.md
  WORK_LAPTOP_SETUP.html
  Brewfile
  setup
  bootstrap.sh
  install.sh                         # compatibility wrapper or removal
  profiles/
    personal.conf
    work.conf
    minimal.conf
  scripts/
    lib/
      common.sh
      prompts.sh
      deploy.sh
    install-packages.sh
    configure-shell.sh
    configure-git.sh
    configure-ai.sh
    doctor.sh
    uninstall.sh
  bash/
    bashrc
    profile
    functions/
  zsh/
    zshrc
  git/
    config
    ignore
  ghostty/
  aerospace/
  nvim/
  starship/
  ai/
    shared/
    opencode/
    codex/
    claude/
    cursor/
  templates/
    local.sh.example
    work.env.example
    personal.env.example
    project-AGENTS.md
```

## Portability Defects Already Found

These must be addressed during implementation:

1. `install.sh` supports Ubuntu/Debian rather than the target macOS machines.
2. Most current configuration is uncommitted and therefore absent from a clone.
3. `opencode.json` embeds the current machine's absolute home-directory path.
4. OpenCode references missing `plugin/caffeinate.ts`,
   `bin/with-opencode-env`, and `mcp/pm-mcp-server`.
5. Repository OpenCode config is not the live config currently in use.
6. Starship was linked as `~/.config/starship/`, but the expected default file is
   `~/.config/starship.toml`.
7. `fish/fish_variables` is machine-generated and contains local application
   paths.
8. Ghostty config requires `/opt/homebrew/bin/fish`, contrary to the new Bash
   decision.
9. AeroSpace's OpenCode launcher embeds `/opt/homebrew` paths and Fish.
10. The current default login shell is `/bin/bash`, while shell behavior depends
    on Fish config.
11. AI model identifiers differ between `opencode.json` and agent prompt files.
12. Current OpenCode permissions are broadly permissive and need a safer work
    baseline.

## Implementation Phases

### Phase 0 — Preserve and Baseline

**Goal**: Make the current work reviewable before refactoring.

**Status**: Implemented and locally verified.

Tasks:

- Review the dirty worktree and separate intended configuration from generated
  or local-only state.
- Add ignore rules for machine state, AI databases, caches, credentials, and
  local overrides.
- Commit a known baseline only after secret and path scanning.
- Record current command versions and installed config paths.

Gate:

- A fresh clone contains all intended source configuration and no credentials.

### Phase 1 — Profiles and Bootstrap Framework

**Goal**: Build the interactive, idempotent `./setup` entry point.

**Status**: Implemented and locally verified.

Tasks:

- Add profile definitions and prompt helpers.
- Implement architecture and package-manager detection.
- Implement dry-run, backups, reruns, structured logs, and failure summaries.
- Add a minimal uninstall/restore path.

Gate:

- Dry-runs for all profiles succeed without changing the machine.

### Phase 2 — macOS Package Installation

**Goal**: Reproduce required applications and CLI tools.

**Status**: Initial `Brewfile` implementation complete; clean-machine installation
still needs verification.

Tasks:

- Create a `Brewfile` with required and optional groups.
- Cover Bash, Neovim, Git tooling, Python tooling, Ghostty, AeroSpace, Starship,
  zoxide, ripgrep, fd, lazygit, GitHub CLI, and selected AI clients.
- Keep Cursor and other GUI apps optional when installation method or licensing
  differs.
- Preserve the minimal profile without Ghostty, AeroSpace, or AI extras.

Gate:

- Package audit reports all required tools present for the selected profile.

### Phase 3 — Bash, Zsh Fallback, and Portable Functions

**Goal**: Replace Fish while preserving useful workflows.

**Status**: Bash and Zsh files implemented; login-shell migration and live
workflow testing remain.

Tasks:

- Implement Bash startup files with portable Homebrew discovery.
- Port `proj`, `dev`, `oc`, and `lg`.
- Add profile-aware environment loading.
- Add minimal Zsh configuration.
- Remove Fish from new profile installs; archive or delete it only after parity.
- Update Ghostty and AeroSpace launch commands.

Gate:

- New login shells start without errors on Apple Silicon and Intel path layouts.

### Phase 4 — Git and Identity Isolation

**Goal**: Prevent accidental cross-account commits and authentication.

**Status**: Conditional identity files implemented; GitHub account and
repository-location preflight checks remain.

Tasks:

- Use conditional Git includes by directory (`~/Developer/work/**` and
  `~/Developer/personal/**`).
- Prompt for work name/email without committing them to the repository.
- Configure separate GitHub CLI authentication checks.
- Evaluate SSH keys versus HTTPS/keychain based on employer policy.
- Add a preflight warning when repository location and active identity disagree.

Gate:

- Test repositories in both roots resolve the correct identity and credentials.

### Phase 5 — Terminal, Window Manager, and Editor

**Goal**: Restore the preferred interactive environment.

Tasks:

- Make Ghostty use profile-selected Bash without absolute paths.
- Install Starship at its standard configuration path.
- Update AeroSpace launchers and preserve a reliable terminal shortcut.
- Make Neovim language support demand-driven rather than always loading Flutter,
  Dart, or unrelated tooling.
- Establish a strong Python baseline: Ruff, basedpyright or pyright, pytest,
  debug adapter, formatting, and virtual-environment awareness.
- Retain support for unfamiliar stacks through LazyVim extras or project-local
  tooling.

Gate:

- Ghostty, AeroSpace, Bash, Starship, and Neovim pass smoke tests.

### Phase 6 — AI Client Isolation

**Goal**: Install and isolate Codex, OpenCode, Claude Code, and Cursor.

**Status**: Codex and OpenCode CLI isolation implemented and verified. Claude
settings are separated, but macOS OAuth remains in Keychain and requires an
account check. Cursor profile isolation remains.

Tasks:

- Verify each current client's supported config/state override mechanisms.
- Build profile wrappers only from documented behavior.
- Remove absolute paths and missing OpenCode dependencies.
- Reconcile agent definitions with actually available models.
- Establish conservative work permissions and more permissive opt-in project
  instructions.
- Ensure Cursor uses the intended employer account and separate settings/profile.
- Document login, logout, account verification, state deletion, and revocation.

Gate:

- Each client can prove it is using the intended work identity and work-only
  state before opening company source.

### Phase 7 — Orchestration and Integrations

**Goal**: Build a powerful but auditable agent-orchestration environment.

Tasks:

- Define shared roles for architect, project manager, developer, reviewer,
  verifier, security reviewer, and experiment evaluator.
- Keep provider-specific configuration thin; store project behavior in
  repository instructions where possible.
- Add MCP integrations incrementally using the allowlist.
- Add an evaluation workflow for orchestration algorithms: experiment metadata,
  deterministic seeds where possible, metrics, artifacts, comparison reports,
  and reproducibility notes.
- Add concurrency and cost controls so orchestration does not accidentally spawn
  unbounded work or disclose context across tasks.

Gate:

- A harmless sample repository completes a multi-agent plan, implementation,
  verification, and review cycle with traceable outputs.

### Phase 8 — Doctor, Documentation, and First-Day Drill

**Goal**: Prove that onboarding can be completed under time pressure.

**Status**: Initial doctor and conservative uninstall workflow implemented; timed
clean-machine drill remains.

Tasks:

- Implement `scripts/doctor.sh` with concise remediation output.
- Update `GUIDE.md` to reflect Bash and profiles.
- Keep `WORK_LAPTOP_SETUP.html` as the visual runbook.
- Test from a clean temporary home directory where feasible.
- Perform a timed setup drill and record manual-only steps.
- Define backup, rollback, revocation, and offboarding procedures.

Gate:

- Work profile reaches the baseline in under 60 minutes excluding downloads and
  employer approval delays.

## Phase Dependencies

```text
Phase 0 -> Phase 1 -> Phase 2 -> Phase 3
                                      | \
                                      |  +-> Phase 4 --+
                                      |                |
                                      +----> Phase 5 --+-> Phase 6 -> Phase 7 -> Phase 8
```

Phase 4 and Phase 5 may run in parallel after Phase 3. AI clients must not be
connected to company repositories until the identity isolation gate passes.

## PM Routing Policy

| Work type | Primary owner | Required review |
| --- | --- | --- |
| Bootstrap and shell implementation | Developer/general | Verifier |
| Secrets, identity, permissions, MCP | Security reviewer | Verifier |
| Neovim, Ghostty, AeroSpace | Developer/general | Verifier |
| AI orchestration design | Architect/oracle | Security reviewer + verifier |
| HTML runbook and interaction design | UI/UX | Verifier |
| Failed acceptance gate | Oracle | Verifier rerun |

No subagent may invent employer policy. Unknown policy-sensitive behavior must be
implemented as disabled-by-default with an explicit prompt.

## Acceptance Criteria

The migration is complete when:

- A fresh macOS account can clone the repository and run `./setup`.
- Work, personal, and minimal profiles install independently.
- No tracked file contains credentials, company data, or a fixed username.
- Work and personal Git identities are selected by project directory.
- Codex, OpenCode, Claude Code, and Cursor can use separate work identities and
  state to the extent supported by each product.
- Unknown or unsupported isolation limitations are clearly reported.
- Bash is the default configured shell for full profiles.
- Minimal Zsh + Apple Terminal + Neovim remains usable.
- `doctor.sh` detects missing packages, stale installed configs, wrong identities, unsafe
  permissions, hard-coded paths, and likely secrets.
- A timed first-day drill reaches a productive company-repository workflow.

## Deferred Decisions

- Exact employer-approved MCP services and data boundaries.
- Whether Mytra requires a VPN, device-management tooling, internal package
  index, or internal certificate installation.
- Git transport and commit-signing policy.
- Whether separate macOS user accounts are necessary for tools that cannot
  relocate personal and work state.
- Which AI client is the employer-supported first-day default.
- Internal experiment formats, metrics, datasets, and orchestration frameworks.
