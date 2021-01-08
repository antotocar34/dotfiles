#! /bin/bash

include_list="--include ${HOME}/Documents --include ${HOME}/Music --include ${HOME}/Pictures --include ${HOME}/Videos" 

rsync -v -avzhe ssh /home/carneca/ --include-from=include.txt acer:/home/carnec/SystemBackups
