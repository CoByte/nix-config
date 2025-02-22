{ pkgs, lib, config, ...}:

{
  config = {
    home.packages = let
      open = pkgs.writeShellApplication {
        name = "git-visit";
        runtimeInputs = [ config.programs.git.package ];
        text = ''
          git remote -v | awk '/origin.*push/ {print $2}' |  sed -n "s/http.*/\0/p;s/.*@\(.*\):\(.*\)\.git/https:\/\/\1\/\2/p" | xargs xdg-open
        '';
      };
    in
    [ open ];

    programs.git.aliases."visit" = "visit";
  };
}
