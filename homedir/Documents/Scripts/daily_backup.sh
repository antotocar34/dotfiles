#! /bin/bash



document_backup () {
rclone_documents () {
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/Documents tdrive:/backup/Documents/
}

rclone_documents 2> /home/carneca/.log/rclone_backup
while [ $? -ne 0 ] ; do
    rclone_documents 2> /home/carneca/.log/rclone_backup
    sleep 3
done
}

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

document_backup
