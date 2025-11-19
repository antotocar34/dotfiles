{
  flake.modules.homeManager.cli = {pkgs, lib, acpkgs, ...}:
  let
    rbw-agent-bin = "${acpkgs.rbw}/bin/rbw-agent" ;
  in
  {

    systemd.user.services = lib.mkIf pkgs.stdenv.isLinux  {
      rbw-agent = {
          Unit.Description = "rbw agent";
          Service.Type = "oneshot";
          Service.ExecStart = rbw-agent-bin;
          Install.WantedBy = [ "graphical-session.target" ];
      };
    };

    launchd.agents.rbw-agent = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = [  rbw-agent-bin ];
        ProcessType = "Interactive";
        KeepAlive = false;
        RunAtLoad = true;
      };
    };
  };
}
