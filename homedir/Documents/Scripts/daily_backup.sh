#! /bin/bash

document_backup () {
rclone_documents () {
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/Documents tdrive:/backup/Documents/
}

rclone_documents 2>> /home/carneca/.log/rclone_backup
while [ $? -ne 0 ] ; do
    rclone_documents 2>> /home/carneca/.log/rclone_backup
    sleep 3
done
}

task_backup () {
rclone_tasks () {
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/.task/ tdrive:/backup/data/taskwarrior/
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/.timewarrior/ tdrive:/backup/data/timewarrior/
}

rclone_tasks
while [ $? -ne 0 ] ; do
    rclone_tasks
    sleep 3
done
}

task_backup

document_backup
