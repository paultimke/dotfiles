#!/bin/bash

# Get the name of the current working directory (dotfiles folder)
cwd=${PWD##*/}
cwd=${cwd:-/}

# Create an array with all the dotfiles in this directory
dotfiles=( $(ls -a) )

# Skip the '.' and '..' directory names
for file in ${dotfiles[@]:2}; do
    # Skip the .git folder in dotfiles directory
    if [ "$file" != ".git" ] && [ "$file" != "install.sh" ]
    then 
        # If file already exists in home, delete it.
        if [ -e "~/$file" ]; then
            rm -r "~/$file"
            echo "File $file already existed. Deleting file"
        fi

        # Create the symlink to the dotfile in the home dir
        ln -s "$cwd/$file" ~ 
        echo "Creating symlink for $file"
    fi
done
