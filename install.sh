#!/bin/sh
INSTALL_DIR=${INSTALL_DIR:-"$HOME/.pinlin-dotfiles"}

setupZsh() {
    # Check if zsh is installed
    if ! command -v zsh > /dev/null 2>&1; then
        echo "Ignore: Zsh is not installed."
        return $(false)
    fi

    # Install oh-my-zsh
    if ! [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom} ]; then
        export RUNZSH=no

        if command -v curl > /dev/null 2>&1; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        else
            sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        fi
    fi
    # Install powerlevel10k
    if ! [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
    # Install zsh-autosuggestions
    if ! [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    # Install zsh-syntax-highlighting
    if ! [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

    if [ -f $HOME/.zshrc ]; then
        mv $HOME/.zshrc $HOME/.zshrc.$(date '+%Y%m%d%H%M%S').bak
    fi
    echo "export DOTFILES=$INSTALL_DIR" >> $HOME/.zshrc
    echo "source $INSTALL_DIR/zsh/.zshrc" >> $HOME/.zshrc
    echo "DEFAULT_USER=$USER" >> $HOME/.zshrc
}

setupVim() {
    # Check if vim is installed
    if ! command -v vim > /dev/null 2>&1; then
        echo "Ignore: Vim is not installed."
        return $(false)
    fi

    if [ -f $HOME/.vimrc ]; then
        mv $HOME/.vimrc $HOME/.vimrc.$(date '+%Y%m%d%H%M%S').bak
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
        mv $HOME/.tmux.conf $HOME/.tmux.conf.$(date '+%Y%m%d%H%M%S').bak
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
    git clone https://github.com/PinLin/dotfiles $INSTALL_DIR
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
