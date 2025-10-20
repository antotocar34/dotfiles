set -a
## PYTHON SCRIPTS
export PYTHON_DIR="${HOME}/Documents/Programming/Python"
export SCRIPT_DIR="${HOME_MANAGER_CONFIG}/homedir/Documents/Scripts"
export MATHS_DIR="${HOME}/Documents/Notes/maths"
export COLLEGE_DIR="${HOME}/Documents/College/masters"

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
    launch "xournalpp ${MATHS_DIR}/template.xopt"
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

function dir_find {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --max-depth 5 --one-file-system --follow $exclusions -td . $HOME"""
    dir=$($cmd | fzf)
    if [[ $? -eq 130 ]]; then
        true
    else
        cd "${dir}"
    fi
}

function local_dir_find {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --hidden --one-file-system --max-depth 5 --follow $exclusions -td . ."""
    dir=$($cmd | fzf)
    if [[ $? -eq 130 ]]; then
        true
    else
        cd "${dir}"
    fi
}

function file_find {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --one-file-system --max-depth 5 --hidden --follow $exclusions -tf . $HOME"""
    FILE=$($cmd | fzf)
    if [[ $? -eq 130 ]]; then
        true
    else
        $EDITOR "${FILE}"
    fi
}

# launch and disown program
function start {
    nohup ${@} >/dev/null 2>/dev/null & disown
}

function launch {
    nohup ${@} >/dev/null 2>/dev/null & disown; exit
}

## Nix aliases
function nrepl {
    nix repl --expr "{ pkgs = import <nixpkgs> {}; lib = import <nixpkgs/lib>; }"
}

function nsearch {
    nix search nixpkgs "$@"
}

function nshell {
    if [ "$#" -gt 1 ]
        then 
            args=( "$@" ) 
            nix shell "${args[@]/#/nixpkgs#}"
        else 
            nix shell "nixpkgs#${1}"
    fi
}

function nrun {
    if [ "$#" -gt 1 ]
        then 
            nix run "nixpkgs#${1}" -- "${@:2}"
        else
            nix run "nixpkgs#${1}"
    fi
}

set +a
