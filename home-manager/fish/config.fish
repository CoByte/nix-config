set fish_greeting # disable greeting

# abbreviations
abbr --add nsf nix-shell --command fish
abbr --add cdgr "cd (git rev-parse --show-toplevel)"

# env
set -x FZF_DEFAULT_OPTS '--height 40% --tmux bottom,40% --layout reverse --border top'
set -x FZF_CTRL_T_OPTS '--walker-skip .git,.steam'
set -x FZF_ALT_C_OPTS '--walker-skip .git,.steam'

# launch tmux on startup
if type -q tmux
    if not test -n "$TMUX"
        tmux attach-session -t default; or tmux new-session -s default
    end
end
