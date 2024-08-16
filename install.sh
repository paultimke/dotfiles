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

    # Install packer for neovim
    ls $HOME_DIR/AppData/Local/nvim-data/site/pack/packer/start  > /dev/null
    if [[ $? -ne 0 ]]; then
        git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
    fi

else
    echo "POSIX OS detected"
    brew --version > /dev/null
    if [[ $? -ne 0 ]]; then
	# Installation command taken from https://brew.sh/
        printf "${COLOR_GREEN}Installing homebrew package manager${COLOR_OFF}\n"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /root/.bashrc
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    # Install neovim for linux or mac
    nvim --version > /dev/null
    if [[ $? -ne 0 ]]; then
	printf "${COLOR_GREEN}Installing neovim...${COLOR_OFF}\n"
	brew install neovim
    fi

    # Install packer for neovim
    ls ~/.local/share/nvim/site/pack/packer/start > /dev/null
    if [[ $? -ne 0 ]]; then
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
fi

###########################################################
# Install and setup software
###########################################################

# Install oh-my-bash
ls ${HOME_DIR}/.oh-my-bash > /dev/null
if [[ $? -ne 0 ]]; then
    printf "${COLOR_GREEN}Installing oh-my-bash...${COLOR_OFF}\n"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
fi

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
    if [ "$file" != ".git" -a "$file" != "$SCRIPT_NAME" -a "$file" != ".gitignore" -a "$file" != "aliases.txt" ]
    then 
        # If file already exists in home, delete it.
        if [ -e "$HOME_DIR/$file" ]; then
            #rm -r "$home_dir/$file"
            echo "File $file already existed"
            continue
        fi

        # Create the symlink to the dotfile in the home dir
        echo "Creating symlink for $file"
        ln -s "$DOTFILES_ROOT_DIR/$file" ~ 
    fi
done
