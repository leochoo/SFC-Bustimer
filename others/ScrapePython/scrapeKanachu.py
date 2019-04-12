from bs4 import BeautifulSoup as bs
import requests
import re


def scrape(soup):

	hour13 = (soup.find(id = "hour13")).text
	# print(hour13)
	hour13_group = soup.find(id = "hour_0_13")
	box_min = hour13_group.find( class_ = 'min')

	ruby_group = box_min.find( class_ = 'ruby')
	min_group = box_min.find( class_ = 'time')
	# print(min_list)

	ruby_list = [r.text for r in ruby_group]
	min_list = [x.text for x in min_group]
	# print(ruby_list)
	# print(min_list)
	
	dic = {}
	dic["weekday"] = []
	for m in min_list:
		dic["weekday"].append({"hour": hour13, "min": m, "type": "null", "rotary": False})
	print(dic)



# schedule = {

#   "13" : {
#       "ruby": ruby_list,
#       "min" : min_list
#   }
# }

	

	

	
	# for r in match_data:
	#   row_data = list(r.strings)
	#   match_data_list.append(row_data)

	# print("first one in the match_data_list")
	# print(match_data_list[0])
	# # returns ['\n', 'S', '\r\n\r\n\t\t\t\t\t\tHaugesund-', 'Sandefjord Fotball', '\n', '(4-2)', '\n']

	# f = open('soccer_stat.csv','w')
	# f.write('R, Home, Away, Score \n') #Give your csv text here.
	# for line in match_data_list:
	#   #just get index 1, 2, 3, 5
	#   templist = []
	#   templist.append(line[1])
	#   templist.append(line[2])
	#   templist.append(line[3])
	#   templist.append(line[5])
	#   line = templist.copy()

	#   print("Get relevant indexes")
	#   print(line)
	#   # returns ['S', '\r\n\r\n\t\t\t\t\t\tHaugesund-', 'Sandefjord Fotball', '(4-2)']

	#   #remove special characters using regex 
	#   line[1] = re.findall(r'\w+', line[1])[0] #findall returns a list so use [0] index at the end to add only the element
	#   # pick '\r\n\r\n\t\t\t\t\t\tHaugesund-' and remove special characters

	#   print("After")
	#   print(line)
	#   # returns ['S', 'Haugesund', 'Sandefjord Fotball', '(4-2)']

	#   for item in line:
	#       if item == line[-1]:
	#           f.write(item)
	#       else:
	#           f.write(item + ", ")
	#   f.write("\n")

	# f.close()


# main

# 23, 26
page = requests.get('http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800141-1/rt:0/nid:00129986/dts:1554660000')

# 28


# 24 sho-sfc
#page = requests.get('http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801156-1/nid:00129893/rt:0/k:%E6%B9%98%E5%8D%97%E5%8F%B0')




soup = bs(page.text, 'html.parser')
scrape(soup)

#output to csv file
# output_results(soup) 







