#!/bin/sh
GIT_REPO=${GIT_REPO:-"https://github.com/PinLin/dotfiles"}
INSTALL_DIR=${INSTALL_DIR:-"$HOME/.pinlin-dotfiles"}

backupTime=$(date '+%Y%m%d%H%M%S')

setupZsh() {
    # Check if zsh is installed
    if ! command -v zsh > /dev/null 2>&1; then
        echo "Ignore: Zsh is not installed."
        return $(false)
    fi

    if [ -f $HOME/.zshrc ]; then
        cp $HOME/.zshrc $HOME/.zshrc.${backupTime}.bak
    fi

    # Install zim
    if ! [ -d ${ZIM_HOME:-$HOME/.zim} ]; then
        rm $HOME/.zshrc

        if command -v curl > /dev/null 2>&1; then
            curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
        else
            wget -nv -O - https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
        fi
    fi
    # Install powerlevel10k
    cat $HOME/.zimrc | grep "romkatv/powerlevel10k" > /dev/null
    if [ $? -ne 0 ]; then
        echo "# Powerlevel10k" >> $HOME/.zimrc
        echo "zmodule romkatv/powerlevel10k --use degit" >> $HOME/.zimrc
        zsh ${ZIM_HOME:-$HOME/.zim}/zimfw.zsh install

        mv $HOME/.zshrc $HOME/.zshrc.tmp
        echo '# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.' >> $HOME/.zshrc
        echo '# Initialization code that may require console input (password prompts, [y/n]' >> $HOME/.zshrc
        echo '# confirmations, etc.) must go above this block; everything else may go below.' >> $HOME/.zshrc
        echo 'if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then' >> $HOME/.zshrc
        echo '  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"' >> $HOME/.zshrc
        echo 'fi' >> $HOME/.zshrc
        echo '' >> $HOME/.zshrc
        cat $HOME/.zshrc.tmp >> $HOME/.zshrc
        rm $HOME/.zshrc.tmp

        echo "export DOTFILES=$INSTALL_DIR" >> $HOME/.zshrc
        echo "source $INSTALL_DIR/zsh/.zshrc" >> $HOME/.zshrc
        echo "DEFAULT_USER=$USER" >> $HOME/.zshrc
    fi
}

setupVim() {
    # Check if vim is installed
    if ! command -v vim > /dev/null 2>&1; then
        echo "Ignore: Vim is not installed."
        return $(false)
    fi

    if [ -f $HOME/.vimrc ]; then
        mv $HOME/.vimrc $HOME/.vimrc.${backupTime}.bak
    fi

    echo "source $INSTALL_DIR/vim/.vimrc" >> $HOME/.vimrc
}

setupTmux() {
    # Check if tmux is installed
    if ! command -v tmux > /dev/null 2>&1; then
        echo "Ignore: Tmux is not installed."
        return $(false)
    fi

    if [ -f $HOME/.tmux.conf ]; then
        mv $HOME/.tmux.conf $HOME/.tmux.conf.${backupTime}.bak
    fi

    echo "source $INSTALL_DIR/tmux/.tmux.conf" >> $HOME/.tmux.conf
}

main() {
    # Check if git is installed
    if ! command -v git > /dev/null 2>&1; then
        echo "You need to install git before run this script."
        return $(false)
    fi

    # Remove old dotfiles
    if [ -d $INSTALL_DIR ]; then
        rm -rf $INSTALL_DIR
    fi

    # Clone dotfiles repo
    git clone $GIT_REPO $INSTALL_DIR
    if [ $? != 0 ]; then
        echo "Failed to clone the repository."
        return 1
    fi
    cd $INSTALL_DIR

    setupZsh
    setupVim
    setupTmux

    echo
    echo "Done! Your shell is ready to go, open a new shell to use it."
}

main
