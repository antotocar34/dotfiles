
rclone_sync () {
# ${HOME}/.nix-profile/bin/rclone -v sync ${HOME}/Documents tdrive:/backup/Documents/
${HOME}/.nix-profile/bin/rclone -v sync -P ${HOME}/big/Books/ tdrive:/backup/Documents/Books/
}

rclone_sync
while [ $? -ne 0 ] ; do
    rclone_sync
    sleep 3
done
