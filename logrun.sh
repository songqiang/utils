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
