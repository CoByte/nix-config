{ pkgs, lib, config, ... }:

let
  inherit (lib.trivial) flip;
  T = lib.types;
in

{

  options.git.common-users = lib.mkOption {
    description = "list of users to easily switch between";
    type = T.attrsOf (T.attrsOf (T.either T.bool (T.attrsOf T.str)));
  };

  options.git.common-users-default = lib.mkOption {
    description = "default user from the list of common users";
    type = T.nullOr T.str;
    default = null;
  };

  config =
    let
      common-users         = config.git.common-users;
      common-users-default = config.git.common-users-default;
      stripGithub = obj: builtins.removeAttrs obj [ "github" ];
      makeIni     = _: gitConfig: lib.generators.toGitINI (stripGithub gitConfig);
      iniFiles    = builtins.mapAttrs makeIni common-users;
    in

    {
      # if a default user is specified, add config for it
      programs.git.extraConfig =
        lib.mkIf (!(builtins.isNull common-users))
          (stripGithub common-users.${common-users-default});

      # add per-user git config files
      xdg.configFile = flip lib.attrsets.concatMapAttrs iniFiles
        (username: ini: {
          "git/${username}.gitconfig".text = ini;
        });

      # add per-user includes
      programs.git.includes = flip builtins.concatMap (builtins.attrNames common-users) (
        username:
        let
          userConfig = common-users.${username};
          hasGithub = userConfig.github or false;
          github-username = userConfig.user.name
            or (throw "${username} enabled github and so must set a user.name");
        in
        if !hasGithub then [] else
          flip builtins.map [
            # SSH style
            "git@github.com:${github-username}/**"
            # HTTPS style
            "https://github.com/${github-username}/**"
            # HTTPS style with GitHub token
            "https://${github-username}:*@github.com/**"
          ] (scheme: {
            condition = "hasconfig:remote.*.url:${scheme}";
            path = "${config.xdg.configHome}/git/${username}.gitconfig";
          })
      );

      # add script to quickly change between users for a repository
      home.packages =
        let
          users = builtins.attrNames common-users;
          usersList = pkgs.writeText "userlist" (lib.concatLines users);
          package =
            if builtins.length users <= 1 then
              pkgs.writeShellScriptBin "git-select-user" ''
                echo "There are not enough users to switch between."
                exit 1
              ''
            else
              pkgs.writeShellApplication {
                name = "git-select-user";
                runtimeInputs = [ pkgs.fzf config.programs.git.package ];
                text = ''
                  git rev-parse # does nothing, but fails early if not in a git repo.
                  choice="$(fzf <${usersList})"
                  git config include.path "${config.xdg.configHome}/git/$choice.gitconfig"
                  echo "Switched to user $choice."
                '';
              };
        in
        [ package ];

      # ensures shell autocomplete knows the git select-user subcommand exists
      programs.git.aliases."select-user" = "select-user";
    };

}
