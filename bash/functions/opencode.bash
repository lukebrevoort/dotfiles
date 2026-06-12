# Run OpenCode with isolated XDG config, credentials, cache, and state.
opencode() {
    local profile="${DOTFILES_PROFILE:-personal}"
    local config_home="$HOME/.config/opencode-$profile"
    local data_home="$HOME/.local/share/opencode-$profile"
    local cache_home="$HOME/.cache/opencode-$profile"
    local state_home="$HOME/.local/state/opencode-$profile"

    mkdir -p "$config_home" "$data_home" "$cache_home" "$state_home"
    chmod 700 "$config_home" "$data_home" "$cache_home" "$state_home"

    XDG_CONFIG_HOME="$config_home" \
        XDG_DATA_HOME="$data_home" \
        XDG_CACHE_HOME="$cache_home" \
        XDG_STATE_HOME="$state_home" \
        command opencode "$@"
}
