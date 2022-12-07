#!/usr/bin/bash
set -xuo pipefail

fail () {
    printf "%s\n" "$1" >&2
    exit "${2-1}"
}

start_server () {
    pid="$(pgrep --full 'rclone serve')"
    [[ -z "$pid" ]] || kill "$pid"
    nohup rclone serve restic -v tdrive:/x1carbon-backup >> ~/.logs/backup-x1carbon & disown
    sleep 1
}
export -f start_server

backup () {
    EXCLUDE_FILE=/home/carneca/.config/nixpkgs/extraConfigs/.config/rclone/exclude_list.txt
    export RESTIC_REPOSITORY="rest:http://localhost:8080/"
    RESTIC_PASSWORD="$(rbw get restic-x1carbon-remote-backup)"
    export RESTIC_PASSWORD
    pgrep --full 'rclone serve' > /dev/null || start_server
    pgrep --full 'rclone serve' > /dev/null || fail "rclone server not available"
    restic --limit-upload $(( 8*1000 )) \
           -vvv \
           --password-file <(echo "$RESTIC_PASSWORD") \
           --tag "$(date '+%d%b%Y')" \
           --exclude-file $EXCLUDE_FILE \
           backup "/home/carneca/Documents/" "/home/carneca/Music"  2> ~/.logs/somanyerrors
}
export -f backup

read_notify_loop () {
    if ! rbw unlocked;
    then while true; do
        clear
        notify-send -t $(( 10*1000 )) "Please authenticate the restic backup :)"
        read -r -t $(( 1*60 )) -p "Ready? (Press Enter to Continue)"
        if [ $? -eq 0 ];
        then 
            if rbw unlock;
            then
                break
            fi
        fi
    done
    fi
}

main () {
    read_notify_loop 2> ~/.logs/read_notify_loop
    backup 2> ~/.logs/backup_restic
    kill "$(pgrep --full 'rclone serve')"
}
main
