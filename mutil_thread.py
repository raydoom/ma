#! /usr/bin/python 
# -*- coding: utf-8 -*-

import threading

def printme(me):
	print (me)
	print (me+100)

if __name__ == '__main__':
	th = []
	for x in range(1,10):
		th.append(threading.Thread(target = printme,args = (x,)))
	for t in th:
		t.start()
		t.join()