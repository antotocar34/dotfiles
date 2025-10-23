{
  flake.modules.homeManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.skhd = lib.mkIf pkgs.stdenv.isDarwin {
        enable = true;
        config =
          let
            focus =
              name:
              "/usr/bin/env osascript -e 'tell application \"${name}\" to reopen' -e 'tell application \"${name}\" to activate'";
            applicationShortcut = name: shortcut: "${shortcut} : ${focus name} || /usr/bin/env open -a ${name}";
          in
          ''
            ${applicationShortcut "Kitty" "shift + cmd - return"}
            ${applicationShortcut "Slack" "shift + cmd - s"}
            ${applicationShortcut "Visual Studio Code" "shift + cmd - c"}
            ${applicationShortcut "Spotify" "shift + cmd - m"}
            ${applicationShortcut "Obsidian" "shift + cmd - o"}
            ${applicationShortcut "Google Chrome" "shift + cmd - b"}
          '';

      };

      systemd.user.services = lib.mkIf pkgs.stdenv.isLinux {
        sxhkd = {
          Unit.Description = "Simple X Hotkey Daemon";
          Service.Type = "oneshot";
          Service.Environment = "PATH=${config.home.homeDirectory}/.nix-profile/bin:/usr/bin:/bin";
          Service.ExecStart = "${lib.getExe pkgs.sxhkd} -c ${config.configPath}/homedir/.config/sxhkd/sxhkdrc";
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
