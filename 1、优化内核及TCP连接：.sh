1、优化内核及TCP连接：

fs.file-max = 655350  # 系统文件描述符总量

net.ipv4.ip_local_port_range = 1024 65535  # 打开端口范围

net.ipv4.tcp_max_tw_buckets = 2000  # 设置tcp连接时TIME_WAIT个数
net.ipv4.tcp_tw_recycle = 1  # 开启快速tcp TIME_WAIT快速回收
net.ipv4.tcp_tw_reuse = 1  # 开启TIME_WAIT重用
net.ipv4.tcp_syncookies = 1  # 开启SYN cookies 当出现syn等待溢出，启用cookies来处理，可防范少量的syn攻击
net.ipv4.tcp_syn_retries = 2  # 对于一个新建的tcp连接，内核要发送几个SYN连接请求才决定放弃
net.ipv4.tcp_synack_retries = 2  # 这里是三次握手的第二次连接，服务器端发送syn+ack响应 这里决定内核发送次数
net.ipv4.tcp_keepalive_time = 1200  # tcp的长连接，这里注意：tcp的长连接与HTTP的长连接不同
net.ipv4.tcp_fin_timeout = 15    # 设置保持在FIN_WAIT_2状态的时间
net.ipv4.tcp_max_syn_backlog = 20000  # tcp半连接最大限制数
net.core.somaxconn = 65535  # 定义一个监听最大的队列数
net.core.netdev_max_backlog = 65535  # 当网络接口比内核处理数据包速度快时，允许送到队列数据包的最大数目

保存退出
[root@cloud ~]# sysctl -p  # 添加生效

2、修改Tomcat Connector运行模式为apr
　　Tomcat Connector有三种运行模式：

　　　　bio：阻塞IO bio是三种运行模式中性能最低第一种。

　　　　nio：是一个基于缓冲区，并能提供非阻塞I/O操作的JAVA API 因此NIO也成为非阻塞I/O，比bio拥有更好的并发性能。

　　　　apr：调用httpd核心链接库来读取或文件传输，从而提高tomat对静态文件的处理性能。Tomcat APR模式也是Tomcat在高并发下的首选运行模式：

[root@server3 src]# java -version    # 请确保JDK版本的正确性
java version "1.8.0_77"
Java(TM) SE Runtime Environment (build 1.8.0_77-b03)
Java HotSpot(TM) 64-Bit Server VM (build 25.77-b03, mixed mode)
# 安装apr、apr-util、tomcat-native.tar.gz
[root@server3 src]# wget http://apache.fayea.com//apr/apr-1.5.2.tar.gz
[root@server3 src]# wget http://apache.fayea.com//apr/apr-util-1.5.4.tar.gz
[root@server3 apr-1.5.2]# cd apr-1.5.2
[root@server3 apr-1.5.2]# vim configure    #查找 $RM "$cfgfile" 这个地方，用#注释掉，然后就可以了
[root@server3 apr-1.5.2]# ./configure --prefix=/usr/local/apr
[root@server3 apr-1.5.2]# make && make install
[root@server3 apr-1.5.2]# cd ..
[root@server3 src]# tar xf apr-util-1.5.4.tar.gz
[root@server3 src]# cd apr-util-1.5.4
[root@server3 apr-util-1.5.4]# ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/
[root@server3 apr-util-1.5.4]# make && make install
[root@server3 apr-util-1.5.4]# ll /usr/local/apr*
/usr/local/apr:
total 16
drwxr-xr-x. 2 root root 4096 Apr 24 08:20 bin/
drwxr-xr-x. 2 root root 4096 Apr 24 08:20 build-1/
drwxr-xr-x. 3 root root 4096 Apr 24 08:20 include/
drwxr-xr-x. 3 root root 4096 Apr 24 08:20 lib/

/usr/local/apr-util:
total 12
drwxr-xr-x. 2 root root 4096 Apr 24 08:23 bin/
drwxr-xr-x. 3 root root 4096 Apr 24 08:22 include/
drwxr-xr-x. 3 root root 4096 Apr 24 08:23 lib/
[root@server3 apr-util-1.5.4]# cp -a /usr/local/tomcat8.0/bin/tomcat-native.tar.gz /usr/local/src/
[root@server3 apr-util-1.5.4]# cd !$
cd /usr/local/src/
[root@server3 src]# tar xf tomcat-native.tar.gz
[root@server3 src]# cd tomcat-native
tomcat-native-1.2.5-src/ tomcat-native.tar.gz   
[root@server3 src]# cd tomcat-native-1.2.5-src/
[root@server3 tomcat-native-1.2.5-src]# cd native/

[root@server3 native]# ./configure --prefix=/usr/local/apr --with-java-home=/usr/local/jdk1.8/
[root@server3 native]# make && make install
[root@server3 native]# vim /etc/profile.d/apr.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/apr/lib
:wq
[root@server3 native]# source /etc/profile.d/apr.sh

[root@server3 bin]# sh shutdown.sh
[root@server3 bin]# sh startup.sh
[root@server3 bin]# tail ../logs/catalina.out
24-Apr-2016 08:42:20.319 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deployment of web application directory /usr/local/tomcat8.0/webapps/ROOT has finished in 39 ms
24-Apr-2016 08:42:20.320 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deploying web application directory /usr/local/tomcat8.0/webapps/examples
24-Apr-2016 08:42:20.713 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deployment of web application directory /usr/local/tomcat8.0/webapps/examples has finished in 393 ms
24-Apr-2016 08:42:20.717 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deploying web application directory /usr/local/tomcat8.0/webapps/manager
24-Apr-2016 08:42:20.799 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deployment of web application directory /usr/local/tomcat8.0/webapps/manager has finished in 82 ms
24-Apr-2016 08:42:20.799 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deploying web application directory /usr/local/tomcat8.0/webapps/docs
24-Apr-2016 08:42:20.835 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deployment of web application directory /usr/local/tomcat8.0/webapps/docs has finished in 36 ms
24-Apr-2016 08:42:20.843 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-apr-8080"]  # 通过查看启动日志，tomcat运行模式已经切换到APR。
24-Apr-2016 08:42:20.872 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["ajp-apr-8009"]
24-Apr-2016 08:42:20.877 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 1090 ms

三、Tomcat内存优化：

　　Tomcat内存优化主要是对tomcat启动参数优化，可以修改catalina.sh中设置JAVA_OPTS参数

　　　　1.JAVA_OPTS参数说明

    -server  启用jdk 的 server 版； 
    -Xms    java虚拟机初始化时的最小内存； 
    -Xmx  java虚拟机可使用的最大内存；


配置如下：

[root@server3 bin]# vim /usr/local/tomcat8.0/bin/catalina.sh
97行 JAVA_OPTS='-server -Xms1024m -Xmx1024m'

四、Tomcat并发优化

　　1、Tomcat配置文件server.xml中<Connector .../>

　　2、参数说明：

minProcessors：最小空闲连接线程数，用于提高系统处理性能，默认值为 10
maxProcessors：最大连接线程数，即：并发处理的最大请求数，默认值为 75
acceptCount：允许的最大连接数，应大于等于 maxProcessors ，默认值为 100
enableLookups：是否反查域名，取值为： true 或 false 。为了提高处理能力，应设置为 false
connectionTimeout：网络连接超时，单位：毫秒。设置为 0 表示永不超时，这样设置有隐患的。通常可设置为 30000 毫秒。
其中和最大连接数相关的参数为maxProcessors 和 acceptCount 。如果要加大并发连接数，应同时加大这两个参数。
web server允许的最大连接数还受制于操作系统的内核参数设置，通常 Windows 是 2000 个左右， Linux 是 1000 个左右。

maxThreads  客户请求最大线程数
minSpareThreads    Tomcat初始化时创建的 socket 线程数
maxSpareThreads   Tomcat连接器的最大空闲 socket 线程数
enableLookups      若设为true, 则支持域名解析，可把 ip 地址解析为主机名
redirectPort        在需要基于安全通道的场合，把客户请求转发到基于SSL 的 redirectPort 端口
acceptAccount       监听端口队列最大数，满了之后客户请求会被拒绝（不能小于maxSpareThreads  ）
connectionTimeout   连接超时
minProcessors         服务器创建时的最小处理线程数
maxProcessors        服务器同时最大处理线程数
URIEncoding    URL统一编码

配置如下：

69    <Connector port="8080" protocol="HTTP/1.1"
70                maxThreads="1000"
71                minProcessors="100"
72                maxProcessors="1000"
73                minSpareThreads="100"
74                maxSpareThreads="1000"
75                enableLookups="false"
76                URIEncoding="utf-8"
77                acceptCount="1000"
78                connectionTimeout="20000"
79                disableUploadTimeout="ture"
80                redirectPort="8443" />

tomcat对内存及并发的优化就这些。可根据具体的资源进行调整。重启tomcat，观察日志有无报错。