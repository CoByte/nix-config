set fish_greeting # disable greeting

# abbreviations
abbr --add nsf nix-shell --command fish
abbr --add cdgr "cd (git rev-parse --show-toplevel)"

# make fzf work properly w/ tmux
set -x FZF_DEFAULT_OPTS '--height 40% --tmux bottom,40% --layout reverse --border top'

# launch tmux on startup
if type -q tmux
    if not test -n "$TMUX"
        tmux attach-session -t default; or tmux new-session -s default
    end
end
