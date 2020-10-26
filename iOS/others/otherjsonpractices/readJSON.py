import json
import requests

#loading json
with open("weekdaytest.json","r") as file:
    timetable = json.load(file)

# print(timetable["hour"])
# print(timetable["hour"][0]["7"])
print(timetable["hour"][0]["7"][0])
print(timetable["hour"][0]["7"][1])

# print(timetable["hour"][0]["7"][0]["minute"])
# print(timetable["hour"][0]["7"][1]["minute"])


