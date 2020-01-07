#!/bin/bash
# this is just a bodge to set the 'bash_lastdirectory' file to have the selected
# one in nautilus. Then when you load the .bashrc, it opens the last directory
# automatically, which you've just set to be whatever is currently in nautilus.
# This is an ugly way to do it but it works - otherwise you would have to use 
# filemanager-actions package. I tried for a long time to get it working via
# that but with no success.
# You can't use the built-in 'Open In Terminal' in Nautilus because that just
# opens your gnome-terminal to whatever your last directory was. But if you 
# shove in the last_directory file using this method, it works.

# You'll need a simlink in ~/.local/share/nautilus/scripts/ to point to this file. 
# Your setup script should create this automatically.

# When this is installed, you can go to a folder and right click on a file and 
# you will see this 'openinterminal.sh' script as an option. Click it and it 
# will open a terminal. This needs work but will do for now.
echo $NAUTILUS_SCRIPT_CURRENT_URI >> ~/.bash_lastdirectory
gnome-terminal
