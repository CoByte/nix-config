{pkgs}: {
  image = ../assets/wallpaper.png;
  base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

  fonts = {
    monospace = {
      package = pkgs.jetbrains-mono;
      name = "Jetbrains Mono";
    };
  };
}
