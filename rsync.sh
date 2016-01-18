#!/bin/bash
host=$1
log_dir=$2
if [ "X$host" == "X" -o "X$log_dir" == "X" ];then
    echo -e "bad arg"
    exit 1
fi

# init
mkdir -p /home/work/data/$host/

# rsync
start=`date +%s`
rsync -avz --bwlimit=10000 work@$host:/home/work/data/6070  /home/work/data/$host/ &>$log_dir/rsyncsh.$host.$start.log
ecode=$?
end=`date +%s`

# time.consuming
tc=`expr $end - $start`

# statistics
curl -X POST -d "[{\"metric\":\"graph.backup.status\", \"endpoint\":\"$host\", \"timestamp\":$start, \"step\":86400, \"value\":$ecode, \"counterType\":\"GAUGE\", \"tags\": \"pdl=falcon,service=graph,job=backup\"}, {\"metric\":\"graph.backup.time\", \"endpoint\":\"$host\", \"timestamp\":$start, \"step\":86400, \"value\":$tc, \"counterType\":\"GAUGE\", \"tags\": \"pdl=falcon,service=graph,job=backup\"}]" http://127.0.0.1:1988/v1/push

