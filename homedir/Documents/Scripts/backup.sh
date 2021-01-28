#! /bin/bash

rclone_backup () {
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/Documents tdrive:/backup/documents/
}

rclone_backup 2> /home/carneca/log
while [ $? -ne 0 ] ; do
    rclone_backup 2> /home/carneca/.log/rclone_backup
    sleep 3
done
