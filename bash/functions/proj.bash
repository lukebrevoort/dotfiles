# Jump to project directory and open Neovim
proj() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: proj <name>" >&2
        return 1
    fi

    if ! type z &>/dev/null; then
        echo "proj: zoxide function 'z' is not available" >&2
        return 1
    fi

    z "$1" && nvim .
}
