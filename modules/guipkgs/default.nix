{
  config,
  pkgs,
  ...
}: let
  l = pkgs.lib // builtins;
  ml = import ../../lib/default.nix {inherit pkgs;};
  inherit (l.modules) mkIf;
in {
  home.packages = l.mkIf config.host.isDesktop (with pkgs; (
    [
      rofi
      mcomix3 # comic reader
      zathura # pdf reader
      sioyek
      flameshot

      element-web
      vlc # media player
      mpv # lightweight media player
      feh # image viewer
      # whatsapp-for-linux
      # signal-desktop
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
      spotify
      inkscape
      gimp
      deluge
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
      ]
    )
  ));

  programs = {

    firefox = {
      enable = config.host.isDesktop;
    };

  };
}
