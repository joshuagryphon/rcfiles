#===============================================================================
# Variables
#===============================================================================

export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
export GOPATH="/home/joshua/.local/lib/go"
export PATH="~/.local/bin:~/bin:${GOPATH}/bin:${PATH}"
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

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
#
#export PS1="\[\033[1;38;5;197m\]\u@\h:\w$\[\e[m\] "
export EDITOR=gvim

alias rm='rm -v'
alias mv='mv -v'
alias xclip='xclip -selection c'
alias todo='gvim -c "setlocal background=light" ~/notes/todo.rst'

source ~/.local_variables

#===============================================================================
# Functions
#===============================================================================


# convert whitespace delimiters to single tabs
function tab { sed -e "s/  */\t/g" -e "s/^\t//"; }

# surround string by quotes
function qu { sed -e "s/\(.*\)/'\1'/g"; }

# print tables with minimum column width of `spacing`,
# specified by `-s` (Default: 40). Delimiter `-d`
function tprint {
    spacing=40
    delim="\t"
    while getopts "s:" opt; do
        case $opt in
            s) spacing=$OPTARG
               shift 2;;
            d) delim="$OPTARG"
               shift 2;;
        esac
    done

    cat $1 | awk -v spacing=${spacing} -v delim=${delim} '
        BEGIN { FS=delim }
        {
            out = ""
            for (i = 1; i < NF; i++) {
                size = spacing - length($i)
                while (size <= 0)
                    { size = size + spacing }
                out = out""sprintf("%-"size"s",$i)
            }
            print out""$i
        }
        '
    unset spacing
    unset delim
}


# simple calculations from command line
function calc { echo -e "scale=4\n $@\n quit" | bc; }

# add up a column of numbers
function sum { awk 'BEGIN {c=0}; END {print c}; {c+=$1}'; }

# count number of fields in a text file
function nf { head -100 $1 | awk '{print NF}' | sort -k1n | tac | head -1; }


# make logfile names that don't collide
function getbasename {
    BASENAME="$(basename $1)"
    if [ -f ${BASENAME}.out ]; then
        LOGNUM=0
        LOGFILE=${BASENAME}.${LOGNUM}.out
        while [ -f $LOGFILE ]; do
            LOGNUM=$[ $LOGNUM + 1]
            LOGFILE=${BASENAME}.${LOGNUM}.out
        done
    else
        LOGFILE=${BASENAME}.out
    fi  
    echo $LOGFILE
}

# nohup with custom logfile and mail to user when finisheda
# requires mutt to send mail. email address must be defined in 
# $USER_EMAIL
USER_EMAIL=$(cat ~/.forward)
function mailhup {
    LOGFILE=$(getbasename $1) 
    echo "Logging to ${LOGFILE} ..." 
    echo "----[start: $(date) ]------------------------------------" >>${LOGFILE} 
    echo "Starting job $@..." >>${LOGFILE} 
    nohup $@ >>$LOGFILE
    MYEXIT=$?
    echo "--------------------------------------[end: $(date) ]----" >>${LOGFILE}

    FILESIZE=$(stat -c%s ${LOGFILE})
    LINES=$(wc -l ${LOGFILE} | cut -f1 -d" ")
    SUBJECT="results for $@ [exit code ${MYEXIT}]"

    # if output is small, put in email
    # if output is large, put in first & last 30 lines and attach remainder
    # if output is >25Mb, dont' attach
    if (( $LINES < 50 )); then
        cat $LOGFILE | mutt -s "$SUBJECT" -a $LOGFILE -- $USER_EMAIL
        else
            tmpname=$(basename $1)_$(date +%G-%m-%d_%Hh-%Mm).tmp
            head --lines 30 $LOGFILE >$tmpname
            echo "--- (skipping to last 30 lines of output) ---" >>$tmpname
            tail --lines 30 $LOGFILE >>$tmpname
            if (($FILESIZE > 25*1024*1024)); then
                echo "(logfile bigger than 25mb)" >>$tmpname
                cat $tmpname | mutt -s "$SUBJECT" $USER_EMAIL
            else
                echo "(rest of output attached)...">>$tmpname
                cat $tmpname | mutt -s "$SUBJECT" -a $LOGFILE --  $USER_EMAIL
            fi  
    rm $tmpname
    fi

    # if able, give notification
    if [ -n "$DISPLAY" ] && [ -n "$(which zenity)" ]; then
        ztext="${@}\nfinished at: $(date)\nexit code: $MYEXIT"
        zenity --info --title="mailhup: $1 finished [exit code ${MYEXIT}]" --text="${ztext}" &
    fi
}


