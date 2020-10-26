import requests
import json
from bs4 import BeautifulSoup

def scrape_data(soup):
	"""
	timetable = {
		"start-end(shosfc)":
				"weekday": {
								(int)hour(0-23): [
										{
												"min": (int)minute,
												"type": (str)reference above
										},
								...
								]
						}
	}
	"""
	timetable = {}
	day_type = range(0, 3) # 0: weekday, 1: saturday, 2: sunday

	for dt in day_type:
		# append day type in the whole dictionary set
		if dt == 0:
			dt_key = "weekday"
		elif dt == 1:
			dt_key = "saturday"
		else:
			dt_key = "sunday"
		timetable[dt_key] = {}

		for h in range(7,24):
			_id = "hour_{}_{}".format(dt, h)
			# print(_id)

			timetable[dt_key][h] = [] # dict for minutes
			minutes_group = soup.find(id=_id) 
			# print(minutes_group)

			# check for hours with no buses
			try:
				minutes = minutes_group.find(class_='time').findAll('span')
			except:
				continue

			for item in minutes:
				bus = {}
				minute = int(item.a.get_text())
				bus['min'] = minute
				
				bus['type'] = ''
				timetable[dt_key][h].append(bus)

	# print(timetable)
	print(json.dumps(timetable))

	


if __name__ == '__main__':
	url = []

	# Shonandai -> SFC
	##  23, 24
	# url.append("http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800340-1/nid:00129893/rt:0/k:湘南台")
	## 25
	url.append("http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000802604-1/nid:00129893/")

	for i in range(len(url)):
		response = requests.get(url[i])
		html = response.text
		soup = BeautifulSoup(html, "html.parser")
		scrape_data(soup)



