# check reqiurements
fail=0
for app in "wget" "curl" "git" "vim"; do
    if ! command -v $app 1>/dev/null; then 
        if [ $fail == 0 ]; then 
            echo 
            echo -n 'Please install'
            fail=1
        else
            echo -n ','
        fi
        echo -n ' `'$app'`'
    fi
done
if [ $fail == 1 ]; then
    echo ' before run this script.'
    exit 1
fi

# clone into computer
git clone https://github.com/PinLin/.shconf ~/.shconf
if [ $? != 0 ]; then
    echo 
    echo 'Error occurred when cloning, please confirm your Network.'
    exit 2
fi
cd ~/.shconf

# setup vim
if ! [ -f ~/.vimrc.bak ]; then
    if [ -f ~/.vimrc ]; then 
        mv ~/.vimrc ~/.vimrc.bak 
    fi
fi
echo 'source ~/.shconf/vim/sample.vimrc' > ~/.vimrc


# setup zsh
# install oh-my-zsh and configure
sudo chsh -s `which zsh` $USER
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
if ! [ -f ~/.zshrc.bak ]; then
    if [ -f ~/.zshrc ]; then 
        mv ~/.zshrc ~/.zshrc.bak 
    fi
fi
echo 'source ~/.shconf/zsh/sample.zshrc' > ~/.zshrc
# install zsh-autosuggestions
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# pause
if ! command -v pause 1>/dev/null; then
    alias pause="$HOME/.pause/bin/pause"
    wget -qO- https://raw.githubusercontent.com/PinLin/EHG/master/pause/install.sh | bash
fi