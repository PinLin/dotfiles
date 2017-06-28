# set constant
repo='.shconf'

# check reqiurements
fail=0
for app in "git" "vim" "zsh"; do
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
if ! [ -d ~/.oh-my-zsh ]; then
    echo 'You should install `oh-my-zsh` before run this script.'
    exit 1
fi

# clone into computer
if [ -d ~/$repo ]; then
    rm -rf ~/$repo
fi
git clone https://github.com/PinLin/$repo ~/$repo
if [ $? != 0 ]; then
    echo 
    echo 'Cloning Error, maybe you should check your network connection.'
    exit 2
fi
cd ~/$repo

# setup vim
if ! [ -f ~/.vimrc.bak ]; then
    if [ -f ~/.vimrc ]; then 
        mv ~/.vimrc ~/.vimrc.bak 
    fi
fi
echo "source ~/$repo/vim/sample.vimrc" > ~/.vimrc

# setup zsh
# backup old configure
if ! [ -f ~/.zshrc.bak ]; then
    if [ -f ~/.zshrc ]; then 
        mv ~/.zshrc ~/.zshrc.bak 
    fi
fi
echo "source ~/$repo/zsh/sample.zshrc" > ~/.zshrc
# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# pause
if ! command -v pause 1>/dev/null; then
    alias pause="$HOME/.pause/bin/pause"
    wget -qO- https://raw.githubusercontent.com/PinLin/EHG/master/pause/install.sh | bash
fi