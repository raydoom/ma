
#!/bin/bash
#for restart tomcat
#author ma
#usage  restart.sh 8601

is_running=$(ps -ef |grep $1 | grep tomcat |grep -v 'grep' | wc -l)
echo $is_running
if [ $is_running -ne 0 ];then
        app='tomcat'$1
        appdir=$(ps -ef | grep $app | grep -v 'grep' | awk -F '/bin/bootstrap.jar' '{print $1}' | awk -F '/' '{print $NF}')
        echo "$appdir is running"
        apppid=$(ps -ef |grep tomcat |grep -w "apache\/$appdir\/conf"|grep -v 'grep'|awk '{print $2}')
        echo $app' pid = '$apppid
        kill -9 $apppid
        echo 'restarting it...'
        sleep 1
        /opt/apache/$appdir/bin/startup.sh
else
        echo 'tomcat '$1'is not running'
        echo 'starting it'
        appdir=$(find /opt/apache/ -name "*$1*")
        $appdir/bin/startup.sh
fi
