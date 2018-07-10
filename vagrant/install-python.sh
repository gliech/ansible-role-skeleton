if ! which python
then
    if which yum
    then
        yum -yq install python || exit 2
    elif which apt
    then
        apt -yqq install python || exit 2
    elif which pacman
    then
        pacman --noconfirm --noprogressbar --needed -S python || exit 2
    else
        exit 3
    fi
fi
