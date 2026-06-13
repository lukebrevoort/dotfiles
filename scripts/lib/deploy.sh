#!/usr/bin/env bash

paths_match() {
  local source="$1"
  local target="$2"

  [ ! -L "${target}" ] || return 1

  if [ -d "${source}" ]; then
    [ -d "${target}" ] && diff -qr "${source}" "${target}" >/dev/null 2>&1
  else
    [ -f "${target}" ] && cmp -s "${source}" "${target}"
  fi
}

backup_target() {
  local target="$1"
  local backup="${target}.bak.$(timestamp)"

  run mv "${target}" "${backup}"
  if [ "${DRY_RUN:-0}" -eq 0 ]; then
    case "$(basename "${target}")" in
      .bashrc|.bash_profile|.zshrc|*.env)
        chmod 600 "${backup}"
        ;;
    esac
  fi
  log_warn "Backed up ${target} to ${backup}"
}

install_path() {
  local source="$1"
  local target="$2"
  local staging

  if [ ! -e "${source}" ]; then
    log_warn "Skipping missing source: ${source}"
    return 0
  fi

  if paths_match "${source}" "${target}"; then
    log_info "Already current: ${target}"
    return 0
  fi

  ensure_dir "$(dirname "${target}")"

  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    [ -e "${target}" ] || [ -L "${target}" ] || true
    if [ -e "${target}" ] || [ -L "${target}" ]; then
      printf '+ backup %q\n' "${target}"
    fi
    printf '+ copy %q to %q\n' "${source}" "${target}"
    return 0
  fi

  staging="${target}.install.$(timestamp).$$"
  if [ -d "${source}" ]; then
    cp -R "${source}" "${staging}"
  else
    cp "${source}" "${staging}"
  fi

  if [ -e "${target}" ] || [ -L "${target}" ]; then
    backup_target "${target}"
  fi

  mv "${staging}" "${target}"
  log_success "Installed ${target}"
}

remove_managed_path() {
  local source="$1"
  local target="$2"

  if [ ! -e "${target}" ] && [ ! -L "${target}" ]; then
    return 0
  fi

  if paths_match "${source}" "${target}"; then
    run rm -rf "${target}"
    log_success "Removed ${target}"
  else
    log_warn "Leaving modified or unrelated path: ${target}"
  fi
}
