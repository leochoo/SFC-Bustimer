//  ViewController.swift
//  BusTimerJSON
//
//  Created by Leonard Choo on 2018/10/27.
//  Copyright © 2018 team-sfcbustimer. All rights reserved.
//
import UIKit
import SwiftyJSON

struct Direction: Decodable{
	let shosfc: [Day]?
	let shosfc_t: [Day]?
	let tsujisfc: [Day]?
	let tsujisfc_t: [Day]?
	let sfcsho: [Day]?
	let sfcsho_t: [Day]?
	let sfcsho_tyokkou: [Day]?
	let sfctsuji: [Day]?
	let sfctsuji_t: [Day]?
}

struct Day: Decodable{
	let weekday: [Bus]?
	let sat: [Bus]?
	let sun: [Bus]?
}

struct Bus: Decodable{
	let hour: Int?
	let min: Int?
	let type: String?
}

//used for Holiday identification, return only date as string
func getDateForHoliday() -> String{
	let date = Date()
	let dateFormatter = DateFormatter()
	dateFormatter.dateStyle = .medium
	dateFormatter.timeStyle = .none
	dateFormatter.locale = Locale(identifier: "ja_JP")
	dateFormatter.timeZone = TimeZone(abbreviation: "JST")
	let today = dateFormatter.string(from: date)
	//    print("getDate:",today)
	return today //return 2019/01/05   (yyyy/MM/dd)
}

func identifyDay(today:String, holidays:[String]) -> String{
	let weekday = getToday()
	if(isHoliday(today: today, holidays: holidays)){
		print("Holiday スケジュール")
		return "holiday"
	} else if(weekday == 1){
		print("Sunday スケジュール")
		return "holiday"
	} else if(weekday == 7){
		print("Saturday スケジュール")
		return "saturday"
	} else {
		print("Weekday スケジュール")
		return "weekday"
	}
}

//return date and time as string
func getDateTime() -> String{
	let date = Date()
	let dateFormatter = DateFormatter()
	dateFormatter.dateStyle = .medium
	dateFormatter.timeStyle = .short
	dateFormatter.locale = Locale(identifier: "ja_JP")
	dateFormatter.timeZone = TimeZone(abbreviation: "JST")
	let today = dateFormatter.string(from: date)
	//    print("getDateTime:",today)
	return today //return 2019/01/05 1:14   (yyyy/M/dd H:mm)
}

func getToday() -> Int{
	let date = Date()
	let calendar = Calendar.current
	let weekday = calendar.component(.weekday, from: date)
	//    print("Weekday \(weekday)") // 1, 2, 3, .... 2 is Monday
	return weekday
}

func isHoliday(today:String, holidays:[String]) -> Bool {
	var result = false
	for i in holidays {
		if(today == i){
			result = true
		}
	}
	return result
}


func strToDate(str:String)-> Date?{
	//    print("str",str)
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy/MM/dd H:mm"
	//    dateFormatter.locale = Locale(identifier: "en_US_POSIX") //王道パターン
	let date = dateFormatter.date(from: str)
	//    print(dateFormatter.string(from: date!)) //値自体は変わらない
	return date
}

func dateToStr(dateObj: Date?) -> String{
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy/MM/dd H:mm"
	return dateFormatter.string(from: dateObj!)
}


class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Check Holiday
		var today = getDateForHoliday()
		// match for formatting of holiday with api data
		today = today.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
		let jsonUrlString = "https://holidays-jp.github.io/api/v1/date.json"
		guard let url = URL(string: jsonUrlString) else {return}
		
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			guard let data = data else { return }
			
			do {
				let json = try JSON(data: data)
				let arrayKeys = Array(json.dictionaryValue.keys)
				//                // check whether today is weekday, sat, or holiday
				identifyDay(today: today, holidays: arrayKeys)
				
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
			
			}.resume()
		
		
		// Finding The Next Bus
		let jsonUrlString2 = "https://api.myjson.com/bins/6ij3g" //正しいデータ
		guard let url2 = URL(string: jsonUrlString2) else {return}
		URLSession.shared.dataTask(with: url2) { (data, response, err) in
			guard let data = data else { return }
			do {
				let json = try JSON(data: data)
//                print(json["shosfc"][0]["weekday"])
				
//                // Test main logic with sample user inputs
				let userDirection = "shosfc"
				let userWeek = "weekday"
				let currUserTime = Date()
				
				// list of weekday buses
				let busSchedule = json[userDirection][0][userWeek].arrayValue
				
				// check if the last bus has left
				let lastBus = busSchedule.last!
                print(lastBus)
				// get today's date 2019/01/11
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy/MM/dd"
				let currDateOnly = dateFormatter.string(from: currUserTime)
                // append today's date to the bus hour and bus minute
                // 2019/01/11 09:25
				let lastBusStr = "\(currDateOnly) \(lastBus["hour"].intValue):\(lastBus["min"].intValue)"
				// convert string to dateTime object
				let lastBusObj = strToDate(str:lastBusStr)
                
				// Compare
				if lastBusObj! < currUserTime{
					print("Last bus has left!")
                    
				}
                else{
					// Find the next bus
					for bus in busSchedule{
						let busTimeStr = "\(currDateOnly) \(bus["hour"].intValue):\(bus["min"].intValue)"
						// convert string to dateTime object
						let busTimeObj = strToDate(str:busTimeStr)
						// Compare
						if busTimeObj! > currUserTime{
							print("Found next bus at",dateToStr(dateObj: busTimeObj))
							break
						}
					}
                }
				
				

				
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
			
			}.resume()
		
	}
	
	
}
