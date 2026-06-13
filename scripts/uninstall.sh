#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=scripts/lib/deploy.sh
source "${SCRIPT_DIR}/lib/deploy.sh"

PROFILE=""
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: scripts/uninstall.sh --profile work|personal|minimal [--dry-run]

Removes only installed files that still match this dotfiles repository.
Timestamped backups are not restored automatically.
EOF
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

  remove_managed_path "${REPO_ROOT}/nvim" "${HOME}/.config/nvim"
  remove_managed_path "${REPO_ROOT}/git/config" "${HOME}/.config/git/config"
  remove_managed_path "${REPO_ROOT}/git/ignore" "${HOME}/.config/git/ignore"
  remove_managed_path "${REPO_ROOT}/starship/starship.toml" "${HOME}/.config/starship.toml"

  if [ "${PROFILE}" = "minimal" ]; then
    remove_managed_path "${REPO_ROOT}/zsh/zshrc" "${HOME}/.zshrc"
  else
    remove_managed_path "${REPO_ROOT}/bash/bashrc" "${HOME}/.bashrc"
    remove_managed_path "${REPO_ROOT}/bash/profile" "${HOME}/.bash_profile"
    remove_managed_path "${REPO_ROOT}/bash/blerc" "${HOME}/.blerc"
    remove_managed_path "${REPO_ROOT}/bash" "${HOME}/.config/bash"
    remove_managed_path "${REPO_ROOT}/ghostty" "${HOME}/.config/ghostty"
    remove_managed_path "${REPO_ROOT}/aerospace" "${HOME}/.config/aerospace"
    remove_managed_path "${REPO_ROOT}/ai/codex/config.toml" "${HOME}/.codex/config.toml"
    remove_managed_path "${REPO_ROOT}/ai/codex/AGENTS.md" "${HOME}/.codex/AGENTS.md"
    remove_managed_path "${REPO_ROOT}/ai/claude/settings.json" "${HOME}/.claude/settings.json"
    remove_managed_path "${REPO_ROOT}/ai/claude/CLAUDE.md" "${HOME}/.claude/CLAUDE.md"
    if [ "${PROFILE}" = "work" ]; then
      remove_managed_path "${REPO_ROOT}/ai/opencode/work.json" "${HOME}/.config/opencode/opencode.json"
    else
      remove_managed_path "${REPO_ROOT}/opencode/opencode.json" "${HOME}/.config/opencode/opencode.json"
      remove_managed_path "${REPO_ROOT}/opencode/AGENTS.md" "${HOME}/.config/opencode/AGENTS.md"
      remove_managed_path "${REPO_ROOT}/opencode/agent" "${HOME}/.config/opencode/agent"
      remove_managed_path "${REPO_ROOT}/opencode/skills" "${HOME}/.config/opencode/skills"
    fi
  fi

  log_warn "Profile state and credentials were left in place."
  log_warn "Review timestamped .bak files manually before restoring them."
}

main "$@"
