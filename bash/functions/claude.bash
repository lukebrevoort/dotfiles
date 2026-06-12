# Separate Claude settings and local state by profile. On macOS, OAuth
# credentials remain in Keychain, so verify the active account with /status.
claude() {
    local claude_home="$HOME/.config/claude-${DOTFILES_PROFILE:-personal}"
    mkdir -p "$claude_home"
    chmod 700 "$claude_home"
    CLAUDE_CONFIG_DIR="$claude_home" command claude "$@"
}
