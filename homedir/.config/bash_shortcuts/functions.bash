set -a
## PYTHON SCRIPTS

function dir_find_template {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --max-depth 5 --one-file-system --follow $exclusions -td . $1"""
    dir=$($cmd | fzf)
    if [[ -d $dir ]]; then
        cd "${dir}"
    fi
}

function dir_find {
  dir_find_template $HOME
}

function local_dir_find {
  dir_find_template .
}

function file_find_template {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --one-file-system --max-depth 5 --hidden --follow $exclusions -tf . $1"""
    FILE=$($cmd | fzf)
    if [[ -f FILE ]]; then
        $EDITOR "${FILE}"
    fi
}

function file_find {
  file_find_template $HOME
}

function local_file_find {
  file_find_template .
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
