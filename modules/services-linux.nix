{
  flake.modules.homeManager.desktop =
    { pkgs, lib, ... }:
    {
      systemd.user.services = lib.mkIf pkgs.stdenv.isLinux {
        flameshot = {
          Unit.Description = "";
          Service.Type = "simple";
          Service.ExecStart = "${lib.getExe pkgs.flameshot}";
          Install.WantedBy = [ "graphical-session.target" ];
        };
        xbanish = {
          Unit.Description = "";
          Service.Type = "simple";
          Service.ExecStart = "${lib.getExe pkgs.xbanish}";
          Install.WantedBy = [ "graphical-session.target" ];
        };
        deluge = {
          Unit.Description = "";
          Service.Type = "simple";
          Service.ExecStart = "${lib.getExe pkgs.deluge}";
          # Install.WantedBy = ["graphical-session.target"];
        };
        xset = {
          Unit.Description = "";
          Service.Type = "oneshot";
          Service.ExecStart = "${lib.getExe pkgs.xorg.xset} r rate 350 50";
          Install.WantedBy = [ "graphical-session.target" ];
        };

      };
    };
}
