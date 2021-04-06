#!/bin/bash


task_backup () {
FILE="task-backup-$(date +'%d-%m-%Y').tar.gz"
cd ~/.task
tar -czf $FILE *

rclone_tasks () {
${HOME}/.nix-profile/bin/rclone -v copy $FILE tdrive:/backup/tasks/
}

rclone_tasks
while [ $? -ne 0 ] ; do
    rclone_tasks
    sleep 3
done
}

task_backup
