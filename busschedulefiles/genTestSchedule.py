import json

testData = {}

testData["sfcsho"] = {}
testData["sfcsho"]["weekday"] = []
# testData["sfcsho"]["sat"] = {}
# testData["sfcsho"]["sun"] = {}





for h in range(0,24):
	for m in range(0,60):
		busData = {
			"hour": h,
			"min": m,
			"type": None,
			"rotary": False
		}
		testData["sfcsho"]["weekday"].append(busData)

# print(testData)
# print(json.dumps(testData))

with open('testData.json', 'w') as outfile:
	json.dump(testData, outfile, indent=4)

