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

jobdate=$(cat $oldout|sed -n '2p'|sed \
-e 's/Jan/01/' \
-e 's/Feb/02/' \
-e 's/Mar/03/' \
-e 's/Apr/04/' \
-e 's/May/05/' \
-e 's/Jun/06/' \
-e 's/Jul/07/' \
-e 's/Aug/08/' \
-e 's/Sep/09/' \
-e 's/Oct/10/' \
-e 's/Nov/11/' \
-e 's/Dec/12/' | awk '{if ($6 < 10) $6="0"$6;  print $9$5$6}')

jobtime=$(cat $oldout|sed -n '2p'| awk '{print $7}')
              
jobid=$(cat $oldout|sed -n '3 s/[^0-9]*\([0-9]*\).*/\1/p')
            
jobname=$(cat $oldout|sed -n '6 s/Name: *\(.*\)\.qsub/\1/p')

newout=$jobname-$jobdate-$jobid.OU
newerr=$jobname-$jobdate-$jobid.ER

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
