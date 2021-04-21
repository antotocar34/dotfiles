
#! /bin/bash

rclone_sync () {
# ${HOME}/.nix-profile/bin/rclone -v sync ${HOME}/Documents tdrive:/backup/Documents/
${HOME}/.nix-profile/bin/rclone -v sync ${HOME}/Music/ tdrive:/backup/Music/
# ${HOME}/.nix-profile/bin/rclone -v sync ${HOME}/big/Books/ tdrive:/backup/Documents/Books/
}

rclone_sync 2> /home/carneca/.log/rclone_backup
while [ $? -ne 0 ] ; do
    rclone_sync 2> /home/carneca/.log/rclone_backup
    sleep 3
done
