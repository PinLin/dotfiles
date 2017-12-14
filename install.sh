# set constant
repo='.shconf'

# check reqirements
# apps
for app in "git" "vim" "zsh"; do
    if ! command -v $app >/dev/null; then
        echo 'Could not find `'$app'`.'
        exit 1
    fi
done
# files
for app in ~/.oh-my-zsh; do
    if ! [ -d $app ]; then
        echo 'Could not find `'$app'`.'
        exit 1
    fi
done

# clone into computer
if [ -d ~/$repo ]; then
    rm -rf ~/$repo
fi
git clone https://github.com/PinLin/$repo ~/$repo
if [ $? != 0 ]; then
    echo ''
    exit 2
fi
cd ~/$repo

# setup vim
# backup old config
if ! [ -f ~/.vimrc.bak ]; then
    if [ -f ~/.vimrc ]; then 
        mv ~/.vimrc ~/.vimrc.bak 
    fi
fi
echo "source ~/$repo/vim/sample.vimrc" > ~/.vimrc

# setup zsh
# backup old config
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
