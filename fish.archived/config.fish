set -gx EDITOR nvim

if test -d /opt/homebrew/bin
    if not contains /opt/homebrew/bin $PATH
        set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
    end
end

if test -f "$HOME/.env.opencode"
    set -l allowed_prefixes OPENCODE_ NOTION_ ANTHROPIC_ OPENAI_ GITHUB_ GEMINI_ MCP_ API_

    while read -l line
        set line (string trim -- $line)

        if test -z "$line"
            continue
        end

        if string match -qr '^#' -- $line
            continue
        end

        set line (string replace -r '^export\s+' '' -- $line)

        if not string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' -- $line
            continue
        end

        set -l parts (string split -m 1 '=' -- $line)
        set -l key $parts[1]
        set -l value ''

        if test "$key" = PATH; or test "$key" = fish_user_paths
            continue
        end

        set -l is_allowed 0
        for prefix in $allowed_prefixes
            if string match -q -- "$prefix*" $key
                set is_allowed 1
                break
            end
        end

        if test $is_allowed -ne 1
            continue
        end

        if test (count $parts) -ge 2
            set value $parts[2]
        end

        set -l first_char (string sub -s 1 -l 1 -- $value)
        set -l last_char (string sub -s -1 -l 1 -- $value)
        if test "$first_char" = '"'; and test "$last_char" = '"'
            set value (string sub -s 2 -e -1 -- $value)
        else if test "$first_char" = "'"; and test "$last_char" = "'"
            set value (string sub -s 2 -e -1 -- $value)
        end

        set -gx $key $value
    end < "$HOME/.env.opencode"
end

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end
