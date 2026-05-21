{
  pkgs,
  lib,
  config,
  ...
}: let
  target = "/home/raine/Documents/Books";
  library = "/home/raine/Calibre";
in {
  # watches the synced ebook folder and automatically loads it into calibre
  systemd.user.paths.calibre-watch = {
    Unit = {
      Description = "Watch ebooks folder";
    };
    Path = {
      PathChanged = target;
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  systemd.user.services.calibre-watch = {
    Unit = {
      Description = "Import ebook library into Calibre library";
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${pkgs.calibre}/bin/calibredb add ${target} --library-path=${library}";
    };
  };
}
