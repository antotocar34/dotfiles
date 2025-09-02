#!/usr/bin/bash
set -uo pipefail

PORT=42965

fail () {
    printf "%s\n" "$1" >&2
    exit "${2-1}"
}

start_server () {
    pid="$(pgrep --full 'rclone serve')"
    [[ -z "$pid" ]] || kill "$pid"
    nohup rclone serve restic --addr "localhost:${PORT}" -v tdrive:/x1carbon-backup 2>> ~/.logs/server_fail >> ~/.logs/backup-x1carbon & disown
    sleep 1
}
export -f start_server

backup () {
    EXCLUDE_FILE=/home/carneca/.config/dotfiles/homedir/.config/rclone/exclude_list.txt
    export RESTIC_REPOSITORY="rest:http://localhost:${PORT}"
    RESTIC_PASSWORD="$(rbw get restic-x1carbon-remote-backup)"
    export RESTIC_PASSWORD
    pgrep --full 'rclone serve' > /dev/null || start_server
    pgrep --full 'rclone serve' > /dev/null || fail "rclone server not available"
    ps aux | rg "rclone serve"
    sleep 2
    restic --limit-upload $(( 8*1000 )) \
           -v \
           --password-file <(echo "$RESTIC_PASSWORD") \
           --tag "$(date '+%d%b%Y')" \
           --exclude-file $EXCLUDE_FILE \
           backup "/home/carneca/Documents/" "/home/carneca/Music" "/home/carneca/.config/dotfiles"
}
export -f backup

main () {
    backup
    kill "$(pgrep --full 'rclone serve')"
}
main
