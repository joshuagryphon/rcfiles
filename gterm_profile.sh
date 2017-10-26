#!/bin/bash

# launches a gnome-terminal with a randomized profile
# profiles must first be specified from within gnome-terminal

# made after some code snippet from the internet that I need to attribute

# get profile names
PROFILE_PATH=/apps/gnome-terminal/profiles
profile_names=""
for folder in $(gconftool --all-dirs $PROFILE_PATH); do
    profile_names="${profile_names} $(gconftool --get ${folder}/visible_name)";
done
profile_names=($profile_names)

# launch terminal using code snippet pilfered from somewhere online
gnome-terminal --window-with-profile ${profile_names[$((RANDOM%${#profile_names[@]}))]} $@
