#!/bin/bash

# Ce script doit être lancé avec l'utilisateur ubuntu (Utiliser privileged: false dans Vagrantfile)

echo "## Installation de smartcd"
sudo apt-get install make

# Fork de smartcd permettant de trust les fichiers locaux .bash_enter et .bash_exit
cd /tmp && rm -Rf smartcd && git clone https://github.com/Toilal/smartcd.git && cd smartcd && make install && source load_smartcd && rm -Rf smartcd && cd $HOME

if [ ! -f $HOME/.smartcd_config ]; then
    cat << EOF > $HOME/.smartcd_config
    # Load and configure smartcd
    source ~/.smartcd/lib/core/arrays
    source ~/.smartcd/lib/core/varstash
    source ~/.smartcd/lib/core/smartcd
    # smartcd setup chpwd-hook
    smartcd setup cd
    smartcd setup pushd
    smartcd setup popd
    # smartcd setup prompt-hook
    # smartcd setup exit-hook
    smartcd setup completion
    # VARSTASH_AUTOCONFIGURE=1
    # VARSTASH_AUTOEDIT=1
    # SMARTCD_NO_INODE=1
    # SMARTCD_AUTOMIGRATE=1
    # SMARTCD_LEGACY=1
    # SMARTCD_QUIET=1
    # VARSTASH_QUIET=1
EOF
    echo "Ecriture de la configuration de smartcd (~/.smartcd_config)"
fi

cat $HOME/.bashrc | grep .smartcd_config
BASHRC_CONFIGURED=$?
if [ "$BASHRC_CONFIGURED" != "0" ]; then
    echo ''>>$HOME/.bashrc
    echo '[ -r "$HOME/.smartcd_config" ] && ( [ -n $BASH_VERSION ] || [ -n $ZSH_VERSION ] ) && source ~/.smartcd_config'>>$HOME/.bashrc
    echo "Enregistrement de smartcd (~/.bashrc)"
fi

cat $HOME/.profile | grep .smartcd_config
PROFILE_CONFIGURED=$?
if [ "$PROFILE_CONFIGURED" != "0" ]; then
    echo ''>>$HOME/.profile
    echo '[ -r "$HOME/.smartcd_config" ] && ( [ -n $BASH_VERSION ] || [ -n $ZSH_VERSION ] ) && source ~/.smartcd_config'>>$HOME/.profile
    echo "Enregistrement de smartcd (~/.profile)"
fi