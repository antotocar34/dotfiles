{
  config,
  pkgs,
  lib,
  ...
}: let
  l = lib // builtins;
in {
  systemd.user = {
    systemctlPath = "${pkgs.systemd}/bin/systemctl";
    startServices = "suggest";
    services = {
      sxhkd = {
        Unit.Description = "Simple X Hotkey Daemon";
        Service.Type = "oneshot";
        Service.Environment = "PATH=${config.home.homeDirectory}/.nix-profile/bin:/usr/bin:/bin";
        Service.ExecStart = "${l.getExe pkgs.sxhkd} -c ${config.configPath}/homedir/.config/sxhkd/sxhkdrc";
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
        # Install.WantedBy = ["graphical-session.target"];
      };
      xset = {
        Unit.Description = "";
        Service.Type = "oneshot";
        Service.ExecStart = "${l.getExe pkgs.xorg.xset} r rate 350 50";
        Install.WantedBy = ["graphical-session.target"];
      };

      restic-backup = let
        script = import ../../homedir/Documents/Scripts/restic/restic_backup.nix {inherit pkgs;};
      in {
        Unit.Description = "Backup";
        Service.Type = "exec"; # launch tmux session then exit
        Service.ExecStart = "${script}/bin/restic-backup";
        # Install.WantedBy = [ "timers.target" ];
      };
      # restic-rclone-server = {
      #   Unit.Description = "";
      #   Service.Type = "simple";
      #   Service.ExecStart = "${l.getExe pkgs.rclone} serve ";
      #   # Install.WantedBy = [];
      # };
      newsdl = let
        script = import ../../homedir/Documents/Scripts/newsdl/newsdl.nix {inherit pkgs;};
      in
      {
        Unit.Description = "";
        Unit.Wants = ["network-online.target"];
        Unit.After = ["network.target" "network-online.target"];
        Service.Type = "exec";
        Service.ExecStart = "${script}/bin/newsdl";
      };

      rclone_nightly = let
        script = import ../../homedir/Documents/Scripts/rclone/daily_backup.nix {inherit config pkgs;};
      in
      {
        Unit.Description = "";
        Service.Type = "exec";
        Service.ExecStart = "${script}/bin/rclone-backup";
      };
    };

    timers = {
      restic-backup = {
        Unit.Description = "Run restic-backup daily";
        Timer.OnCalendar = "11:00:00";
        Install.WantedBy = ["timers.target"];
        Timer.Persistent = true;
      };
      newsdl = {
        Unit.Description = "Run newsdl on Thursday night";
        Timer.OnCalendar = "Thu 22:40:00";
        Install.WantedBy = ["timers.target"];
        Timer.Persistent = true;
      };
      rclone_nightly = {
        Unit.Description = "";
        Timer.OnCalendar = "21:00:00";
        Install.WantedBy = ["timers.target"];
        Timer.Persistent = false;
      };
    };
  };
}
