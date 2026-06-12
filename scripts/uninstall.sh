#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

PROFILE=""
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: scripts/uninstall.sh --profile work|personal|minimal [--dry-run]

Removes only symlinks that currently point into this dotfiles repository.
Timestamped backups are not restored automatically.
EOF
}

remove_owned_link() {
  local target="$1"
  local destination

  [ -L "${target}" ] || return 0
  destination="$(readlink "${target}")"
  case "${destination}" in
    "${REPO_ROOT}"/*)
      run rm "${target}"
      log_success "Removed ${target}"
      ;;
    *)
      log_warn "Leaving unrelated symlink: ${target} -> ${destination}"
      ;;
  esac
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --profile)
        [ "$#" -ge 2 ] || die "--profile requires a value"
        PROFILE="$2"
        shift 2
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown option: $1"
        ;;
    esac
  done

  case "${PROFILE}" in
    work|personal|minimal) ;;
    *) die "Specify --profile work, personal, or minimal" ;;
  esac
}

main() {
  parse_args "$@"
  export DRY_RUN

  remove_owned_link "${HOME}/.config/nvim"
  remove_owned_link "${HOME}/.config/git/config"
  remove_owned_link "${HOME}/.config/git/ignore"
  remove_owned_link "${HOME}/.config/starship.toml"

  if [ "${PROFILE}" = "minimal" ]; then
    remove_owned_link "${HOME}/.zshrc"
  else
    remove_owned_link "${HOME}/.bashrc"
    remove_owned_link "${HOME}/.bash_profile"
    remove_owned_link "${HOME}/.config/bash/functions"
    remove_owned_link "${HOME}/.config/ghostty"
    remove_owned_link "${HOME}/.config/aerospace"
    remove_owned_link "${HOME}/.config/codex-${PROFILE}/config.toml"
    remove_owned_link "${HOME}/.config/codex-${PROFILE}/AGENTS.md"
    remove_owned_link "${HOME}/.config/claude-${PROFILE}/settings.json"
    remove_owned_link "${HOME}/.config/claude-${PROFILE}/CLAUDE.md"
    remove_owned_link "${HOME}/.config/opencode-${PROFILE}/opencode/opencode.json"
  fi

  log_warn "Profile state and credentials were left in place."
  log_warn "Review timestamped .bak files manually before restoring them."
}

main "$@"
