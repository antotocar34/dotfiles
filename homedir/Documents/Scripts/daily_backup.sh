#! /bin/bash

. ${HOME}/.config/nixpkgs/homedir/Documents/Scripts/rfuncs.bash

document_backup () {
    rupdate ${HOME}/Documents/
}

task_backup () {
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/.task/ tdrive:/backup/data/taskwarrior/
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/.timewarrior/ tdrive:/backup/data/timewarrior/
}

task_backup

document_backup
