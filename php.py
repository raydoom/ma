#! /usr/bin/python 
# -*- coding: utf-8 -*-

import time
import datetime
import requests

for x in range(30):
	r = requests.get('http://ip:port/index.php?g=Api&m=ScoreCrontab&a=UserInvestAddScore')
	log =  (datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),'progress:%d/30,return code is %s'%((x+1),r.text))
        with open ('/opt/sh/php.log','a') as f:
                f.write(str(log))
                f.write('\n')
	if int(r.text) == 2:
		with open ('/opt/sh/php.log','a') as f:
			f.write('return code is 2,game over')
                	f.write('\n')
		break
	time.sleep(3)
