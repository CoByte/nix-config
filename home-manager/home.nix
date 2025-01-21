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

      (final: prev: {
        vimPlugins = prev.vimPlugins // {
          own-nvim-tree = prev.vimUtils.buildVimPlugin {
            name = "nvim-tree";
            src = inputs.plugin-nvim-tree;
          };
        };
      })
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
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./fish/config.fish;

    functions = {
      "fish_prompt" = builtins.readFile ./fish/functions/fish_prompt.fish;
    };

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
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];

    extraConfig = ''
      ${builtins.readFile ./.tmux.conf}
    '';
  };

  programs.neovim = let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: toLua (builtins.readFile file);
    minimalConfig = name: toLua "require(\"${name}\").setup()";
  in {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs; [
      # random dependencies
      vimPlugins.plenary-nvim

      # useful
      {
        plugin = vimPlugins.which-key-nvim;
        config = minimalConfig "which-key";
      }
      {
        plugin = vimPlugins.nvim-surround;
        config = minimalConfig "nvim-surround";
      }
      {
        plugin = vimPlugins.comment-nvim;
        config = minimalConfig "Comment";
      }
      {
        plugin = vimPlugins.inc-rename-nvim;
        config = minimalConfig "inc_rename";
      }
      {
        plugin = vimPlugins.nvim-autopairs;
        config = toLuaFile ./nvim/plugins/autopairs.lua;
      }
      {
        plugin = vimPlugins.gitsigns-nvim;
        config = minimalConfig "gitsigns";
      }
      {
        plugin = vimPlugins.neodev-nvim;
        config = toLuaFile ./nvim/plugins/neodev.lua;
      }

      # styling
      vimPlugins.nvim-web-devicons
      {
        plugin = vimPlugins.bufferline-nvim;
        config = minimalConfig "bufferline";
      }
      {
        plugin = vimPlugins.lualine-nvim;
        config = toLuaFile ./nvim/plugins/lualine.lua;
      }

      # treesitter
      (vimPlugins.nvim-treesitter.withPlugins (p: [
        p.arduino
        p.ssh-config
        p.zig
        p.make
        p.markdown
        p.yaml
        p.toml
        p.lua
        p.vim
        p.csv
        p.rust
        p.c
        p.cpp
        p.python
        p.r
        p.nix
        p.typst
        p.python
      ]))

      # fuzzy finding
      vimPlugins.telescope-fzf-native-nvim
      vimPlugins.telescope-ui-select-nvim
      {
        plugin = vimPlugins.telescope-nvim;
        config = toLuaFile ./nvim/plugins/telescope.lua;
      }

      # tabs
      vimPlugins.vim-tmux-navigator
      {
        plugin = vimPlugins.own-nvim-tree;
        config = toLuaFile ./nvim/plugins/nvim-tree.lua;
      }

      # autocompletion
      vimPlugins.cmp-buffer
      vimPlugins.cmp-path
      {
        plugin = vimPlugins.nvim-cmp;
        config = toLuaFile ./nvim/plugins/nvim-cmp.lua;
      }

      # snippets
      vimPlugins.cmp_luasnip
      vimPlugins.friendly-snippets
      {
        plugin = vimPlugins.luasnip;
        config = toLuaFile ./nvim/plugins/nvim-cmp.lua;
      }

      # lsp stuff
      vimPlugins.cmp-nvim-lsp
      vimPlugins.lspkind-nvim
      {
        plugin = vimPlugins.nvim-lspconfig;
        config = toLuaFile ./nvim/plugins/lsp/lspconfig.lua;
      }

      # language specific plugins
      # typst
      {
        plugin = vimPlugins.typst-preview-nvim;
        config = minimalConfig "typst-preview";
      }

      # formatting & linting
      {
        plugin = vimPlugins.null-ls-nvim;
        config = toLuaFile ./nvim/plugins/lsp/null-ls.lua;
      }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/keymaps.lua}
    '';
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
    gnome-tweaks
    arduino-ide
    thunderbird

    # random garbage
    neo-cowsay
    toybox
    grc
    nix-prefetch-github
    ripgrep
    arduino-cli
    python314
    clangStdenv
    gnumake42

    # language servers
    nil
    rust-analyzer
    lua-language-server
    libclang
    tinymist
    ruby-lsp
    pyright
    arduino-language-server

    # formatters/linters
    stylua
    black
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
