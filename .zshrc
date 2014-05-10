# ==================== General ====================

autoload -Uz compinit && compinit
autoload -U promptinit && promptinit
autoload -U colors && colors

setopt AUTO_CD
setopt CORRECT
setopt HIST_IGNORE_ALL_DUPS
setopt MULTIOS
setopt NO_BEEP

# ==================== Style ====================

export TERM='xterm-256color'

# Prompt
# Time= [%*]
PROMPT="%{$fg_bold[white]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}: %1~> "

# Menu completion
zstyle ':completion:*' menu select

# Enhance ls colours
eval $(dircolors -b)


# ==================== History ====================

HISTFILE=~/.histfile
HISTSIZE=100
SAVEHIST=100


# ==================== Aliases ====================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias dirs='dirs -v'

alias ls='ls --color=auto'
alias la='ls -la'
alias ll='ls -l'
alias l1='ls -1'

alias grep='grep --color=auto'

alias mkdir='mkdir -p -v'

alias rm='rm -Iv --one-file-system'

alias mv='mv -iv'

alias shred='shred -v'

# Copy / paste aliases
alias c='xclip -selection c'
alias v='xclip -o'

# Power controls
alias shutdown='sudo shutdown'
alias halt='sudo halt'
alias poweroff='sudo poweroff'
alias reboot='sudo reboot'


# ==================== Keys ====================

typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# Setup key accordingly

[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }

    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }

    zle -N zle-line-init
    zle -N zle-line-finish
fi

# This remembers the directory stack
# Use dirs -v to view
# Use cd -<num> to change to one of them

#DIRSTACKFILE="$HOME/.cache/zsh/dirs"
# Keep a separate dirstack file for each terminal
DIRSTACKFILE=`mktemp`
trap "rm -rf $DIRSTACKFILE" EXIT

# Reloads the last directory from the stack and changes to it
#if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
#    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
#    [[ -d $dirstack[1] ]] && cd $dirstack[1]
#fi

chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt autopushd pushdsilent pushdtohome

# Remove duplicate entries
setopt pushdignoredups
# This reverts the +/- operators.
setopt pushdminus
