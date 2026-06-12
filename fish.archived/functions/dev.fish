function dev --description 'Jump to project, open Neovim, and spawn Opencode Ghostty window'
    if test (count $argv) -lt 1
        echo "Usage: dev <name>" >&2
        return 1
    end

    if not type -q z
        echo "dev: zoxide function 'z' is not available" >&2
        return 1
    end

    z -- $argv[1]
    or return 1

    if type -q open
        set -l fish_bin fish
        if test -x /opt/homebrew/bin/fish
            set fish_bin /opt/homebrew/bin/fish
        end

        set -l opencode_cmd opencode
        if test -x /opt/homebrew/bin/opencode
            set opencode_cmd /opt/homebrew/bin/opencode
        end

        command open -na Ghostty --args --working-directory (pwd) -e $fish_bin -lc "$opencode_cmd" >/dev/null 2>&1 &
    end

    nvim .
end
