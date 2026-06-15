function proj --description 'Jump to project and open Neovim'
    if test (count $argv) -lt 1
        echo "Usage: proj <name>" >&2
        return 1
    end

    if not type -q z
        echo "proj: zoxide function 'z' is not available" >&2
        return 1
    end

    z -- $argv[1]
    and nvim .
end
