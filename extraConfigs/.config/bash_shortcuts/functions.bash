set -a
## PYTHON SCRIPTS
export PYTHON_DIR="${HOME}/Documents/Programming/Python"
export SCRIPT_DIR="${HOME}/Documents/Scripts"
export MATHS_DIR="${HOME}/Documents/Notes/maths"
export COLLEGE_DIR="${HOME}/Documents/College/masters"

find_pdf () {
    FILE=$(fd -uu -epdf . ~/Documents/ ~/Downloads/ ~/Documents/Latex  | rofi -dmenu -i -p $PDF_VIEWER)

    if [[ ${?} -eq 0 ]]
    then
        $PDF_VIEWER "${FILE}"
        exit 0
    else
        exit 1
    fi
}

find_tex () {
FILE=$(fd -uu -etex . ~/Documents | rofi -dmenu -i -p "tex")

if [[ ${?} -eq 0 ]]
then
    $TERMINAL -e nvim "${FILE}"
    exit 0
else
    exit 1
fi
}
function mnew () {
    launch "xournalpp ${MATHS_DIR}/template.xopt" .
}

function xournalwrite () {
    chosen_file="$(fd -exopp --full-path "$1" | fzf || exit 1)"
    if [[ $? -ne 1 ]]
    then launch "xournalpp $chosen_file"
    fi
}

function mwrite () {
    xournalwrite $MATHS_DIR
}

function cwrite () {
    xournalwrite $COLLEGE_DIR
}

function weekly_dl {
cd ${PYTHON_DIR}/automation/weekly_dl/weekly_dl/ && poetry run python main.py

cd - 2> /dev/null
}
export -f weekly_dl

function draw {
draw_dir=${HOME}/.config/nixpkgs/homedir/Documents/Scripts/inkscape-draw
cd $draw_dir 

if [ ! -f poetry.lock ]; then
    poetry update
fi

poetry run inkscape-figures watch
poetry run python inkscape-shortcut-manager/main.py
}

function dir_find {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --follow $exclusions -td . $HOME"""
    dir=$($cmd | fzf)
    if [[ $? -eq 130 ]]; then
        true
    else
        cd "${dir}"
    fi
}

function local_dir_find {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --follow $exclusions -td . ."""
    dir=$($cmd | fzf)
    if [[ $? -eq 130 ]]; then
        true
    else
        cd "${dir}"
    fi
}

function file_find {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --hidden --follow $exclusions -tf . $HOME"""
    FILE=$($cmd | fzf)
    if [[ $? -eq 130 ]]; then
        true
    else
        vim "${FILE}"
    fi
}

# launch and disown program
function launch {
    nohup ${@} >/dev/null 2>/dev/null & disown; exit
}

function nshell {
    nix shell "nixpkgs#$1"
}

function nrun {
    nix run "nixpkgs#$1" -- "$@"
}

set +a

## RCLONE FUNCTIONS

. ${HOME}/Documents/Scripts/rfuncs.bash

datascience() {
    poetry init -n --python ">3.9, <3.11" --dependency pandas \
                                           --dependency numpy \
                                           --dependency matplotlib \
                                           --dependency sklearn \
                                           --dev-dependency ipython \
                                           --dev-dependency ipykernel  \
                                           --dev-dependency jupyter  \
                                           --dev-dependency jupytext  \
                                           --dev-dependency nbconvert  \
                                           --author "Antoine Carnec"
    poetry install
    echo autoload >> .envrc 
    direnv allow
}
