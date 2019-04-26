#! /usr/bin/python 
# -*- coding: utf-8 -*-

import time
import datetime
import requests

counter = requests.get('http://127.0.0.1:8090/index.php?g=api&m=AllinPay&a=down')
print (counter.text)

log =  (datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),'return code is %s'%(counter.text))
with open ('/tmp/php-get-bill.log','a') as f:
	f.write(str(log))
        f.write('\n')
        f.write('\n')


#counter = int(counter.text)
counter = 5
i = 1
time.sleep(10)
for x in range(counter):
	print (i)
	r = requests.get('http://127.0.0.1:8090/index.php?g=api&m=AllinPay&a=insert_order')
	
	log =  (datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),'progress:%d/%d'%(i,counter))
        with open ('/tmp/php-get-bill.log','a') as f:
                f.write(str(log))
                f.write('\n')
	i = i+1
	time.sleep(3)

	


