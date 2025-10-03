{
  flake.modules.homeManager.desktop = {inputs, system, config, pkgs, lib, myLib, host, ...}:
  let
    nixGL = inputs.nixgl.packages.${system}.default;
    wrapWithNixGLFull = myLib.wrapWithNixGLFull pkgs;
    isDesktopLinux = host.isDesktop && pkgs.stdenv.isLinux;
  in
  {
    home.packages = lib.mkIf isDesktopLinux (with pkgs; (
      [
        nixGL
        rofi
        mcomix3 # comic reader
        zathura # pdf reader
        # flameshot
        zotero
        vlc
        feh

        #element-web
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
          # krita # Drawing Application
          xournalpp # note taking
          transcribe #
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
        if ! host.isNixos
        then (wrapWithNixGLFull nixGL)
        else x: x
        )
        [
          calibre
        # kitty
        # stremio # media streaming client
        # sioyek
      ]
      )
      ));


    };
  }
