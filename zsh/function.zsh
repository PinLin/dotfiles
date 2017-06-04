update-dotfiles() {
    cd $DOTFILES
    git pull
    cd -
}

password() {
    echo -n "Password: " > /dev/stderr
    read -s
    echo $REPLY
    echo > /dev/stderr
}
