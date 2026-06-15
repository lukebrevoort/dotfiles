#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=scripts/lib/prompts.sh
source "${SCRIPT_DIR}/lib/prompts.sh"

install_homebrew() {
  if command_exists brew; then
    return 0
  fi

  if [ "${NON_INTERACTIVE:-0}" -eq 1 ]; then
    die "Homebrew is required. Install it before non-interactive setup."
  fi

  if ! confirm "Homebrew is missing. Open the official installation command?" "yes"; then
    die "Homebrew is required for package installation."
  fi

  log_info "Install Homebrew from https://brew.sh, then rerun ./setup."
  if command_exists open; then
    run open "https://brew.sh"
  fi
  exit 2
}

install_bundle() {
  local brewfile="$1"
  log_info "Installing packages from $(basename "${brewfile}")"
  run brew bundle --file "${brewfile}" --no-upgrade
}

install_optional_bundle() {
  local brewfile="$1"
  log_info "Installing optional packages from $(basename "${brewfile}")"

  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    run brew bundle --file "${brewfile}" --no-upgrade
    return 0
  fi

  if ! brew bundle --file "${brewfile}" --no-upgrade; then
    log_warn "Some optional desktop or AI packages failed. Core setup will continue."
    log_warn "Rerun later with: brew bundle --file ${brewfile}"
  fi
}

install_codex() {
  if command_exists codex; then
    log_info "Codex is already installed."
    return 0
  fi

  if [ "${NON_INTERACTIVE:-0}" -eq 1 ]; then
    log_warn "Codex is not installed; skipping its interactive official installer."
    return 0
  fi

  if confirm "Install Codex using OpenAI's official installer?" "yes"; then
    if [ "${DRY_RUN:-0}" -eq 1 ]; then
      printf '+ curl -fsSL https://chatgpt.com/codex/install.sh | sh\n'
    else
      curl -fsSL https://chatgpt.com/codex/install.sh | sh
    fi
  fi
}

main() {
  install_homebrew
  install_bundle "${REPO_ROOT}/Brewfile"

  if [ "${PROFILE_DESKTOP}" = "full" ]; then
    install_optional_bundle "${REPO_ROOT}/Brewfile.full"
  fi

  if [ "${PROFILE_INSTALL_AI}" = "yes" ]; then
    install_codex
  fi
}

main "$@"
