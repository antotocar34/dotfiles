read_notify_loop () {
    if ! rbw unlocked;
    then while true; do
        clear
        notify-send -t $(( 10*1000 )) "Please authenticate the restic backup :)"
        read -r -t $(( 1*60 )) -p "Ready? (Press Enter to Continue)"
        if [ $? -eq 0 ];
        then 
            if rbw unlock;
            then
                break
            fi
        fi
    done
    fi
}

read_notify_loop
