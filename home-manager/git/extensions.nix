{ pkgs, lib, config, ...}:

{
  config = {
    home.packages = let
      open = pkgs.writeShellApplication {
        name = "git-open";
        runtimeInputs = [ config.programs.git.package ];
        text = ''
          remote=$(git remote -v | awk '/origin/.*push/ {print $2}')
        '';
      };
    in
    [ open ];

    programs.git.aliases."open" = "open";
  };
}
