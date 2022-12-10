{pkgs, ...}: let
  l = pkgs.lib;
in {
  rclone-backup = (
    pkgs.writeShellScriptBin "rclone-backup"
    ''
      ${l.getExe pkgs.rclone} "$@" --filter-from ${../homedir/.config/rclone/exclude_list.txt}
    ''
  );

  lkr = pkgs.writeShellScriptBin "lkr" (builtins.readFile /home/carneca/Documents/projects/locker/lkr);
}
