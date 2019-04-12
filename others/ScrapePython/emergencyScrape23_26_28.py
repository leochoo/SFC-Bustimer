from bs4 import BeautifulSoup as bs
import requests
import re
import pprint





def scrape(soup):

    for i in range(14,16):
        hour = (soup.find(id = "hour"+str(i))).text
        hour_group = soup.find(id = "hour_0_"+str(i))
        box_min = hour_group.find( class_ = 'min')
        min_group = box_min.find( class_ = 'time')

        min_list = [x.text for x in min_group]
        
        dic = {}
        dic["weekday"] = []
        for m in min_list:
            dic["weekday"].append({"hour": int(hour), "min": int(m), "type": None, "rotary": False})
        pp.pprint(dic)





# main

#pretty printer
pp = pprint.PrettyPrinter(indent=4)


# 23, 26
page = requests.get('http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800141-1/rt:0/nid:00129986/dts:1554660000')

# 28


# 24 sho-sfc
#page = requests.get('http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801156-1/nid:00129893/rt:0/k:%E6%B9%98%E5%8D%97%E5%8F%B0')




soup = bs(page.text, 'html.parser')
scrape(soup)

#output to csv file
# output_results(soup) 








