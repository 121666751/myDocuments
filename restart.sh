#!/bin/bash

source /etc/profile

JAVA_OPTIONS_INITIAL=-Xms1024M
JAVA_OPTIONS_MAX=-Xmx5120M
ACTIVE_PROFILE=$2
JAR_NAME=$1
PID=$(ps -aux |grep ${JAR_NAME} | grep -v grep |grep -v restart|awk '{print $2}' )

#check param
if [ $# -lt 2 ]
then
    echo "Usage:$0 jarname activeProfile"
    echo "Example:$0 sample.jar test"
    exit -1
fi

#stop service
if [ -z "$PID" ]
then
    echo Application is already stopped
else
    echo "will kill $PID"
    kill -9 $PID
fi

#start service
echo "######begin start service#########"
nohup java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n ${JAVA_OPTIONS_INITIAL} ${JAVA_OPTIONS_MAX} -jar ${JAR_NAME} --spring.profiles.active=${ACTIVE_PROFILE} 1>oauth2.log 2>&1 &
echo "#######service has been started#######"
