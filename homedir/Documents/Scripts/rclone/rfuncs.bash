get_drive_root() {
    local cutoff=$( readlink -f ${1:-.} | sed "s|${HOME}/\(.*\)|\1|" | sed "s#${HOME}##")
    echo tdrive:/backup/${cutoff}
}

rcheck () {
    rcheck_pre () {
        drive_path=$(get_drive_root ${1:-.})
        local_path=$(readlink -f ${1:-.})
        rclone-backup check $local_path $drive_path --size-only --combined - | tee -a ${HOME}/.logs/check.log
    }
    # Remove displaying unchanged files
    rcheck_pre $1 | sed -ur 's#^=.*##' | sed -ur '#ERROR :##d' | awk 'NF'
}

rls () {
    drive_path=$(get_drive_root ${1:-.})
    rclone lsf $drive_path
}

rupdate() {
    rclone_command_update () {
        drive_path=$(get_drive_root ${1:-.})
        local_path=$(readlink -f ${1:-.})
        rclone-backup $2 -v ${local_path}/ $drive_path/
        }
    if [[ $1 = "-s" ]]; then
        input_full=$(readlink -f $2)
        rclone_command_update $input_full sync
    else
        input_full=$(readlink -f $1)
        rclone_command_update $input_full copy
    fi
}

rdl() {
    rclone_command_download () {
        drive_path=$(get_drive_root ${1:-.})
        local_path=$(readlink -f ${1:-.})
        rclone-backup $2 -v ${drive_path}/ ${local_path}/
        }
    if [[ $1 = "-s" ]]; then
        rclone_command_download $2 sync
    else
        rclone_command_download $1 copy
    fi
}

rdel() {
    drive_path=$(get_drive_root ${1:-.})
    rclone-backup delete -i $drive_path
}

rtotaldel() {
    drive_path=$(get_drive_root ${1:-.})
    local_path=$(readlink -f ${1:-.})
    drive_path=$(get_drive_root ${1:-.})
    echo "This will delete from both remote and local" && rclone-backup delete -i $drive_path && rm -ri $local_path
}

pdl() {
    pirate-get -C "transmission-remote -a %s -w '/home/carneca/Downloads'" "${1}"
}

bdupdate() {
    LOCAL_BD_LIB="${HOME}/Documents/Books/Calibre/BD" 
    REMOTE_BD_LIB="tdrive:/backup/Documents/Books/Calibre/BD"
    rclone-backup copy -v $LOCAL_BD_LIB $REMOTE_BD_LIB
}
