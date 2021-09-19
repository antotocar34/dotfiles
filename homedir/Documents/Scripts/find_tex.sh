#!/bin/bash
# Calls rofi on find and don't return anything if cancelled

FILE=$(fd -uu -etex . ~/Documents/Latex | rofi -dmenu -i)

if [[ ${?} -eq 0 ]]
then
    $TERMINAL -e nvim "${FILE}"
    exit 0
else
    exit 1
fi
