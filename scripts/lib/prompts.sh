#!/usr/bin/env bash

confirm() {
  local prompt="$1"
  local default="${2:-no}"
  local suffix="[y/N]"
  local reply

  if [ "${NON_INTERACTIVE:-0}" -eq 1 ]; then
    [ "${default}" = "yes" ]
    return
  fi

  [ "${default}" = "yes" ] && suffix="[Y/n]"
  printf '%s %s ' "${prompt}" "${suffix}"
  IFS= read -r reply
  [ -z "${reply}" ] && reply="${default}"

  case "${reply}" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

ask_value() {
  local prompt="$1"
  local default="${2:-}"
  local reply

  if [ "${NON_INTERACTIVE:-0}" -eq 1 ]; then
    printf '%s' "${default}"
    return 0
  fi

  if [ -n "${default}" ]; then
    printf '%s [%s]: ' "${prompt}" "${default}" >&2
  else
    printf '%s: ' "${prompt}" >&2
  fi
  IFS= read -r reply
  printf '%s' "${reply:-$default}"
}

choose_profile() {
  local reply

  if [ "${NON_INTERACTIVE:-0}" -eq 1 ]; then
    printf 'minimal'
    return 0
  fi

  printf '%s\n' "Select a setup profile:" >&2
  printf '%s\n' "  1) work     Employer identity and isolated AI state" >&2
  printf '%s\n' "  2) personal Personal identity and isolated AI state" >&2
  printf '%s\n' "  3) minimal  Apple Terminal + Zsh + Neovim" >&2
  printf 'Choice [1]: ' >&2
  IFS= read -r reply

  case "${reply:-1}" in
    1|work) printf 'work' ;;
    2|personal) printf 'personal' ;;
    3|minimal) printf 'minimal' ;;
    *) return 1 ;;
  esac
}
