---
name: xcodebuildmcp-mcp
description: "Use when working with Apple projects via the XcodeBuildMCP MCP server: discover Xcode projects/schemes, set session defaults, build/test/run on Simulator or device, capture logs, and automate Simulator UI (snapshot/tap/type/screenshot)."
---

# XcodeBuildMCP (MCP)

Prefer XcodeBuildMCP tools over raw `xcodebuild`, `xcrun`, or `simctl`.

## Non-negotiables (prevents most failures)

- Call `session_show_defaults` first; then call `session_set_defaults` to fill missing values before build/test/run/log tools.
- Do not guess scheme/project/workspace/simulator IDs; use discovery tools first (`discover_projs`, `list_schemes`, `list_sims`).
- Pick the minimal tool for the intent:
  - `build_run_sim` for run/launch intent.
  - `build_sim` for compile-only feedback.
  - `test_sim` for tests.
  - `install_app_sim` + `launch_app_sim` (or `launch_app_logs_sim`) when you already have an `.app`.
- Do not chain `build_sim` then `build_run_sim` unless explicitly requested.

## Bootstrapping defaults (do this once per workspace/session)

1. `session_show_defaults`
2. If missing `projectPath`/`workspacePath`:
   - `discover_projs` with `workspaceRoot` set to the repo/workspace root.
   - Choose a single Xcode container to work with (prefer `.xcworkspace` when present).
3. If missing `scheme`:
   - `list_schemes` for the chosen `projectPath`/`workspacePath`.
   - Choose the app scheme for run, the test scheme for tests.
4. If missing `simulatorId`/`simulatorName`:
   - `list_sims`, choose a simulator (use the Booted one if already running).
5. `session_set_defaults` with the chosen values. Optionally pass `persist=true` to write to `.xcodebuildmcp/config.yaml`.

Session default keys you can set:
`projectPath`, `workspacePath`, `scheme`, `configuration`, `simulatorName`, `simulatorId`, `simulatorPlatform`, `useLatestOS`, `derivedDataPath`, `preferXcodebuild`, `bundleId`, `deviceId`.

## Core recipes

Build + run on Simulator:
- Ensure defaults exist, then call `build_run_sim`.

Compile only (no launch):
- Ensure defaults exist, then call `build_sim`.

Run tests on Simulator:
- Ensure defaults exist (including test scheme), then call `test_sim`.

Capture logs from a running app:
- Start: `start_sim_log_cap` with `simulatorId` + `bundleId`.
- Stop: `stop_sim_log_cap` with `logSessionId` returned by the start tool.

Launch app and capture logs in one step (relaunches app):
- `launch_app_logs_sim` with `bundleId` + (`simulatorId` or `simulatorName`).

UI automation (Simulator):
- `snapshot_ui` with `simulatorId`.
- Prefer `tap` by `id` (AXUniqueId) or `label`; use `x`+`y` only as a fallback.
- Use `screenshot` for visual verification.

## Troubleshooting

- Missing tools: call `manage_workflows` (some workflows are disabled by default in some clients).
- Weird failures / environment issues: call `doctor` and use its output to adjust configuration.

## Parameter cheat sheet (most-used tools)

`discover_projs`
- Required: `workspaceRoot`
- Optional: `scanPath` (defaults to `.`), `maxDepth` (defaults to 5)

`list_schemes`
- One of: `projectPath` | `workspacePath`

`list_sims`
- Optional: `enabled`

`build_run_sim` / `build_sim`
- Required: `scheme`
- One of: `projectPath` | `workspacePath`
- One of: `simulatorId` | `simulatorName`
- Optional: `configuration`, `derivedDataPath`, `extraArgs` (string[]), `useLatestOS`, `preferXcodebuild`

`start_sim_log_cap`
- Required: `simulatorId` (UUID), `bundleId`
- Optional: `captureConsole` (boolean), `subsystemFilter` (`app` | `all` | `swiftui` | [subsystems])

`stop_sim_log_cap`
- Required: `logSessionId`

`tap`
- Required: `simulatorId`
- Provide exactly one targeting mode:
  - `id` (recommended), or
  - `label`, or
  - `x`+`y` (fallback)
- Optional: `preDelay`, `postDelay` (seconds)
