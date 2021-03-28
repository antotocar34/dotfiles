#  ____    _    ____  _   _ ____   ____ 
# | __ )  / \  / ___|| | | |  _ \ / ___|
# |  _ \ / _ \ \___ \| |_| | |_) | |    
# | |_) / ___ \ ___) |  _  |  _ <| |___ 
# |____/_/   \_\____/|_| |_|_| \_\\____|

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

source ${HOME}/.nix-profile/share/fzf/key-bindings.bash
source ${HOME}/.nix-profile/share/fzf/completion.bash
# export LOCALE_ARCHIVE="${HOME}/.nix-profile/lib/locale/locale-archive"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# REMOVE THIS AFTER RESTART
export FZF_CTRL_T_COMMAND="fd -I --hidden --follow -E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*' . $HOME"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .stack --ignore .cabal --ignore .cache --ignore .git --ignore .vim --ignore .local -l -g ""'

# VARIABLE DECLARATIONS
export BFETCH="${HOME}/Documents/Programming/Python/automation/bfetch"
export TERMINAL="kitty"

# PYTHON SCRIPTS
export PYTHON_DIR="${HOME}/Documents/Programming/Python"
export SCRIPT_DIR="${HOME}/Documents/Scripts"
alias bfetch="cd ${PYTHON_DIR}/automation/bfetch && poetry run python bfetch/main.py"
alias fsort="python ${PYTHON_DIR}/automation/file_sort/file_sorter.py"
alias dsort="cd ${HOME}/Downloads && python ${PYTHON_DIR}/automation/pdf_sort/pdf_sort.py"
alias musicdl="youtube-dl -x --add-metadata"
alias prun="poetry run python"

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

# alias draw="draw"

function dir_find {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --hidden --follow $exclusions -td . $HOME"""
    dir=$($cmd | fzf)
    if [[ $? -eq 130 ]]; then
        true
    else
        cd $dir
    fi
}

function file_find {
    exclusions="-E '*.git' -E '*.stack*' -E '*.cache*' -E '*.local' -E '*.cabal/*' -E '*.ghcup*' -E '*.vim*'"
    cmd="""fd -I --hidden --follow $exclusions -tf . $HOME"""
    FILE=$($cmd | fzf)
    if [[ $? -eq 130 ]]; then
        true
    else
        vim $FILE
    fi
}

# CD SHORTCUTS
alias fk=dir_find
alias fw=file_find
# alias fw='vim $(tree -fi $HOME | fzf) 2> /dev/null'
alias lat="cd ~/Documents/Latex"
alias d="cd ~/Documents/"
alias dl="cd ~/Downloads/"
alias conf="cd ~/.config/nixpkgs"

if [ $TERM = "xterm-kitty" ] ; then
    alias ssh="kitty +kitten ssh"
fi

alias z='zathura'
alias jnote="cd ${PYTHON_DIR}/notebooks && jupyter notebook --browser=chromium 2> /dev/null"
alias coll="cd ${HOME}/Documents/College/4/Michaelmas"
 
# launch and disown program
function launch {
    nohup $1 >/dev/null 2>/dev/null & disown; exit
}

# PROGRAM SHORTCUTS
alias mv="mv -iv"
alias :q="exit"
alias f="vifm ."
alias c="clear"
alias pydebug="python -m pdb"
alias sdn="shutdown now"
alias texclean="rm -f *.synctex.gz *.aux *.log *.fls *.fdb_latexmk *.dvi *.bbl *.blg"
alias xc="xclip -selection clipboard"
alias stata="launch xstata-mp"
alias sxhkdreset="killall sxhkd && launch sxhkd"
alias drun="docker run -it --rm "
alias hs="home-manager switch"

# FILE SHORTCUTS
CONF_FILES="${HOME}/.config/nixpkgs/extraConfigs"
alias notes="vim ${CONF_FILES}/../homedir/.notes"
alias bib='vim ~/Documents/Latex/bibmaster.bib'
alias vimrc="vim ${CONF_FILES}/.config/nvim/init.vim"
alias bashrc="vim ${CONF_FILES}/.bashrc"
alias sxhkdrc="vim ${CONF_FILES}/.config/sxhkd/sxhkdrc"
alias snipp="vim ${CONF_FILES}/.vim/my-snippets/tex.snippets"

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
# not sure if this is required
test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

bind "set editing-mode vi"
bind "set show-mode-in-prompt on"
# bind "set vi-cmd-mode-string '\1\e[2 q\2'"
# bind "set vi-ins-mode-string '\1\e[6 q\2'"
bind "set vi-ins-mode-string \"\1\e[2 q\e]12;white\a\2\""
bind "set vi-cmd-mode-string \"\1\e[2 q\e]12;orange\a\2\""
bind -x '"\C-l": clear'

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Show which branch you are on if there is a git directory
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [ -z $TDROP ] ; then

        export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]\[\033[01;34m\] \w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\]\nλ '


else
    bind -x '"\C-j":"tdrop current"'
    if [ $TDROP = "red" ] ; then
        export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]\[\033[01;34m\] \w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\]\n\e[0;31mλ \e[m'

    else
        export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]\[\033[01;34m\] \w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\]\n\e[0;36mλ \e[m'

    fi
fi

show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "(active) "
    # echo "($(basename $VIRTUAL_ENV))"
  fi
}
export -f show_virtual_env
PS1='$(show_virtual_env)'$PS1
# PS1="${CUSTOM_PS1}${PS1}"

unset color_prompt force_color_prompt

source ${HOME}/.nix-profile/etc/profile.d/nix.sh

export HOST=$HOSTNAME

export XDG_DATA_DIRS="/usr/local/share/:/usr/share/:$XDG_DATA_DIRS"
export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"

# PATH VARIABLE DECLARATIONS
export PATH="${HOME}/.local/bin:$PATH"
export PATH="${HOME}/Documents/Scripts:$PATH"
export PATH="${HOME}/Documents/Scripts/inkscape-draw:$PATH"
# export PATH="/opt/Stata/stata14/:$PATH"
export PATH="${HOME}/.cabal/bin/stylish-haskell:$PATH"


# For direnv
eval "$(direnv hook bash)"
