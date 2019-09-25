# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#Configuration
www_dir=

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

if [ -f ~/.bashrc_config ]; then
    source ~/.bashrc_config
fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
 
# Add my own bin directories to the path
export PATH="$HOME/local/bin:$HOME/bin:$HOME/opt/git-extras/bin:$PATH"

# Favourite programs
export PAGER=less
export VISUAL=nano
export EDITOR=nano

# Don't do the rest of these when using SCP, only an SSH terminal
if [ "$TERM" != "dumb" -a -z "$BASH_EXECUTION_STRING" ]; then

    # Function to update the prompt with a given message (makes it easier to distinguish between different windows)
    function MSG
    {
        
        # Set the prompt        
        PS1=
        PS1="${PS1}\[\e[30;1m\]["               # [                             Grey
        PS1="${PS1}\[\e[31;1m\]\u"              # Username                      Red
        PS1="${PS1}\[\e[30;1m\]@"               # @                             Grey
        PS1="${PS1}\[\e[32;1m\]\h"              # Hostname                      Green
        PS1="${PS1}\[\e[30;1m\]:"               # :                             Grey
        PS1="${PS1}\[\e[33;1m\]$PWD"            # Working directory / 
        PS1="${PS1}\[\e[30;1m\]]"               # ]                             Grey
        PS1="${PS1}\n"                          # (New line)
        PS1="${PS1}\[\e[31;1m\]\\\$"            # $                             Red
        PS1="${PS1}\[\e[0m\] "
    }

    # Default to prompt with no message
    MSG

    # For safety!
    alias cp='cp -i'
    alias mv='mv -i'
    alias rm='rm -i'

    # Various versions of `ls`


     # Unset the colours that are sometimes set (e.g. Joshua)
    export LS_COLORS=

    # Alias definitions.
    alias l='ls -hF --color=always'
    alias ls='ls -hF --color=always'
    alias ll='ls -hFl --color=always'
    alias la='ls -hFA --color=always'
    alias lla='ls -hFlA --color=always'

     # u = up
    alias u='c ..'
    alias uu='c ../..'
    alias uuu='c ../../..'
    alias uuuu='c ../../../..'
    alias uuuuu='c ../../../../..'
    alias uuuuuu='c ../../../../../..'

    # c = cd; ls
    function c {

        # cd to the first argument
        if [ "$1" = "" ]; then
            # If none then go to ~ like cd does
            cd || return
        elif [ "$1" != "." ]; then
            # If "." don't do anything, so that "cd -" still works
            # Don't output the path as I'm going to anyway (done by "cd -" and cdspell)
            cd "$1" >/dev/null || return
        fi

        # Remove that argument
        shift

        # Output the path
        echo
        echo -en "\e[4;1m"
        echo $PWD
        echo -en "\e[0m"

        # Then pass the rest to ls (just in case we have any use for that!)
        ls -h --color=always "$@"

    }

    export -f c

    function l {
        if [ -z "$*" ]; then
            c .
        else
            ls -hF --color=always $@
        fi
    }

    # /home/www shortcuts
        if [ -n "$www_dir" ]; then
            alias cw="c $www_dir"
        fi

    # b = back
    alias b='c -'

    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi

    # Ignore case
    set completion-ignore-case on

    # Start typing then use Up/Down to see *matching* history items
        bind '"\e[A":history-search-backward'
        bind '"\e[B":history-search-forward'

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

fi # $TERM != "dumb"

# Prevent errors when MSG is set in .bashrc_local
if [ "$TERM" = "dumb" -a -z "$BASH_EXECUTION_STRING" ]; then
    function MSG {
        : Do nothing
    }
fi

# Custom settings for this machine/account
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# *After* doing the rest, show the current directory contents
# But only do this once - gitolite seems to load this file twice!
if [ "$TERM" != "dumb" -a -z "$BASH_EXECUTION_STRING" ]; then
    # Welcome message if it exists
    if [ -f ~/.name ]; then
      cat ~/.name 
    fi
    #output the current directorys contents
    l 
fi



# Git Cygwin loads this file *and* .bash_profile so set a flag to tell
# .bash_profile not to load .bashrc again
BASHRC_DONE=1

