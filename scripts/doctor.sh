#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=scripts/lib/deploy.sh
source "${SCRIPT_DIR}/lib/deploy.sh"

FAILURES=0
WARNINGS=0
PROFILE=""
INSTALL_AI="${INSTALL_AI:-1}"

usage() {
  cat <<'EOF'
Usage: scripts/doctor.sh [--profile work|personal|minimal] [--skip-ai]
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --profile)
        PROFILE="${2:-}"
        shift 2
        ;;
      --skip-ai)
        INSTALL_AI=0
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done
}

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

check_installed_path() {
  local target="$1"
  local source="$2"

  if paths_match "${source}" "${target}"; then
    pass "Installed config current: ${target}"
  elif [ -e "${target}" ] || [ -L "${target}" ]; then
    warn "Installed config differs from repository: ${target}"
  else
    fail "Installed config missing: ${target}"
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
  local profile="${PROFILE:-unknown}"

  parse_args "$@"
  profile="${PROFILE:-unknown}"
  if [ -z "${PROFILE}" ] && [ -r "${HOME}/.config/dotfiles/profile" ]; then
    IFS= read -r profile < "${HOME}/.config/dotfiles/profile"
  fi

  log_info "Profile: ${profile}"
  check_command git
  check_command nvim
  check_command rg
  check_command fd

  if [ "${profile}" = "minimal" ]; then
    check_command zsh
    check_installed_path "${HOME}/.zshrc" "${REPO_ROOT}/zsh/zshrc"
  else
    check_command bash
    check_command starship
    check_command zoxide
    check_optional_command opencode
    check_optional_command codex
    check_optional_command claude
    check_installed_path "${HOME}/.bashrc" "${REPO_ROOT}/bash/bashrc"
    check_installed_path "${HOME}/.blerc" "${REPO_ROOT}/bash/blerc"
    check_installed_path "${HOME}/.config/bash" "${REPO_ROOT}/bash"
    check_installed_path "${HOME}/.config/ghostty" "${REPO_ROOT}/ghostty"
    check_installed_path "${HOME}/.config/aerospace" "${REPO_ROOT}/aerospace"
    if [ "${INSTALL_AI:-1}" -eq 1 ]; then
      check_installed_path "${HOME}/.codex/config.toml" "${REPO_ROOT}/ai/codex/config.toml"
      check_installed_path "${HOME}/.claude/settings.json" "${REPO_ROOT}/ai/claude/settings.json"
      check_mode_700 "${HOME}/.codex"
      check_mode_700 "${HOME}/.config/opencode"
      check_mode_700 "${HOME}/.claude"
      warn "Claude OAuth credentials use macOS Keychain; verify the active account with /status."
    else
      log_info "AI configuration checks skipped."
    fi
  fi

  check_installed_path "${HOME}/.config/nvim" "${REPO_ROOT}/nvim"
  check_installed_path "${HOME}/.config/git/config" "${REPO_ROOT}/git/config"
  check_installed_path "${HOME}/.config/git/ignore" "${REPO_ROOT}/git/ignore"

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
