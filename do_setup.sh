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

function get_pcolor {
# color prompt - from http://ascii-table.com/ansi-escape-sequences.php
# Text attributes
# 0   All attributes off
# 1   Bold on
# 4   Underscore (on monochrome display adapter only)
# 5   Blink on
# 7   Reverse video on
# 8   Concealed on
#  
# Foreground colors
# 30  Black
# 31  Red
# 32  Green
# 33  Yellow
# 34  Blue
# 35  Magenta
# 36  Cyan
# 37  White
#  
# Background colors
# 40  Black
# 41  Red
# 42  Green
# 43  Yellow
# 44  Blue
# 45  Magenta
# 46  Cyan
# 47  White
    isok=n
    while [ "$isok" != "y" ] && [ $isok != "Y" ]; do
        # range is 31-229
        PCOLOR=$((31 + RANDOM%199))
        printf "\e[1;38;5;${PCOLOR}mIs this ok?\e[0m (y/n) "
        read -n1 isok
        printf "\n"
    done
    unset isok
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
[ -e ~/.screenrc ] && echo "screenrc exists: skipping" || ln -s $(pwd)/screenrc ~/.screenrc 

# bashrc
[ -e ~/.bash_aliases ] && echo "bash_aliases exists: skipping" || ln -s $(pwd)/bashrc ~/.bash_aliases

# vim
[ -e ~/.vimrc ] && echo "vimrc exists: skipping" || {

    ln -s $(pwd)/vimrc ~/.vimrc

    # package manager
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    # powerline typefaces
    git clone https://github.com/powerline/fonts.git /tmp/tmp_fonts
    cd /tmp/tmp_fonts
    ./install.sh
    cd -
    rm -rf /tmp/tmp_fonts

    # install subpackages
    vim -c 'source ~/.vimrc' -c "PluginInstall" -c ':q' -c':q'
}

[ -e ~/.local_variables ] && echo "local_variables exists: skipping" || {
    get_pcolor
    cat >~/.local_variables << ____EOF
#this file is auto-generated and contains variables specific to this user shell
export PS1="\[\033[1;38;5;${PCOLOR}m\]\u@\h:\w$\[\e[m\] "
____EOF
}

# git setup
[ -e ~/.gitconfig ] && echo "gitconfig exists: skipping" || {
    cat gitconfig | sed -e "s/USER_EMAIL/$user_email/" > ~/.gitconfig
}

[ -e ~/.gitignore_global ] && echo "gitignore exists: skipping" || {
    ln -s $(pwd)/gitignore_global ~/.gitignore_global
}




echo "Done."
