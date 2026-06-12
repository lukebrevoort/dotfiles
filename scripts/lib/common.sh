#!/usr/bin/env bash

color_enabled() {
  [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]
}

color() {
  local code="$1"
  shift
  if color_enabled; then
    printf '\033[%sm%s\033[0m\n' "${code}" "$*"
  else
    printf '%s\n' "$*"
  fi
}

log_info() {
  color "0;34" "[INFO] $*"
}

log_success() {
  color "0;32" "[OK] $*"
}

log_warn() {
  color "1;33" "[WARN] $*" >&2
}

log_error() {
  color "0;31" "[ERROR] $*" >&2
}

die() {
  log_error "$*"
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

print_command() {
  printf '+'
  printf ' %q' "$@"
  printf '\n'
}

run() {
  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    print_command "$@"
    return 0
  fi
  "$@"
}

ensure_dir() {
  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    [ -d "$1" ] || print_command mkdir -p "$1"
    return 0
  fi
  mkdir -p "$1"
}

timestamp() {
  date +%Y%m%d%H%M%S
}
