#!/bin/bash

# launches a gnome-terminal with a randomized profile
# profiles must first be specified from within gnome-terminal

# made after some code snippet from the internet that I need to attribute

# get profile names
#PROFILE_PATH=/apps/gnome-terminal/profiles
PROFILE_PATH=/org/gnome/terminal/legacy/profiles:/
profile_names=""
#for folder in $(gconftool --all-dirs $PROFILE_PATH); do
for folder in $(dconf list $PROFILE_PATH | grep -v list); do
    #profile_names="${profile_names} $(gconftool --get ${folder}/visible_name)";
    profile_names="${profile_names} $(dconf read ${PROFILE_PATH}${folder}visible-name)";
done
profile_names=($(echo $profile_names | sed -e "s/'//g"))

# launch terminal using code snippet pilfered from somewhere online
gnome-terminal --window-with-profile ${profile_names[$((RANDOM%${#profile_names[@]}))]} $@
