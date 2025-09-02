alias poetry_setup="echo 'autoload' >> .envrc && direnv allow"
alias pstart="poetry init -n > /dev/null && echo 'autoload' >> .envrc && direnv allow"

alias rclone_filter="$EDITOR ${HOME}/.config/nixpkgs/homedir/.config/rclone/exclude_list.txt"

function play () {
    sonos Comedor group_vol 15 : Comedor play_file "$(fd -emp3 -em4a . /home/carneca/Music | fzf)"
}
function playlist () {
    sonos Comedor group_vol 15 : Comedor play_m3u "$(fd . /home/carneca/.config/cmus/playlists | fzf)" pis
}
function vol () {
    sonos Comedor group_relative_volume $1
}
function mstop () {
    sonos Comedor stop
}
function qplay () {
    cmus-remote -C "save -q -" | sonos Comedor group_vol 20 : Comedor play_m3u /dev/stdin pis
}
