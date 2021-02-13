#!/bin/bash
# Calls rofi on find and doesn't return anything if cancelled

FILE=$(fd -epdf . ~/Documents/ ~/Downloads/ ~/Documents/Latex  | rofi -dmenu -i)

if [[ ${?} -eq 0 ]]
then
    zathura "${FILE}"
    exit 0
else
    exit 1
fi
