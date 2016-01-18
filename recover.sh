#!/bin/bash
cur_dir=$(cd $(dirname $0)/; pwd)
data_dir=/home/work/data
cd $cur_dir

tmp=$cur_dir/tmp
mkdir -p $tmp

# inputs
src="c3-op-mon-graph25.bj"
dst="c3-inf-mon-db03.bj"
start=0
end=7

# rsync async
echo -e "[start], recover, $src-->$dst, `date +%s`"
for i in `seq $start 4 $end`;
do
    i1=`expr $i + 1`
    i2=`expr $i + 2`
    i3=`expr $i + 3`
    p0=`printf "%x" $i`
    p1=`printf "%x" $i1`
    p2=`printf "%x" $i2`
    p3=`printf "%x" $i3`
    nohup rsync -avz --bwlimit=10000  /home/work/data/$src/6070/$p0* /home/work/data/$src/6070/$p1* /home/work/data/$src/6070/$p2* /home/work/data/$src/6070/$p3* work@$dst:/home/work/data/$src/6070/ &>$tmp/rsync.$src.$p0.log &
    echo -e "push: /home/work/data/$src/6070/[$p0*,$p1*,$p2*,$p3*] --> work@$dst:/home/work/data/$src/6070/"
done
echo -e "[done] async, `date +%s`"
