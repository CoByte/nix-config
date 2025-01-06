# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home.username = "raine";
  home.homeDirectory = "/home/raine";

  # Add stuff for your user as you see fit:
  programs.kitty.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # disable greeting

      # launch tmux on startup
      if type -q tmux
          if not test -n "$TMUX"
              tmux attach-session -t default; or tmux new-session -s default
          end
      end
    '';
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    historyLimit = 100000;
    shortcut = "a";

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      # enable mouse
      set-option -g mouse on

      # unbind old splits
      unbind %
      unbind '"'

      # simple split-pane commands
      bind \\ split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'
      bind c split-window -c '#{pane_current_path}'

      # fullscreen
      bind -r m resize-pane -Z
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.helix = {
    enable = true;

    settings = {
      editor.cursor-shape = {
        normal = "block";
	insert = "bar";
	select = "underline";
      };
    };

    languages.language = [
      {
        name = "nix";
	auto-format = true;
	formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
    ];
  };

  home.packages = with pkgs; [
    # applications
    spotify
    discord
    obsidian

    # random garbage
    neo-cowsay
    toybox
    gnome-tweaks
    grc
    nix-prefetch-github
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "cobyte";
    userEmail = "owen356wh@gmail.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
