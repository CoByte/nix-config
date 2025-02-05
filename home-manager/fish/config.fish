set fish_greeting # disable greeting

abbr --add nsf nix-shell --command fish
abbr --add cdgr "cd (git rev-parse --show-toplevel)"

# launch tmux on startup
if type -q tmux
    if not test -n "$TMUX"
        tmux attach-session -t default; or tmux new-session -s default
    end
end
