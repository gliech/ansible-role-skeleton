if ! which python3 >& /dev/null
then
   echo 'Installing Python.'
   if which dnf >& /dev/null
   then
      dnf --assumeyes --quiet --errorlevel=0 --nogpgcheck install python3 || exit 2
   elif which yum >& /dev/null
   then
      yum --assumeyes --quiet --errorlevel=0 --nogpgcheck install python3 || exit 2
   elif which apt-get >& /dev/null
   then
      apt-get --yes --quiet=2 --no-install-recommend install python3 || exit 2
   elif [[ -x /usr/bin/pacman ]]
   then
      pacman --sync --noconfirm --noprogressbar --needed --quiet python3 || exit 2
   else
      echo 'No supported package manager found.' 1>&2
      exit 3
   fi
else
   echo 'Python already installed.'
fi
