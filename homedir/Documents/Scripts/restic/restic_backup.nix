{pkgs}:
let
  l = pkgs.lib // builtins;
  backup_script = pkgs.writeShellScript "backup" (builtins.readFile ./backup.sh);
in
  (pkgs.writeShellApplication {
    name = "restic-backup";
    text = ''
    SESSION_NAME="restic-daily-backup-$(${pkgs.coreutils}/bin/date '+%d%b%Y')"
    ${l.getExe pkgs.tmux} new-session -d -s "$SESSION_NAME" -- \
            bash -c ${backup_script};
    '';
    runtimeInputs = with pkgs; [ rbw tmux restic procps rclone ];
  })

