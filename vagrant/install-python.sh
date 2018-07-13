if ! which python >& /dev/null
then
    echo 'Installing Python.'
    if which yum >& /dev/null
    then
        yum -yq install python || exit 2
    elif which apt >& /dev/null
    then
        apt -yqq install python || exit 2
    elif which pacman >& /dev/null
    then
        pacman --noconfirm --noprogressbar --needed -S python || exit 2
    else
        echo 'No supported package manager found.' 1>&2
        exit 3
    fi
else
    echo 'Python already installed.'
fi
