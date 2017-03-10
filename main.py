#! /usr/bin/python 
# -*- coding: utf8 -*-

import urllib

class ma:
        def open(self,url):
                s = urllib.urlopen(url)
                con = s.readlines(20)
                info = s.info()
                status = s.getcode()
                print con
                print info
                print status

def download(urld,file):
        urllib.urlretrieve(urld,file,reporthook=progress)

def progress(blk,blk_size,total_size):
        print('%dkb/%dkb = %.02f%%' % (blk*blk_size,total_size,(float)(blk*blk_size)*100/total_size))



if __name__ == "__main__":
#       url = raw_input("input the url:")
        url = "https://www.baidu.com"
#       ma.open(url)
#       download("http://mirrors.hust.edu.cn/apache//ant/binaries/apache-ant-1.10.1-bin.tar.gz","apache-ant-1.10.1-bin.tar.gz")
        s=ma()
        s.open(url)
