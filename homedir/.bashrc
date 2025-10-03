#  ____    _    ____  _   _ ____   ____ 
# | __ )  / \  / ___|| | | |  _ \ / ___|
# |  _ \ / _ \ \___ \| |_| | |_) | |    
# | |_) / ___ \ ___) |  _  |  _ <| |___ 
# |____/_/   \_\____/|_| |_|_| \_\\____|

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Save and reload the history after each command finishes
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
HISTSIZE=100000 # big big history
HISTFILESIZE=100000 # big big history
HISTCONTROL=ignoreboth # don't put duplicate lines or lines starting with space in the history.
shopt -s histappend # append to the history file, don't overwrite it
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# VARIABLE DECLARATIONS
export TERMINAL="kitty"

if [ $TERM = "xterm-kitty" ] ; then
    alias ssh="kitty +kitten ssh"
fi


# Unbind ^Q
stty -ixon

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias la='ls -A --color=auto'
    alias ll='ls -l --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# Shell VI settings
bind "set editing-mode vi"
bind -x '"\C-l": clear'

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Show which branch you are on if there is a git directory
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "(active) "
    # echo "($(basename $VIRTUAL_ENV))"
  fi
}
export -f show_virtual_env

unset color_prompt force_color_prompt

red=$(tput setaf 1)
# fd --one-file-system -1 -epriv . ~ | grep -q . && printf "%40s\n" "${red}You have .priv files which are unlocked"

greenbold="$(tput setaf 2 bold)"
green="$(tput setaf 2)"
bluebold="$(tput setaf 4 bold)"
redbold="$(tput setaf 1 bold)"
normal="$(tput sgr0)"

cli_symbol () { 
  echo "${CLI_SYMBOL:->}";
}
    export PS1='${greenbold}\u@\h${bluebold} \w${green}$(parse_git_branch)${normal}\n$(cli_symbol) '
PS1='$(show_virtual_env)'$PS1

path_append() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="${PATH:+$PATH:}$1" ;;
    esac
}

path_append "$HOME/.nix-profile/bin"
path_append /nix/var/nix/profiles/default/bin
path_append /usr/local/bin
path_append "$HOME/.local/share/miniforge3/bin"
export PATH
