FILTER_FILE=/home/carneca/.config/nixpkgs/extraConfigs/.config/rclone/exclude_list.txt

get_drive_root() {
local cutoff=$( readlink -f ${1:-.} | sed "s#${HOME}/\(.*\)#\1#" | sed "s#${HOME}##")
echo tdrive:/backup/${cutoff}
}

rcheck () {
    rcheck_pre () {
        drive_path=$(get_drive_root ${1:-.})
        local_path=$(readlink -f ${1:-.})
        rclone check $local_path $drive_path --filter-from $FILTER_FILE --size-only --combined - | tee -a ${HOME}/.logs/check.log
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
        ${HOME}/.nix-profile/bin/rclone $2 -v ${local_path}/ $drive_path/ --filter-from  $FILTER_FILE
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
        ${HOME}/.nix-profile/bin/rclone $2 -v ${drive_path}/ ${local_path}/ --filter-from  $FILTER_FILE
        }
    if [[ $1 = "-s" ]]; then
        rclone_command_download $2 sync
    else
        rclone_command_download $1 copy
    fi
}

rdel() {
    drive_path=$(get_drive_root ${1:-.})
    rclone delete -i $drive_path
}

rtotaldel() {
    drive_path=$(get_drive_root ${1:-.})
    local_path=$(readlink -f ${1:-.})
    drive_path=$(get_drive_root ${1:-.})
    echo "This will delete from both remote and local" && rclone delete -i $drive_path && rm -ri $local_path
}
