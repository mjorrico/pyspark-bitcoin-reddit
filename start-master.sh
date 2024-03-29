#!/bin/bash

img="spark-image"
host="master-node"
vol="hdfs-volume"

network="--network host"
volume="-v $vol:/hdfs-data"
hostname="--hostname $host"
name="--name $host"
run="run -d $network $volume $hostname $name $img"

format_namenode="yes y | hdfs namenode -format"
start_namenode="hdfs --daemon start namenode"
start_spark_master="\$SPARK_HOME/sbin/start-master.sh"
command="$start_namenode && $start_spark_master"

while getopts "f" opt; do
  case $opt in
    f)
      command="$format_namenode && $command"
      ;;
    \?)
      exit 1
      ;;
  esac
done

echo -e ">>> docker $run sh -c \"$command\""
docker $run sh -c "$command"