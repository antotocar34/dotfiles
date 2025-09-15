{
  config,
  pkgs,
  ...
}: let
  l = pkgs.lib // builtins;
  ml = import ../../lib/default.nix {inherit pkgs;};
in {
  home.packages = l.mkIf config.host.isDesktop (with pkgs; (
    [
      nixGL
      rofi
      mcomix3 # comic reader
      zathura # pdf reader
      flameshot
      zotero
      vlc
      feh

      element-web
      # whatsapp-for-linux
      # signal-desktop
      (
        pkgs.writeShellScriptBin "xdg-open" ''
        exec "${lib.getExe pkgs.mimeo}" "$@"
        ''
      )
      bitwarden
      rofi-rbw
      discord
      gnome-disk-utility
      gnome-pomodoro
      # filezilla # FTP client
      krita # Drawing Application
      transcribe #
      xournalpp # note taking
      libreoffice-fresh
      # spotify
      inkscape
      gimp
      deluge
      syncthing
    ]
    ++
    # For those applications that need to be wrapped with nixGL
    (
      map (
        if ! config.host.isNixos
        then (ml.wrapWithNixGLFull nixGL)
        else x: x
      )
      [
        calibre
        kitty
        stremio # media streaming client
        sioyek
      ]
    )
  ));

  programs = {

    kitty = {
      enable = true;
      enableBashIntegration = true;
      extraConfig = ../../homedir/.config/kitty/kitty.conf;

    };
    firefox = {
      enable = config.host.isDesktop;
    };

  };
}
