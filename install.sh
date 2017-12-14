# set constant
repo='.shconf'

# check reqirements
for app in git; do
    if ! command -v $app >/dev/null; then
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
    echo Could not clone $repo.
    exit 2
fi

# setup vim
if command -v vim >/dev/null; then
    echo "source ~/$repo/vim/sample.vimrc" >> ~/.vimrc
else
    echo Could not find `vim`.
fi

# setup zsh
if command -v zsh >/dev/null; then
    if [ -d ~/.oh-my-zsh ]; then
        echo "source ~/$repo/zsh/sample.zshrc" >> ~/.zshrc
    else
        echo Could not find `oh-my-zsh`.
    fi
else
    echo Could not find `zsh`.
fi

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
