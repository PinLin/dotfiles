#! /usr/bin/env bash

NAME=".shconf"
URL="https://github.com/PinLin/$NAME"

# Install application
makeInstall() {
    # Check counts of arguments
    if [ $# -lt 1 ]; then
        return -1
    fi
    
    # Judge which is the package manager we used
    kernel=$(uname -s)
    if [ "$kernel" = "Darwin" ]
    then
        if command -v brew > /dev/null 2>&1
        then
            # macOS with brew
            brew install $1
            return $?
        else
            echo "You need to install Homebrew on your macOS before runing this script."
            echo See this: https://brew.sh
            return 87
        fi
        
    elif [ "$kernel" = "FreeBSD" ]
    then
        if command -v pkg > /dev/null 2>&1
        then
            # FreeBSD with pkg
            sudo pkg install -y $1
            return $?
        else
            echo "You need to install PKGNG on your FreeBSD before runing this script."
            echo See this: https://wiki.freebsd.org/pkgng
            return 87
        fi
        
    elif [ "$kernel" = "Linux" ]
    then
        if command -v lsb_release > /dev/null 2>&1
        then
            os=$(echo $(lsb_release -i | cut -d ':' -f 2))
        else
            os=''
        fi

        case $os in
            "Debian"|"Ubuntu")
                # Debian/Ubuntu with apt-get
                sudo apt-get install -y $1
                return $?
            ;;

            "Fedora"|"CentOS")
                if command -v dnf > /dev/null 2>&1
                then
                    # Fedora/CentOS with dnf
                    sudo dnf install -y $1
                    return $?
                else
                    # Fedora/CentOS with yum
                    sudo yum install -y $1
                    return $?
                fi
            ;;

            *)
                if command -v ipkg > /dev/null 2>&1; then
                    # Embedded Device with ipkg
                    sudo ipkg install $1
                    return $?
                fi

                if command -v opkg > /dev/null 2>&1; then
                    # Embedded Device with opkg
                    sudo opkg install $1
                    return $?
                fi
            ;;
        esac
    fi 
}


# Ask for question
askQuestion() {
    # Check counts of arguments
    if [ $# -lt 2 ]; then
        return -1
    fi

    # Ask
    if [ "$2" = "Yn" ]
    then
        # Display question and default yes
        echo -n $1 [Y/n]' '; read ans
        case $ans in
            [Nn*])
                return 1
                ;;
            *)
                return 0
                ;;
        esac
    else
        # Display question and default no
        echo -n $1 [y/N]' '; read ans
        case $ans in
            [Yy*]) 
                return 0
                ;;
            *) 
                return 1
                ;;
        esac
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
            sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh//g')" || \
            sh -c "$(wget -qO- https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh//g')"
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

    # Check pause
    if ! command -v pause > /dev/null 2>&1; then
        # Ask for install pause
        if askQuestion "Do you want to install pause?" "yN"; then

            # Check gcc
            if ! command -v gcc > /dev/null 2>&1; then
                # Ask for install gcc
                if askQuestion "Do you want to install gcc?" "yN"; then
                    makeInstall gcc
                    result=$?; if [ $result -ne 0 ]; then return $result; fi
                fi
            fi
            
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
