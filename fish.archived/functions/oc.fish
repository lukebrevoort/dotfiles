function oc --description 'Run opencode'
    if test -x /opt/homebrew/bin/opencode
        command /opt/homebrew/bin/opencode $argv
        return $status
    end

    command opencode $argv
end
