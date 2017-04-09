#!/bin/bash
# partial implementation of a script to do one-time setup of new shell accounts


# user email - get from somewhere
user_email=
echo $user_email | tee -a ~/.forward

# bashrc
ln -s $(pwd)/bashrc ~/.bash_aliases

# vim
ln -s $(pwd)/vimrc ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/powerline/fonts.git /tmp/tmp_fonts
cd /tmp/tmp_fonts
./install.sh
# clean-up a bit
cd -
rm -rf /tmp/tmp_fonts
vim -c 'source ~/.vimrc' -c "PluginInstall" -c ':q' -c':q'


# git setup
cat gitconfig | sed -e "s/USER_EMAIL/$user_email/" > ~/.gitconfig
