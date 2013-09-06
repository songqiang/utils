# logrun: a function to run a bash coomand and log the running info
# Song Qiang <keeyang@ustc.edu> 2013

function logrun # logfile command [options] [arguments]
{
    if [ "$#" -ge 2 ];
    then
        echo ">>> " "${@:2}"|tee -a "$1";      
        (${@:2}) 2>&1|tee -a "$1";      
    else
        echo "logrun: logfile command [options]" 1>&2 && false;
    fi
}

# this function expects at least two arguments: 
# the first is the log file
# and the remaining arguments are the command and its options and arguments

# example:
# qiangson@hpc-cmb:~/tmp
# $ logrun test.log echo test
# >>>  echo test
# test
# qiangson@hpc-cmb:~/tmp
# $ cat test.log 
# >>>  echo test
# test

## alternative implementation with set -x options

## function logrun
## {
##    if [ "$#" -ge 2 ];
##    then
##        PS4=">>> ";      
##        set -x;      
##        (${@:2}) 2>&1|tee -a "$1";      
##        set +x
##    else
##        echo "logrun: logfile command [options]" 1>&2 && false;
##    fi
## }

