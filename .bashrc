# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# number of history entries
HISTSIZE=1000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Setup the colorized prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export TERM=xterm-256color

alias gdb='gdb -q'

alias emacs='emacsclient -t -a ""'
export EDITOR='emacsclient -t -a ""'
function kill-emacs-daemon {
    ps ux | grep 'emacs --daemon' | grep -v 'grep' | awk '{ print $2 }' | xargs kill
}

# refined history search (up/down arrows) to typed characters.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# handy aliases for ls
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# colorized grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# can't remember what this does
alias less='less -R'

# because I'm lazy
alias agi='sudo apt-get install'

# Highlights a word or whatever in red  within a stream.
function hl {
    sed -r "s/(${1})/$(tput setaf 1)$(tput bold)\1$(tput sgr0)/g"
}

function fail-test {
    make -n test 2>&1 | egrep "^rm -f build/x86_64/tests/.+\.\{passed,failed\}.*" | sed -r "s#^rm -f build/x86_64/tests/(.+)\.\{passed,failed\}.*#\\1#"
}

if [ -f /usr/lib/debug/boot/vmlinux-$(uname -r) ]; then
    alias perf-report='perf report -k /usr/lib/debug/boot/vmlinux-$(uname -r)'
    alias perf-script='perf script -k /usr/lib/debug/boot/vmlinux-$(uname -r)'
fi

# env specific aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
