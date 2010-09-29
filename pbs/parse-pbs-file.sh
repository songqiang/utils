#! /bin/bash

# Copyright (C) 2010 SONG QIANG
# This program is free software distributed under the terms of 
# the GNU General Public License as published by the Free Software
# Foundation

# This script change the name of PBS output files according to its execution status 

if [ $# -eq 0 ]
then    
    exit    
fi  

if [ $# -ge 2 ]
then
	echo $*|xargs -n 1 $0
	exit
fi 

oldout=$1
olderr=${oldout/OU/ER}

if [ ! -f $oldout ]
then    
    exit    
fi  

pbsline=$(cat $oldout|grep "Begin PBS Prologue")

if [ -z "$pbsline" ]
then
	exit
fi

newbase=$(awk < $oldout '
BEGIN \
{
monnum["Jan"] = "01";
monnum["Feb"] = "02";
monnum["Mar"] = "03";
monnum["Apr"] = "04";
monnum["May"] = "05";
monnum["Jun"] = "06";
monnum["Jul"] = "07";
monnum["Aug"] = "08";
monnum["Sep"] = "09";
monnum["Oct"] = "10";
monnum["Nov"] = "11";
monnum["Dec"] = "12";
}

NR == 2 \
{
if ($6 < 10) $6 = "0"$6;
jobdate = $9 monnum[$5] $6;
jobtime = $7;
}

NR == 3 \
{
sub(/\..*/, "", $3);
jobid = $3;
}

NR == 6 \
{
sub(/\.qsub/, "", $2);
jobname = $2;
}

END \
{
print jobname "-" jobdate "-" jobid;
}
')

newout=$newbase.OU
newerr=$newbase.ER

if [ "$oldout" !=  "$newout" ]
then
	mv $oldout $newout

	if [ -f $olderr ]
	then
    	mv $olderr $newerr
	fi  

	if [ -f ../error/$olderr ]
	then
    	mv ../error/$olderr ../error/$newerr
	fi  
fi
