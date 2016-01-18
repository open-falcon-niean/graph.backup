#!/bin/bash
## 默认的,监控数据将被冷备在目录/home/work/data下
## 一台冷备机,可以备份多个graph实例的数据;不同的graph实例,对应目录/home/work/data下的不同子目录
##
## eg. 某台冷备机,要备份graph01、graph02两台机器的数据 
##   /home/work/data/graph01 #graph01的数据冷备
##   /home/work/data/graph02 #graph02的数据冷备
## 
cur_dir=$(cd $(dirname $0)/; pwd)
data_dir=/home/work/data
cd $cur_dir

tmp=$cur_dir/tmp
list=$cur_dir/graph.list
rsyncsh=$cur_dir/rsync.sh
mkdir -p $tmp

# check
if [ ! -f $list ]; then
    echo -e "[error] miss graph list file"
    exit 1
fi

# rsync async
ts=`date +%s`
echo -e "[start], $ts"
for host in `cat $list`;
do
    nohup bash $rsyncsh "$host" "$tmp" &>/dev/null &
    echo -e "rsync $host"
done
echo -e "[done] async, `date +%s`"
