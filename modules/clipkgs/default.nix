{config, pkgs, ...}:
let
  l = pkgs.lib // builtins;
  mypkgs = import ../../mypkgs {inherit pkgs;};
in
{
  home.packages = with pkgs; [
      mimeo
      # bashInteractive
      ripgrep # fast text search
      fd # fast file finder
      fzf # stdout processor
      du-dust # better du
      duf # better df
      # tldr # common wayes to use a command
      rdfind # duplicate finder and remover
      tree #
      cloc # counts lines of code
      trash-cli
      yt-dlp # youtube-dl but better
      psmisc # pstree and the like
      age # encryption tool
      pwgen # password generator
      unzip
      borgbackup # backup tool
      bottom # system surveillance
      # unrar
      rclone # google drive cli interface
      mypkgs.rclone-backup
      lkr # personal script to lock sensitive files and directories with age
      direnv # Set environments in a specific directory
      tdrop # Toggle terminal
      jq # format json to stdout
      just # command line runner
      pirate-get # cli interface to piratebay
      libgen-cli # cli interface to libgen
      xclip # clipboard cli
      comma
      cntr # Nix build debugging helper
      cachix
      magic-wormhole # Send files to anyone
  ];
}
