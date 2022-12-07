{config, pkgs, ...}:
let
  l = pkgs.lib // builtins;
in
{
  # systemd automatic starting of services *I think*
  systemd.user.systemctlPath = "${pkgs.systemd}/bin/systemctl";
  systemd.user.startServices = "legacy";
  systemd.user.services = {
    sxhkd = {
      Unit.Description = "Simple X Hotkey Daemon";
      Service.Type = "simple";
      Service.ExecStart = "${l.getExe pkgs.sxhkd}";
      Install.WantedBy = [ "default.target" ];
    };
    flameshot = {
      Unit.Description = "";
      Service.Type = "simple";
      Service.ExecStart = "${l.getExe pkgs.flameshot}";
      Install.WantedBy = [ "default.target" ];
    };
    xbanish = {
      Unit.Description = "";
      Service.Type = "simple";
      Service.ExecStart = "${l.getExe pkgs.xbanish}";
      Install.WantedBy = [ "default.target" ];
    };
    deluge = {
      Unit.Description = "";
      Service.Type = "simple";
      Service.ExecStart = "${l.getExe pkgs.deluge}";
      Install.WantedBy = [ "default.target" ];
    };
    xset = {
      Unit.Description = "";
      Service.Type = "oneshot";
      Service.ExecStart = "${l.getExe pkgs.xorg.xset} r rate 280 50";
      Install.WantedBy = [ "default.target" ];
    };
  };
}
