#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# taken from http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# I have modified this to keep it with the dot prepended to the filename as I prefer it that way TR

# to install, remember to do chmod+x on this install script first before you run it.
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files=".bashrc .profile .inputrc .gitconfig .nanorc"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
    mv ~/$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/$file
done

echo "Creating simlink to nautilus script for right click open in terminal"
ln -s ~/dotfiles/extras/openinterminal.sh  ~/.local/share/nautilus/scripts/OpenInTerminal
chmod +x ~/.local/share/nautilus/scripts/OpenInTerminal

echo ""
echo ""
echo "🐸💡💡💡💡💡💡💡 Reminders 💡💡💡💡💡💡💡🐸"
echo "Remember to rename .gitconfig-example to .gitconfig and fill it in with the right github account for this machine, if you plan to use github from this machine."
echo "You can now enter:"
echo "source ~/.bashrc"
echo "to reload your terminal, or just close your terminal and open a new one."
