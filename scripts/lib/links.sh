#!/usr/bin/env bash

backup_path() {
  local target="$1"
  local backup="${target}.bak.$(timestamp)"

  run mv "${target}" "${backup}"
  log_warn "Backed up ${target} to ${backup}"
}

link_path() {
  local source="$1"
  local target="$2"

  if [ ! -e "${source}" ] && [ ! -L "${source}" ]; then
    log_warn "Skipping missing source: ${source}"
    return 0
  fi

  ensure_dir "$(dirname "${target}")"

  if [ -L "${target}" ]; then
    if [ "$(readlink "${target}")" = "${source}" ]; then
      log_info "Already linked: ${target}"
      return 0
    fi
    run rm -f "${target}"
  elif [ -e "${target}" ]; then
    backup_path "${target}"
  fi

  run ln -s "${source}" "${target}"
  log_success "Linked ${target}"
}
