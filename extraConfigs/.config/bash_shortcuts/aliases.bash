. ${HOME}/.config/nixpkgs/extraConfigs/.config/bash_shortcuts/functions.bash

CONF_FILES="${HOME}/.config/nixpkgs/extraConfigs"
WIKI_LOC="${HOME}/Documents/Notes/vimwiki"
alias musicdl="yt-dlp -ic -f bestaudio[ext=m4a] --embed-thumbnail --add-metadata"
alias kconvert="rm /tmp/mbt-* ; rm -r /tmp/mobi* ; kcc-c2e --format=MOBI -mu --profile=KPW --splitter=2"
alias prun="poetry run python"

# CD SHORTCUTS
alias fk=dir_find
alias fw=file_find
alias fj=local_dir_find
# alias fw='vim $(tree -fi $HOME | fzf) 2> /dev/null'
alias lat="cd ~/Documents/Latex"
alias d="cd ~/Documents/"
alias dl="cd ~/Downloads/"
alias conf="cd ${HOME_MANAGER_CONFIG}"
alias tempd="cd $(mktemp -d)"

# PROGRAM SHORTCUTS
alias mv="mv -iv"
alias :q="exit"
alias f="vifm ."
alias c="clear"
alias pydebug="python -m pdb"
alias sdn="shutdown now"
alias icat='kitty +icat'
# alias texclean="rm -f *.synctex.gz *.aux *.log *.fls *.fdb_latexmk *.dvi *.bbl *.blg"
alias texclean="fd -uu -esynctex.gz -eaux -elog -efls -efdb_latexmk -edvi -ebbl -eblg --search-path ${HOME}/Documents/Latex -x rm"
alias xc="xclip -selection clipboard"
alias tmr="transmission-remote"
alias stata="launch xstata-mp"
alias sxhkdreset="killall sxhkd && launch sxhkd"
alias drun="docker run -it --rm "
alias hs="fd -uu -eold_version . -p "${HOME}" -x rm && home-manager -b old_version switch --impure --flake $HOME_MANAGER_CONFIG"
alias he="nvim ${HOME_MANAGER_CONFIG}/home.nix"
alias z=zathura

# FILE SHORTCUTS
alias notes="${EDITOR} ${WIKI_LOC}/index.wiki"
alias diary="${EDITOR} ${WIKI_LOC}/diary/diary.wiki"
alias bib="${EDITOR} ~/Documents/Latex/bibmaster.bib"
alias vimrc="${EDITOR} ${CONF_FILES}/.config/nvim/init.vim"
alias bashrc="${EDITOR} ${CONF_FILES}/.bashrc"
alias sxhkdrc="${EDITOR} ${CONF_FILES}/.config/sxhkd/sxhkdrc"
alias snipp="${EDITOR} ${CONF_FILES}/.config/nvim/my-snippets/"
alias flog="${EDITOR} $LEDGER_FILE"
alias fupdate="git add ${FINANCE_DIR}/journal.ledger && git commit -m 'Logged today's transactions'"
