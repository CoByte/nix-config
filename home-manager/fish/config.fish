set fish_greeting # disable greeting

abbr --add nsf nix-shell --command fish

# launch tmux on startup
if type -q tmux
    if not test -n "$TMUX"
        tmux attach-session -t default; or tmux new-session -s default
    end
end
