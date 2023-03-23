{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mimetype;
  l = lib // builtins;
in {

  options.mimetype = {
    enable = l.mkEnableOption "Enable custom mimetypes";
  };

  config = l.mkIf cfg.enable {
    xdg = {
      mime.enable = true;
      mimeApps.enable = true;
      mimeApps.associations.added = let
        # TODO maybe better to directly access from home.packages?
        # TODO what is a package is installed in another way, this should be fine
        getDesktopFile = pkg:
          if (l.lists.elem pkg config.home.packages)
          then l.attrsets.attrNames (l.readDir "${pkg}/share/applications")
          else "";
        audio = getDesktopFile pkgs.vlc;
        video = getDesktopFile pkgs.mpv;
        browser = getDesktopFile pkgs.firefox;
        pdf_reader = getDesktopFile pkgs.sioyek;
        svg = getDesktopFile pkgs.inkscape;
        office = getDesktopFile pkgs.libreoffice-fresh;
        ##
        zathura = getDesktopFile pkgs.sioyek;
      in {
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "application/html" = browser;
        # "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop" ;
        "application/pdf" = getDesktopFile pkgs.sioyek;
        "application/epub+zip" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/svg+xml" = svg;
        "audio/opus" = audio;
        "audio/aac" = audio;
        "audio/mpegsymlinks" = audio;
        "application/msword" = office;
        "application/vnd.comicbook-rar" = zathura;
        "application/vnd.comicbook+zip" = zathura;
        "application/mp4" = video;
        "application/mkv" = video;
        "application/avi" = video;
        # "video/webm"          = video;
        # "video/x-annodex"     = video;
        # "video/x-flv"         = video;
        # "video/x-javafx"      = video;
        # "video/x-matroska"    = video;
        # "video/x-matroska-3d" = video;
        # "video/x-ms-asf"      = video;
        # "video/x-ms-wm"       = video;
        # "video/x-ms-wmv"      = video;
        # "video/x-ms-wmx"      = video;
        # "video/x-ms-wvx"      = video;
        # "video/x-msvideo"     = video;
        # "video/x-sgi-movie"   = video;
        
      };
    };
  };
}
