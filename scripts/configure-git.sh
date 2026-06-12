#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=scripts/lib/prompts.sh
source "${SCRIPT_DIR}/lib/prompts.sh"

write_identity() {
  local identity="$1"
  local path="${HOME}/.config/dotfiles/git-${identity}.inc"
  local default_name=""
  local default_email=""
  local name
  local email

  if [ -f "${path}" ]; then
    log_info "${identity} Git identity already exists at ${path}"
    return 0
  fi

  if [ "${NON_INTERACTIVE:-0}" -eq 1 ]; then
    log_warn "Skipping ${identity} Git identity prompt in non-interactive mode."
    return 0
  fi

  default_name="$(git config --global user.name 2>/dev/null || true)"
  default_email="$(git config --global user.email 2>/dev/null || true)"
  name="$(ask_value "${identity} Git name" "${default_name}")"
  email="$(ask_value "${identity} Git email" "${default_email}")"

  if [ -z "${name}" ] || [ -z "${email}" ]; then
    log_warn "Incomplete ${identity} identity; no file written."
    return 0
  fi

  ensure_dir "$(dirname "${path}")"
  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    printf '+ write Git identity to %q\n' "${path}"
    return 0
  fi

  umask 077
  git config --file "${path}" user.name "${name}"
  git config --file "${path}" user.email "${email}"
  log_success "Configured ${identity} Git identity."
}

main() {
  case "${PROFILE_NAME}" in
    work) write_identity work ;;
    personal) write_identity personal ;;
    minimal) log_info "Minimal profile leaves Git identity unchanged." ;;
  esac
}

main "$@"
