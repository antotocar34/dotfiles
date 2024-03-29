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

      element-web
      vlc # media player
      mpv # lightweight media player
      feh # image viewer
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
      gnome3.gnome-disk-utility
      gnome3.pomodoro
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

    firefox = {
      enable = config.host.isDesktop;
    };

  };
}
