# Jump to project, open Neovim, and spawn OpenCode Ghostty window
dev() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: dev <name>" >&2
        return 1
    fi

    if ! type z &>/dev/null; then
        echo "dev: zoxide function 'z' is not available" >&2
        return 1
    fi

    z "$1" || return 1

    if command -v open &>/dev/null; then
        open -a Ghostty --args --new-window --working-directory "$(pwd)" -e /usr/bin/env bash -lc 'opencode' >/dev/null 2>&1 &
    fi

    nvim .
}
