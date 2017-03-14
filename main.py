#! /usr/bin/python 
# -*- coding: utf-8 -*-

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

def baidu_sou(wd):
	try:
		url = 'http://www.baidu.com/s?'
		wd = {'wd':wd}
		r = requests.get(url,params=wd)
		r.raise_for_status()
#		r.encoding = r.apparent_encoding
		r.encoding = 'utf-8'
		return r.text		
	except:
		print ('baidu_sou failed')

def get_burl(html):
	soup = BeautifulSoup(html,'html.parser')
	print ('numbers of result:' ,len(soup.findAll(name = 'h3')))
	
	h = (soup.findAll(name = 'h3'))
#	s = str(h[4]).split('href=')
	burl = []
	for x in range(len(soup.findAll(name = 'h3'))):
	
		s = (str(h[x]).split('href=')[1].split()[0])
#		print  (str(h[x]).split('href=')[1].split()[0])
		link = s.replace('"','')
		burl.append(link)

#	print (burl)
	return burl
		
def get_real_url_name(burl):
	l = len(burl)
	result = []
	for x in range(l):
		s = requests.get(burl[x])
#		print (s.url)
		s.encoding = s.apparent_encoding
		soup = BeautifulSoup(s.text,'html.parser')
#		print (soup.title)
		result.append(soup.url)
		result.append(soup.title)
	return result
        
def display(result):
	for x in range(len(result)):
		print (result[x])
		
if __name__ == "__main__":
	
	html = baidu_sou('zrbao')
	burl = get_burl(html)
	url = get_real_url_name(burl)
	get_real_url_name(burl)
	display(url)
