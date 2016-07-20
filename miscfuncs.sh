#!/bin/bash


# simple calculations from command line
function calc { echo -e "scale=4\n $@\n quit" | bc; }

# add up a column of numbers
function sum { awk 'BEGIN {c=0}; END {print c}; {c+=$1}'; }

# turn whitespace delimiters into tabs
function tab { sed -e "s/  */\t/g" -e "s/^\t//" ;}

# surround with quotes
function qu { sed -e "s/\(.*\)/'\1',/g"; }

# count number of fields in a text file
function nf { head -100 $1 | awk '{print NF}' | sort -k1n | tac | head -1; }

# Kill a family of processes matching $1 in their `ps` line
function grepkill { ps | grep "$1" | tab | xargs kill -9; }

# Run a command on each of a number of files, limiting number of processed used
# Pipe filenames to command. e.g.:
#
#     find . -name "*some_token*" -type f | each some_complicated_command
function each {
    local OPTIND OPTARG processes options
    processes=4
    while getopts "p:" options; do
        case $options in
            p ) processes=$OPTARG;;
        esac
    done
    shift $(( $OPTIND - 1 ))

    [ $# -lt 1 ] && echo "'each' requires a command: each [-p PROCESSES] COMMAND [command arguments]" || {
        cmd="$@"
        xargs -I FILENAME -n1 -P $processes $cmd FILENAME
    }
}


export -f calc sum tab qu nf grepkill each
