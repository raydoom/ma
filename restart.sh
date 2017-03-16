#!/bin/bash
#for restart tomcat
#author ma
#usage  restart.sh 8601 [8602 8603]
if [ $# -lt 1 ];then
        echo 'no args... exit '
        exit 0
else
for ((i=1;i<=$#;i++)); do
        tom=${!i}
        is_running=$(ps -ef |grep $tom | grep tomcat |grep -v 'grep' | wc -l)
        if [ $is_running -ne 0 ];then
                app='tomcat'$tom
                appdir=$(ps -ef | grep $app | grep -v 'grep' | awk -F '/bin/bootstrap.jar' '{print $1}' | awk -F '/' '{print $NF}')
                echo "$appdir is running"
                apppid=$(ps -ef |grep tomcat |grep -w "apache\/$appdir\/conf"|grep -v 'grep'|awk '{print $2}')
                echo $app' pid = '$apppid
                kill -9 $apppid
                echo 'restarting it...'
                sleep 1
                /opt/apache/$appdir/bin/startup.sh
        else
                echo 'tomcat '$tom'is not running'
                echo 'starting it'
                appdir=$(find /opt/apache/ -name "*$tom*")
                $appdir/bin/startup.sh
        fi
done
fi