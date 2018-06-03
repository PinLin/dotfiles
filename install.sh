#! /usr/bin/env bash

NAME=".shconf"
URL="https://github.com/PinLin/$NAME"

# Install application
function makeInstall {
    # Check argc
    if [ $# -ge 1 ]; then
        # macOS
        if isInstalled brew; then
            brew install $1
            return $?
        
        # Debian / Ubuntu
        elif isInstalled apt; then
            sudo apt install $1 -y
            return $?

        elif isInstalled apt-get; then
            sudo apt-get install $1 -y
            return $?

        # Fedora / CentOS
        elif isInstalled dnf; then
            sudo dnf -y install $1
            return $?

        elif isInstalled yum; then
            sudo yum -y install $1
            return $?

        # Embedded
        elif isInstalled ipkg; then
            sudo ipkg install $1
            return $?

        elif isInstalled opkg; then
            sudo opkg install $1
            return $?

        # None
        else
            return 87

        fi
    else
        return -1
    fi
}

# Ask for question
function askQuestion {
    # Check argc
    if [ $# -ge 2 ]; then
        # default yes
        if [ "$2" == "Yn" ]; then
            # Display question
            echo -n "$1 [Y/n] "
            # Input answer
            read ans
            for no in 'n' 'N' 'no' 'No' 'NO' 'nO'; do
                if [ "$ans" == "$no" ]; then ans="n"; break; fi
            done
        fi
        if [ "$ans" != "n" ]; then ans="y"; fi
        # default no
        if [ "$2" == "yN" ]; then
            # Display question
            echo -n "$1 [y/N] "
            # Input answer
            read ans
            for yes in 'y' 'Y' 'ye' 'Ye' 'yE' 'YE' 'yes' 'Yes' 'yEs' 'yeS' 'YEs' 'yES' 'YeS' 'YES'; do
                if [ "$ans" == "$yes" ]; then ans="y"; break; fi
            done
        fi
        if [ "$ans" != "y" ]; then ans="n"; fi
        # result
        [ "$ans" == "y" ]
        return $?
    else
        return -1
    fi
}

function main {

    # Require git
    if ! command -v git > /dev/null 2>&1; then
        # Ask for install git
        if askQuestion "You must install git, but do you want to install git?" "Yn"; then
            makeInstall git
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        else
            return 0
        fi
    fi

    # Remove local repo if exist
    if [ -d ~/$NAME ]; then
        rm -rf ~/$NAME
    fi

    # Clone repo
    git clone $URL ~/$NAME
    if [ $? != 0 ]; then
        echo "Could not clone $NAME."
        return 1
    fi

    # Require zsh
    if ! command -v zsh > /dev/null 2>&1; then
        # Ask for install zsh
        if askQuestion "You must install zsh, but do you want to install zsh?" "Yn"; then
            makeInstall zsh
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        else
            return 0
        fi
    fi
    # Config zsh
    if command -v zsh > /dev/null 2>&1; then
        # Require oh-my-zsh
        if ! [ -d ~/.oh-my-zsh ]; then
            if isInstalled curl; then
                curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh//g' | bash
            elif isInstalled wget; then
                wget -qO- https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh//g' | bash
            fi
        fi
        # Install zsh-autosuggestions
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi
        # Install zsh-syntax-highlighting
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi
        if [ -f ~/.zshrc ]; then
            mv ~/.zshrc ~/.zshrc.bak
        fi
        echo "source ~/$NAME/config/zsh/sample.zshrc" >> ~/.zshrc
    fi

    # Check vim
    if ! command -v vim > /dev/null 2>&1; then
        # Ask for install vim
        if askQuestion "Do you want to install vim?" "yN"; then
            makeInstall vim
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        fi
    fi
    # Config vim
    if command -v vim > /dev/null 2>&1; then
        if [ -f ~/.vimrc ]; then
            mv ~/.vimrc ~/.vimrc.bak
        fi
        echo "source ~/$NAME/config/vim/sample.vimrc" >> ~/.vimrc
    fi

    # Check tmux
    if ! command -v tmux > /dev/null 2>&1; then
        # Ask for install tmux
        if askQuestion "Do you want to install tmux?" "yN"; then
            makeInstall tmux
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        fi
    fi
    # Config tmux
    if command -v tmux > /dev/null 2>&1; then
        if [ -f ~/.tmux.conf ]; then
            mv ~/.tmux.conf ~/.tmux.conf.bak
        fi
        echo "source ~/$NAME/config/tmux/sample.tmux.conf" >> ~/.tmux.conf
    fi

    # Check tmux
    if ! command -v tmux > /dev/null 2>&1; then
        # Ask for install tmux
        if askQuestion "Do you want to install tmux?" "yN"; then
            makeInstall tmux
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        fi
    fi
    # Config tmux
    if command -v tmux > /dev/null 2>&1; then
        if [ -f ~/.tmux.conf ]; then
            mv ~/.tmux.conf ~/.tmux.conf.bak
        fi
        echo "source ~/$NAME/config/tmux/sample.tmux.conf" >> ~/.tmux.conf
    fi

    # Check tmux
    if ! command -v tmux > /dev/null 2>&1; then
        # Ask for install tmux
        if askQuestion "Do you want to install tmux?" "yN"; then
            makeInstall tmux
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        fi
    fi
    # Config tmux
    if command -v tmux > /dev/null 2>&1; then
        if [ -f ~/.tmux.conf ]; then
            mv ~/.tmux.conf ~/.tmux.conf.bak
        fi
        echo "source ~/$NAME/config/tmux/sample.tmux.conf" >> ~/.tmux.conf
    fi

    # Check pause
    if ! command -v pause > /dev/null 2>&1; then
        # Ask for install pause
        if askQuestion "Do you want to install pause?" "yN"; then
            # pre-alias pause
            alias pause='~/.pause/bin/pause'
            # Install by `curl` or `wget`
            curl -L https://raw.githubusercontent.com/PinLin/pause/master/install.sh | bash || \
            wget -O- https://raw.githubusercontent.com/PinLin/pause/master/install.sh | bash
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        fi
    fi

    # Check sl
    if ! command -v sl > /dev/null 2>&1; then
        # Ask for install sl
        if askQuestion "Do you want to install sl?" "yN"; then
            makeInstall sl
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        fi
    fi

    # Finished
    echo
    echo Done! $NAME was installed.
}

main
