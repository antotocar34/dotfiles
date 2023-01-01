# {config, pkgs}: 
let
  pkgs = import <nixpkgs> {};
  l = pkgs.lib // builtins;
  # daily_backup_script = pkgs.writeShellScript "backup" (builtins.readFile ./daily_backup.sh);
  config.host.user = "carneca";
  homedir = "/home/${config.host.user}";

in (pkgs.writeShellApplication {
  name = "rclone-backup";
  text = ''
    rclone-backup copy ${homedir}/Documents tdrive:/backup/Documents
    rclone-backup copy ${homedir}/Music tdrive:/backup/Music
  '';
  runtimeInputs = [
    (
      pkgs.writeShellScriptBin "rclone-backup"
      ''
        ${l.getExe pkgs.rclone} "$@" --filter-from ${../../../.config/rclone/exclude_list.txt}
      ''
    )
  ];
})
