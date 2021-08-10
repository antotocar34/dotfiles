#! /bin/bash

document_backup () {
    ${HOME}/Documents/Scripts/rupdate ${HOME}/Documents/
}


task_backup () {
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/.task/ tdrive:/backup/data/taskwarrior/
${HOME}/.nix-profile/bin/rclone -v copy -P ${HOME}/.timewarrior/ tdrive:/backup/data/timewarrior/
}

task_backup

document_backup
