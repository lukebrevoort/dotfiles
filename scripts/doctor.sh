#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

FAILURES=0
WARNINGS=0

pass() {
  log_success "$*"
}

fail() {
  log_error "$*"
  FAILURES=$((FAILURES + 1))
}

warn() {
  log_warn "$*"
  WARNINGS=$((WARNINGS + 1))
}

check_command() {
  if command_exists "$1"; then
    pass "Command available: $1"
  else
    fail "Missing command: $1"
  fi
}

check_optional_command() {
  if command_exists "$1"; then
    pass "Optional command available: $1"
  else
    warn "Optional command missing: $1"
  fi
}

check_link() {
  local target="$1"
  local expected="$2"
  if [ -L "${target}" ] && [ "$(readlink "${target}")" = "${expected}" ]; then
    pass "Link correct: ${target}"
  else
    fail "Link missing or incorrect: ${target}"
  fi
}

check_mode_700() {
  local path="$1"
  local mode
  mode="$(stat -f '%Lp' "${path}" 2>/dev/null || true)"
  if [ "${mode}" = "700" ]; then
    pass "Private directory permissions: ${path}"
  else
    warn "Expected mode 700 for ${path}; found ${mode:-unknown}"
  fi
}

main() {
  local profile="unknown"
  if [ -r "${HOME}/.config/dotfiles/profile" ]; then
    IFS= read -r profile < "${HOME}/.config/dotfiles/profile"
  fi

  log_info "Profile: ${profile}"
  check_command git
  check_command nvim
  check_command rg
  check_command fd

  if [ "${profile}" = "minimal" ]; then
    check_command zsh
    check_link "${HOME}/.zshrc" "${REPO_ROOT}/zsh/zshrc"
  else
    check_command bash
    check_command starship
    check_command zoxide
    check_optional_command opencode
    check_optional_command codex
    check_optional_command claude
    check_link "${HOME}/.bashrc" "${REPO_ROOT}/bash/bashrc"
    check_link "${HOME}/.config/bash/functions" "${REPO_ROOT}/bash/functions"
    check_link "${HOME}/.config/ghostty" "${REPO_ROOT}/ghostty"
    check_link "${HOME}/.config/aerospace" "${REPO_ROOT}/aerospace"
    check_link "${HOME}/.config/codex-${profile}/config.toml" "${REPO_ROOT}/ai/codex/config.toml"
    check_link "${HOME}/.config/claude-${profile}/settings.json" "${REPO_ROOT}/ai/claude/settings.json"
    check_mode_700 "${HOME}/.config/codex-${profile}"
    check_mode_700 "${HOME}/.config/opencode-${profile}"
    check_mode_700 "${HOME}/.config/claude-${profile}"
    warn "Claude OAuth credentials use macOS Keychain; verify the active account with /status."
  fi

  check_link "${HOME}/.config/nvim" "${REPO_ROOT}/nvim"
  check_link "${HOME}/.config/git/config" "${REPO_ROOT}/git/config"
  check_link "${HOME}/.config/git/ignore" "${REPO_ROOT}/git/ignore"

  if rg -n --hidden -g '!.git/**' -g '!PLAN.md' -g '!scripts/doctor.sh' '/Users/[^/]+/' "${REPO_ROOT}" >/dev/null 2>&1; then
    warn "Repository contains hard-coded macOS home paths. Run: rg '/Users/[^/]+/'"
  else
    pass "No hard-coded macOS home paths found."
  fi

  if [ -f "${REPO_ROOT}/fish/fish_variables" ]; then
    warn "Generated fish/fish_variables still exists locally and should remain ignored."
  fi

  printf '\nDoctor summary: %s failure(s), %s warning(s)\n' "${FAILURES}" "${WARNINGS}"
  [ "${FAILURES}" -eq 0 ]
}

main "$@"
