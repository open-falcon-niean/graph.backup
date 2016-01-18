#!/bin/bash
cur_dir=$(cd $(dirname $0)/; pwd)
data_dir=/home/work/data
cd $cur_dir

list=$cur_dir/graph.list

# check
if [ ! -f $list ]; then
    echo -e "[error] miss graph list file"
    exit 1
fi

# clean async
ts=`date +%s`
echo -e "[start] clean, $ts"
for host in `cat $list`;
do
    hostdir="/home/work/data/$host"
    if [ ! -d $hostdir ];then 
        echo -e "not found: $hostdir"
        exit 1 
    fi
    nohup rm -rf $hostdir/* &>/dev/null &
    echo -e "clean $hostdir"
done
echo -e "[done] clean async, `date +%s`"
