# Run Codex with profile-specific configuration, credentials, and session state.
codex() {
    local codex_home="$HOME/.config/codex-${DOTFILES_PROFILE:-personal}"
    mkdir -p "$codex_home"
    chmod 700 "$codex_home"
    CODEX_HOME="$codex_home" command codex "$@"
}
