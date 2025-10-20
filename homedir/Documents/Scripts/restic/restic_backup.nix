{ pkgs }:
let
  l = pkgs.lib // builtins;
  backup_script = pkgs.writeShellScript "backup" (builtins.readFile ./backup.sh);
  read_notify_loop_script = pkgs.writeShellScript "read_notify_loop" (
    builtins.readFile ./read_notify_loop.sh
  );
in
(pkgs.writeShellApplication {
  name = "restic-backup";
  text = ''
    SESSION_NAME="restic-daily-backup-$(${pkgs.coreutils}/bin/date '+%d%b%Y')"
    ${l.getExe pkgs.tmux} new-session -d -s "$SESSION_NAME" -- \
            bash -c ${read_notify_loop_script};

    set +e # undo exit on error
    while true; do
      if ! tmux list-session | grep -q "$SESSION_NAME";
      then
        ${backup_script} ; exit $?
      fi
    done
  '';
  runtimeInputs = with pkgs; [
    rbw
    tmux
    restic
    procps
    rclone
    gnugrep
  ];
})
