#!/bin/bash

# required packages: wget, jdk(openjdk-7-jdk)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/env.sh
echo "using JAVA_HOME=$JAVA_HOME"
echo "using HADOOP_HOME=$HADOOP_HOME"
echo "using HIVE_VER=$HIVE_VER"

# install
sudo mkdir /hive && sudo chmod 777 /hive
mkdir /hive/warehouse

wget -qO- http://www-us.apache.org/dist/hive/hive-${HIVE_VER}/apache-hive-${HIVE_VER}-bin.tar.gz | tar -C /hive -x -z -f -

# configure
cp $DIR/standalone/* ${HIVE_PREFIX}/conf/

# start hiveserver
$HIVE_PREFIX/bin/hiveserver2 &

while true
do
    echo "waiting for hiveserver to come up at port 10000"
    sleep 10
    netstat -na | grep LISTEN | grep 10000
    test $? -eq 0 && break;
done

echo "hiveserver is running"
