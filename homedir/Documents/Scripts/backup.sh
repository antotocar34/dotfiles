#! /bin/bash

# include_list="--include ${HOME}/Documents --include ${HOME}/Music --include ${HOME}/Pictures --include ${HOME}/Videos" 

# rsync -v -avzhe ssh /home/carneca/ --include-from=include.txt acer:/home/carnec/SystemBackups

rclone_backup () {
${HOME}/.nix-profile/bin/rclone -v copy ${HOME}/$1 tdrive:/backup/$1/
}

rclone_backup "Documents"
while [ $? -ne 0 ] ; do
    rclone_backup "Documents"
    sleep 4
done
