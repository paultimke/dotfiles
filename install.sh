#!/bin/bash

###########################################################
# Initialize important variables
###########################################################
SCRIPT_NAME=$(basename $0)
DOTFILES_ROOT_DIR=$(pwd)
HOME_DIR=~

COLOR_OFF='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'

###########################################################
# Check required dependencies
###########################################################
# Verify curl installation
curl --version > /dev/null
if [[ $? -ne 0 ]]; then
    printf "${COLOR_YELLOW}Please install curl before continuing${COLOR_OFF}\n"
    exit 1
fi

# Verify git installation
git --version > /dev/null
if [[ $? -ne 0 ]]; then
    printf "${COLOR_YELLOW}Please install git before continuing${COLOR_OFF}\n"
    exit 1
fi

# Identify operating system
if [ "$OSTYPE" == "cygwin" -o "$OSTYPE" == "msys" -o "$OSTYPE" == "win32" ]
then
    echo "Windows OS detected"
    choco --version > /dev/null
    if [[ $? -ne 0 ]]; then
        printf "${COLOR_YELLOW}Please install the chocolatey package manager to continue${COLOR_OFF}\n"
	exit 1
    fi

    # Install neovim for windows
    printf "${COLOR_GREEN}Installing neovim...${COLOR_OFF}\n"
    choco install neovim -y
else
    echo "POSIX OS detected"
    brew --version > /dev/null
    if [[ $? -ne 0 ]]; then
	# Installation command taken from https://brew.sh/
        printf "${COLOR_GREEN}Installing homebrew package manager${COLOR_OFF}\n"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install neovim for linux or mac
    printf "${COLOR_GREEN}Installing neovim...${COLOR_OFF}\n"
    brew install neovim
fi

###########################################################
# Install and setup software
###########################################################

# Install oh-my-bash
printf "${COLOR_GREEN}Installing oh-my-bash...${COLOR_OFF}\n"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Configuring neovim

###########################################################
# Create symlinks
###########################################################

# Create an array with all the dotfiles in this directory
dotfiles=( $(ls -a) )

# Skip the '.' and '..' directory names
for file in ${dotfiles[@]:2}; do
    echo $file
    # Skip the .git folder in dotfiles directory
    if [ "$file" != ".git" -a "$file" != "$SCRIPT_NAME" -a "$file" != ".gitignore" ]
    then 
        # If file already exists in home, delete it.
        if [ -e "$home_dir/$file" ]; then
            #rm -r "$home_dir/$file"
            echo "File $file already existed. Deleting file"
        fi

        # Create the symlink to the dotfile in the home dir
        #ln -s "$cwd/$file" ~ 
        echo "Creating symlink for $file"
    fi
done
