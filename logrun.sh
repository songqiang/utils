# logrun: a function to run a bash coomand and log the running info
# Song Qiang <keeyang@ustc.edu> 2013

function logrun # command logfile
{
    if [ "$#" == 2 ];
    then
        echo ">>> " "$1"|tee -a "$2";      
        ($1) 2>&1|tee -a "$2";      
    else
        echo "logrun: command logfile" 1>&2;
    fi
}

# this function expects two arguments: the first being the command to run and 
# the second being the logfile. 
# if the command contains spaces, it should be quoted.

# use case:
# qiangson@hpc-cmb:~/tmp
# $ logrun "echo test" test.log
# >>>  echo test
# test
# qiangson@hpc-cmb:~/tmp
# $ echo test.log
# test.log

