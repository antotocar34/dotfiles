#! /bin/bash

. ${HOME}/.config/dotfiles/homedir/Documents/Scripts/rclone/rfuncs.bash



FILTER_FILE="/home/carneca/.config/dotfiles/homedir/.config/rclone/exclude_list.txt"
FILTER_FILE="/home/carneca/.config/dotfiles/homedir/.config/rclone/exclude_list.txt"

document_backup () {
    rupdate ${HOME}/Documents/ --exclude-from $FILTER_FILE
}

task_backup () {
  rclone-backup -v copy ${HOME}/.task/ tdrive:/backup/data/taskwarrior/
  rclone-backup -v copy ${HOME}/.timewarrior/ tdrive:/backup/data/timewarrior/
}

task_backup

document_backup
