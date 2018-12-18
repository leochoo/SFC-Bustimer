import json

schedule = {}
shosfc = {}
weekday = []
bus = [{}]

for i in range(7,24):
    bus[0]["h"] = i
    bus[0]["m"] = i
    bus[0]["t"] = "t"

weekday.append(bus[0])
# print(weekday)

shosfc["weeeday"] = weekday
schedule["shosfc"] = shosfc


json_data = json.dumps(schedule)
json_data.replace('\\',"")
# print("hi",json_data)

with open('test.json', 'w') as outfile:
    json.dump(json_data, outfile)

# print("{\"shosfc\": {\"weeeday\": [{\"h\": 7, \"m\": 10, \"t\": \"t\"}]}}")