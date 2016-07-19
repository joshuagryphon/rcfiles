export EDITOR=gvim
alias rm='rm -v'
alias mv='mv -v'
alias todo='gvim ~/notes/todo.rst'

# convert whitespace delimiters to single tabs
function tab { sed -e "s/  */\t/g" -e "s/^\t//"; }

# surround string by quotes
function qu { sed -e "s/\(.*\)/'\1'/g"; }

# print tables with minimum column width of `spacing`,
# specified by `-s` (Default: 40) 
function tprint {
    spacing=40
    while getopts "s:" opt; do
        case $opt in
            s) spacing=$OPTARG
               shift 2;;
        esac
    done

    cat $1 | awk -v spacing=${spacing} '
        BEGIN { FS="\t" }
        {
            out = ""
            for (i = 1; i < NF; i++) {
                size = spacing - length($i)
                while (size <= 0)
                    { size = size + spacing }
                out = out""sprintf("%-"size"s",$i)
            }
            print out""$(i)
        }
        '
}




# color prompt - change to distinguish machines
#
#   30 black 
#   31 red
#   32 green
#   33 yellow
#   34 blue
#   35 magenta
#   36 cyan
#   37 white
#
export PS1="\[\e[1;36m\]\u@\h:\w$\[\e[m\] "
