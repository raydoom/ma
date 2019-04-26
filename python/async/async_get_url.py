import asyncio
import time
import aiohttp
import async_timeout

# msg = "http://www.nationalgeographic.com.cn/photography/photo_of_the_day/{}.html"
msg = "https://aizhi.zrbao.net/api/{}"
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'
}

urls = [msg.format(i) for i in range(1, 300)]

async def fetch(session, url):
    with async_timeout.timeout(10):
        async with session.get(url) as response:
            return response.status

async def main(url):
    async with aiohttp.ClientSession() as session:
            status = await fetch(session, url)
            return status

if __name__ == '__main__':
    start = time.time()
    loop = asyncio.get_event_loop()
    tasks = [main(url) for url in urls]
    # 返回一个列表,内容为各个tasks的返回值
    status_list = loop.run_until_complete(asyncio.gather(*tasks))
    print(len([status for status in status_list if status==200]))
    end = time.time()
    print("cost time:", end - start)