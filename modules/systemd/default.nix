{
  config,
  pkgs,
  ...
}: let
  l = pkgs.lib // builtins;
in {
  # systemd automatic starting of services *I think*
  systemd.user = {
    systemctlPath = "${pkgs.systemd}/bin/systemctl";
    startServices = "legacy";
    services = {
      sxhkd = {
        Unit.Description = "Simple X Hotkey Daemon";
        Service.Type = "simple";
        Service.ExecStart = "${l.getExe pkgs.sxhkd}";
        Install.WantedBy = ["graphical-session.target"];
      };
      flameshot = {
        Unit.Description = "";
        Service.Type = "simple";
        Service.ExecStart = "${l.getExe pkgs.flameshot}";
        Install.WantedBy = ["graphical-session.target"];
      };
      xbanish = {
        Unit.Description = "";
        Service.Type = "simple";
        Service.ExecStart = "${l.getExe pkgs.xbanish}";
        Install.WantedBy = ["graphical-session.target"];
      };
      deluge = {
        Unit.Description = "";
        Service.Type = "simple";
        Service.ExecStart = "${l.getExe pkgs.deluge}";
        Install.WantedBy = ["graphical-session.target"];
      };
      xset = {
        Unit.Description = "";
        Service.Type = "oneshot";
        Service.ExecStart = "${l.getExe pkgs.xorg.xset} r rate 280 50";
        Install.WantedBy = ["graphical-session.target"];
      };

      restic-backup = let
        script = import ../../homedir/Documents/Scripts/restic/restic_backup.nix {inherit pkgs;};
      in {
        Unit.Description = "Backup";
        Service.Type = "forking"; # launch tmux session then exit
        Service.ExecStart = "${script}/bin/restic-backup";
        # Install.WantedBy = [ "timers.target" ];
      };
    };
    timers.restic-backup = {
      Unit.Description = "Run restic-backup daily";
      Timer.OnCalendar = "11:30:00";
      Timer.Persistent = true;
      Install.WantedBy = ["timers.target"];
    };
  };
}
