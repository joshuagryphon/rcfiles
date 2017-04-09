#!/bin/bash
# partial implementation of a script to do one-time setup of new shell accounts
EXIT_SUCESS=0
EXIT_BAD_ARGS=1
MIN_ARGS=1
OPTIONS="h"

function do_usage {
	expand_opts=$(echo $OPTIONS | sed -e "s/://g" -e "s/\(.\)/-\1 /g" -e "s/ $//")
	echo "usage: $(basename $0) user_email@domain.com"
}

function do_help {
    cat << ____EOH
    $(do_usage)
____EOH
}

#parse options
while getopts $OPTIONS option; do
	case $option in
		h ) do_help
			exit $EXIT_SUCCESS;;
		* ) do_usage
			exit $EXIT_BAD_ARGS;;
	esac
done
shift $(($OPTIND - 1))
if [ $# -lt $MIN_ARGS ]; then
	echo "At least $MIN_ARGS arguments required. Exiting."
	echo ""
	do_usage
	exit $EXIT_BAD_ARGS
fi


# get email
user_email="$1"
echo $user_email | tee -a ~/.forward

# screenrc
[ -e "~/.screenrc" ] && echo "screenrc exists: skipping" || ln -s $(pwd)/screenrc ~/.screenrc 

# bashrc
[ -e "~/.bash_aliasess" ] && echo "bash_aliases exists: skipping" || ln -s $(pwd)/bashrc ~/.bash_aliases

# vim
[ -e "~/.vimrc" ] && echo "vimrc exists: skipping" || {

    ln -s $(pwd)/vimrc ~/.vimrc

    # package manager
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    # powerline fonts
    git clone https://github.com/powerline/fonts.git /tmp/tmp_fonts
    cd /tmp/tmp_fonts
    ./install.sh
    cd -
    rm -rf /tmp/tmp_fonts

    # install subpackages
    vim -c 'source ~/.vimrc' -c "PluginInstall" -c ':q' -c':q'
}


# git setup
[ -e "~/.gitconfig" ] && echo "gitconfig exists: skipping" || {
    cat gitconfig | sed -e "s/USER_EMAIL/$user_email/" > ~/.gitconfig
}
