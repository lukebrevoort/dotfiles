# Dotfiles Guide

> **Migration status**: The first profile-based setup is implemented and passes
> disposable-home tests. Package installation and live account login still need
> a clean-machine drill before work-laptop use.

## Target Setup

The repository is being converted to support:

- `work`: Ghostty + AeroSpace + Bash + Neovim with isolated employer AI accounts.
- `personal`: the same core tools with personal identities and state.
- `minimal`: Apple Terminal + Zsh + Neovim.

Preview the work profile without changing anything:

```bash
./setup --profile work --dry-run
```

Apply it interactively:

```bash
./setup --profile work
```

See `WORK_LAPTOP_SETUP.html` for the visual first-day runbook.

## Setup Options

- `--profile work|personal|minimal`
- `--dry-run`
- `--non-interactive`
- `--skip-packages`
- `--skip-git`
- `--skip-doctor`

Conflicting files are backed up with a timestamp. Re-running setup is safe.

Remove repository-owned links without deleting profile credentials or state:

```bash
scripts/uninstall.sh --profile work
```

## Profiles

- `work`: Bash, Ghostty, AeroSpace, Neovim, AI client packages, and work roots.
- `personal`: the same tools with separate profile state.
- `minimal`: Zsh, Apple Terminal, Neovim, and core CLI tools.

## AeroSpace Keybinds

- Focus: `alt+h/j/k/l`
- Move: `alt+shift+h/j/k/l`
- Layout: `alt+/` and `alt+,`
- Resize: `alt+-` and `alt+=`
- Workspaces: `alt+1..9` and named workspace bindings
- OpenCode launcher: `alt+o`

The OpenCode launcher now resolves commands through the Bash environment.

## Current Neovim OpenCode Keybinds

- `<leader>ao`: toggle OpenCode
- `<leader>ap`: prompt with file and cursor context
- `<leader>as`: send selection
- `<leader>ad`: send diagnostics
- `<leader>af`: prompt with current file
- `<leader>aq`: send quickfix context
- `<leader>an`: start a new session

## Bash Commands

- `proj <name>`: jump with zoxide and open Neovim.
- `dev <name>`: jump, launch OpenCode in Ghostty, and open Neovim.
- `oc [args]`: run OpenCode.
- `lg [args]`: run lazygit.
- `codex [args]`: run Codex with profile-specific `CODEX_HOME`.
- `opencode [args]`: run OpenCode with profile-specific config, data, cache, and state roots.
- `claude [args]`: run Claude Code with a profile-specific config directory.

Fish is retained only as migration history and is no longer linked by `setup`.

## AI Isolation

- Codex uses `~/.config/codex-<profile>` for config, credentials, logs, sessions,
  and other state.
- OpenCode uses separate XDG config, data, cache, and state roots per profile.
- Claude Code uses `~/.config/claude-<profile>` for settings and local state.
- Claude OAuth credentials on macOS remain in Keychain. Always verify the active
  account with `/status`; do not assume the wrapper changes the Keychain login.

## Safety

- Do not store work credentials or company information in this repository.
- Keep secrets outside Git.
- Verify Git and AI account identity before opening company source code.
- Cursor profile isolation and automated account verification remain pending.
