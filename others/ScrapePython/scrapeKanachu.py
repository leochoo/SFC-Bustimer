from bs4 import BeautifulSoup as bs
import requests
import re
import json

def scrape(soup):
    """
    CSS tags
    weekday: 0
    saturday: 1
    holiday: 1

    td id="hour_[dayType]_[hour]"
        class = "ruby" : Sasakubo keiyu
        class = "time" : minutes


    if ruby exists:
        scrape ruby

    match ruby and min_group index

    """
    dic = {}
    
    for dayType in range(3):
        if dayType == 0:
            dt = "weekday"
        elif dayType == 1:
            dt = "sat"
        else:
            dt = "sun"
        dic[dt] = []
        # print(dayType)
        for hour in range(5, 24):
            hour_box = soup.find(id = "hour_{}_{}".format(str(dayType), str(hour)))
            if hour_box.find(class_ = "min" is not None):
                if hour_box.find( class_ = 'ruby') != None:
                    ruby_group = hour_box.find( class_ = 'ruby') 
                    ruby_list = [r.text for r in ruby_group]

                min_group = hour_box.find( class_ = 'time')
                min_list = [x.text for x in min_group]

                # print(hour)
                # print(ruby_list)
                # print(min_list)

                for i in range(len(min_list)):
                    busType = None
                    if ruby_list[i] == "笹":
                        busType = "s"
                    dic[dt].append({"hour": hour, "min": int(min_list[i]), "type": busType, "rotary": False})
    
    # dump to JSON
    with open('bus_data.json', 'w') as outfile:
        json.dump(dic, outfile, indent=4)
    # print(j)



# schedule = {

#   "13" : {
#       "ruby": ruby_list,
#       "min" : min_list
#   }
# }

    
def main():
    # Shonandai -> SFC
    # 23, 24 
    page = requests.get('http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801156-1/nid:00129893/rt:0/k:%E6%B9%98%E5%8D%97%E5%8F%B0')
    soup = bs(page.text, 'html.parser')
    scrape(soup)

    #25
    # page = requests.get("http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000802604-1/nid:00129893/rt:0/k:%E6%B9%98%E5%8D%97%E5%8F%B0")
    # soup = bs(page.text, 'html.parser')
    # scrape(soup)
    

    # SFC -> Shonandai
    # 23, 26
    # page = requests.get('http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800141-1/rt:0/nid:00129986/dts:1554660000')


    #output to csv file
# output_results(soup) 

if __name__ == '__main__':
    main()









