# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#Configuration
# www_dir=

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

 # Set the titlebar & prompt to "[user@host:/full/path]\n$"
    case "$TERM" in
        xterm*)
            Titlebar="\u@\h:\$PWD"
            echo -ne "\e]2;$USER@$(hostname -s):$PWD\a"
            ;;
        *)
            Titlebar=""
            ;;
    esac
 # Git prompt
    function vcsprompt
    {
        # Walk up the tree looking for a .git or .hg directory
        # This is faster than trying each in turn and means we get the one
        # that's closer to us if they're nested
        root=$(pwd 2>/dev/null)
        while [ ! -e "$root/.git" -a ! -e "$root/.hg" ]; do
          if [ "$root" = "" ]; then break; fi
          root=${root%/*}
        done

        if [ -e "$root/.git" ]; then
            # Git
            relative=${PWD#$root}
            if [ "$relative" != "$PWD" ]; then
                echo -en "$root\e[36;1m$relative"
                #         ^yellow  ^aqua
            else
                echo -n $PWD
                #       ^yellow
            fi

            # Show the branch name / tag / id
            branch=`git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
            if [ -n "$branch" -a "$branch" != "(no branch)" ]; then
                echo -e "\e[30;1m on \e[35;1m$branch \e[0m(git)\e[30;1m"
                #        ^grey       ^pink           ^light grey  ^ grey
            else
                tag=`git describe --always 2>/dev/null`
                if [ -z "$tag" ]; then
                    tag="(unknown)"
                fi
                echo -e "\e[30;1m at \e[35;1m$tag \e[0m(git)\e[30;1m"
                #        ^grey       ^pink        ^light grey  ^ grey
            fi
        else
            # No .git found
            echo $PWD
        fi
    }
    # Function to update the prompt with a given message (makes it easier to distinguish between different windows)
   function MSG
    {
        # Display the provided message above the prompt and in the titlebar
        if [ -n "$*" ]; then
            MessageCode="\e[35;1m================================================================================\n $*\n================================================================================\e[0m\n"
            TitlebarCode="\[\e]2;[$*] $Titlebar\a\]"
        else
            MessageCode=
            TitlebarCode="\[\e]2;$Titlebar\a\]"
        fi

        # If changing the titlebar is not supported, remove that code
        if [ -z "$Titlebar" ]; then
            TitlebarCode=
        fi

        # Set the prompt
        PS1="${TitlebarCode}\n"                 # Titlebar (see above)
        PS1="${PS1}${MessageCode}"              # Message (see above)
        PS1="${PS1}\[\e[30;1m\]["               # [                             Grey
        PS1="${PS1}\[\e[31;1m\]\u"              # Username                      Red
        PS1="${PS1}\[\e[30;1m\]@"               # @                             Grey
        PS1="${PS1}\[\e[32;1m\]\h"              # Hostname                      Green
        PS1="${PS1}\[\e[30;1m\]:"               # :                             Grey
        PS1="${PS1}\[\e[33;1m\]\`vcsprompt\`"   # Working directory / Git / Hg  Yellow
        PS1="${PS1}\[\e[30;1m\]]"               # ]                             Grey
        PS1="${PS1}\[\e[1;35m\]\$KeyStatus"     # SSH key status                Pink
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
    alias ls='ls -hF --color=always'
    alias ll='ls -hFl --color=always'
    alias la='ls -hFA --color=always'
    alias lla='ls -hFlA --color=always'
    alias llo='ls -hFlA --color=always | less'

 function l {
        if [ -z "$*" ]; then
            c .
        else
            ls -hFlA --color=always $@
        fi
    }

 function cf {
  # if you input a filename, go to the path of that filename.
  cd $( dirname $@ )

 }
     # u = up
    alias u='c ..'
    alias uu='c ../..'
    alias uuu='c ../../..'
    alias uuuu='c ../../../..'
    alias uuuuu='c ../../../../..'
    alias uuuuuu='c ../../../../../..'
# Grep with colour and use pager
    # Note: This has to be a script not a function so it can detect a pipe
    # But the script cannot be called "grep", because that gets called by scripts
    # So we have a function "grep" calling a script "grep-less"
    # function grep {
      #  grep-less "$@"
    # }

    # If output fits on one screen, don't use less
    export LESS=FRSX

    # Unset the colours that are sometimes set (e.g. Joshua)
    export LS_COLORS=

    # md = mkdir; cd
    function md {
        mkdir "$1" && cd "$1"
    }

    # c = cd; ls
    function c {

        # cd to the first argument
        if [ "$1" = "" ]; then
            # If none then go to ~ like cd does
            cd || return
        elif [ "$1" != "." ]; then
            # If "." don't do anything, so that "cd -" still works
            # Dont output the path as Im going to anyway (done by "cd -" and cdspell)
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
        ls -hFlA --color=always "$@"

    }

    export -f c

# b = back
    alias b='c -'
    function l {
        if [ -z "$*" ]; then
            c .
        else
          ls -hFlA --color=always $@
        fi
    }

    # /home/www shortcuts
        if [ -n "$www_dir" ]; then
            alias cw="c $www_dir"
        fi

  

# Remember the last directory visited
    function cd {
        command cd "$@" && pwd > ~/.bash_lastdirectory
    }

# output cheatsheet if it exists
   function cheats {
	if [ -z "$*" ]; then
		less ~/dotfiles/extras/cheatsheets/cheatsheet.txt
	else
		if [ "$1" == "list" ]; then
			ls ~/dotfiles/extras/cheatsheets
		else
			less ~/dotfiles/extras/cheatsheets/$1.txt
		fi
	fi
   }
 # Go to my home directory by default
    #command cd    
    

     # Go to the stored directory now, if possible
    if [[ -f ~/.bash_lastdirectory ]]; then
        # Throw away errors about that directory not existing (any more)
        command cd "`cat ~/.bash_lastdirectory`" 2>/dev/null
    fi
    
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

    if [ -f /usr/share/sounds/freedesktop/stereo/complete.oga ]; then
      alias playbell='paplay /usr/share/sounds/freedesktop/stereo/complete.oga'
    fi

    alias pw='ping wikipedia.org -c 3'
    alias bashrl='source ~/.bashrc'

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
    ls -hFA
fi



# Git Cygwin loads this file *and* .bash_profile so set a flag to tell
# .bash_profile not to load .bashrc again
BASHRC_DONE=1
