{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git

    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
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
    config = {
      allowUnfree = true;
    };
  };

  home.username = "raine";
  home.homeDirectory = "/home/raine";

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

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

    minimalPlugin = pkg: name: {
      plugin = pkg;
      config = minimalConfig name;
    };
    # this is a terrible name, but it makes the lines line up :)
    configdPlugin = pkg: path: {
      plugin = pkg;
      config = toLuaFile path;
    };

    vp = pkgs.vimPlugins;
  in {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = [
      # random dependencies
      vp.plenary-nvim

      # useful
      (minimalPlugin vp.which-key-nvim "which-key")
      (minimalPlugin vp.nvim-surround "nvim-surround")
      (minimalPlugin vp.comment-nvim "Comment")
      (minimalPlugin vp.inc-rename-nvim "inc_rename")
      (configdPlugin vp.nvim-autopairs ./nvim/plugins/autopairs.lua)
      (minimalPlugin vp.gitsigns-nvim "gitsigns")
      (configdPlugin vp.neodev-nvim ./nvim/plugins/neodev.lua)
      (minimalPlugin vp.wrapping-nvim "wrapping")
      (minimalPlugin vp.git-conflict-nvim "git-conflict")
      vp.vim-sleuth
      vp.vim-exchange

      # styling
      vp.nvim-web-devicons
      (minimalPlugin vp.bufferline-nvim "bufferline")
      (configdPlugin vp.lualine-nvim ./nvim/plugins/lualine.lua)

      # treesitter
      {
        plugin = vp.nvim-treesitter.withPlugins (p: [
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
          p.just
          p.http
          p.css
          p.javascript
          p.json
          p.glsl
        ]);
        config = toLuaFile ./nvim/plugins/treesitter.lua;
      }
      (configdPlugin vp.nvim-treesitter-textsubjects ./nvim/plugins/treesitter-textsubjects.lua)

      # fuzzy finding
      vp.telescope-fzf-native-nvim
      vp.telescope-ui-select-nvim
      (configdPlugin vp.telescope-nvim ./nvim/plugins/telescope.lua)

      # tabs
      vp.vim-tmux-navigator
      (configdPlugin vp.own-nvim-tree ./nvim/plugins/nvim-tree.lua)

      # autocompletion
      vp.cmp-buffer
      vp.cmp-path
      (configdPlugin vp.nvim-cmp ./nvim/plugins/nvim-cmp.lua)

      # snippets
      vp.cmp_luasnip
      vp.friendly-snippets
      (configdPlugin vp.luasnip ./nvim/plugins/nvim-cmp.lua)

      # lsp stuff
      vp.cmp-nvim-lsp
      vp.lspkind-nvim
      (configdPlugin vp.nvim-lspconfig ./nvim/plugins/lsp/lspconfig.lua)

      # language specific plugins
      # typst
      (minimalPlugin vp.typst-preview-nvim "typst-preview")

      # formatting & linting
      (configdPlugin vp.null-ls-nvim ./nvim/plugins/lsp/null-ls.lua)
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/keymaps.lua}
    '';
  };

  home.packages = with pkgs; [
    # applications
    spotify
    discord
    obsidian
    gnome-tweaks
    arduino-ide
    thunderbird
    obs-studio

    # random garbage
    neo-cowsay
    fzf
    ranger
    toybox
    grc
    nix-prefetch-github
    ripgrep
    arduino-cli
    python314
    clangStdenv
    gnumake42
    xclip
    typst

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

  programs.home-manager.enable = true;

  programs.git.enable = true;
  
  git.common-users = {
    cobyte = {
      github = true;
      user.name = "cobyte";
      user.email = "32520644+CoByte@users.noreply.github.com";
      core.sshCommand = "ssh -i ~/.ssh/id_rsa";
    };
    rainewheary = {
      github = true;
      user.name = "rwheary";
      user.email = "130535726+rainewheary@users.noreply.github.com";
      core.sshCommand = "ssh -i ~/.ssh/id_rsa_OSU";
    };
  };

  git.common-users-default = "cobyte";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
