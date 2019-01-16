//  ViewController.swift
//  BusTimerJSON
//
//  Created by Leonard Choo on 2018/10/27.
//  Copyright © 2018 team-sfcbustimer. All rights reserved.
//
import UIKit
import SwiftyJSON

//return date time info as string (yyyy/M/dd H:mm)
func getDateTime() -> String{
	let date = Date()
	let dateFormatter = DateFormatter()
	dateFormatter.dateStyle = .medium
	dateFormatter.timeStyle = .none
	dateFormatter.locale = Locale(identifier: "ja_JP")
	dateFormatter.timeZone = TimeZone(abbreviation: "JST")
	let today = dateFormatter.string(from: date)
	//    print("getDateTime:",today)
	return today //return 2019/01/05
}

func identifyDayType(today:String, holidays:[String]) -> String{
	let dayOfWeek = getDayOfWeek()
	if(isHoliday(today: today, holidays: holidays)){
		print("Holiday スケジュール")
//        return "holiday"
		return "sun"
	} else if(dayOfWeek == 1){
		print("Sunday スケジュール")
		return "sun"
	} else if(dayOfWeek == 7){
		print("Saturday スケジュール")
		return "sat"
//        return "saturday"
	} else {
		print("Weekday スケジュール")
		return "weekday"
	}
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

func getDayOfWeek() -> Int{
	let date = Date()
	let calendar = Calendar.current
	let dayOfWeek = calendar.component(.weekday, from: date)
	//    print("Weekday \(weekday)") // 1, 2, 3, .... 2 is Monday
	return dayOfWeek
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



func main( callback: @escaping (JSON?)->() ){
    // User inputs
    var userDirection = "sfcsho"
    var userWeek = ""
    let currUserTime = Date()
    var _nextBus: JSON? = nil
    
    // Get value for userWeek: weekday, saturday or holiday
    let jsonUrlString = "https://holidays-jp.github.io/api/v1/date.json"
    guard let url = URL(string: jsonUrlString) else {return}
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
            let json = try JSON(data: data)
            let arrayKeys = Array(json.dictionaryValue.keys)
            // get today in a format comparable
            var todayFormatted = getDateTime()
            print(todayFormatted)
            todayFormatted = todayFormatted.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
            // Identify if today is weekday, saturday or holiday
            userWeek = identifyDayType(today: todayFormatted, holidays: arrayKeys)

            
	        // 2nd url session
	        // Get next bus information
		    let jsonUrlString2 = "https://api.myjson.com/bins/gd65c" //1/14/2019 data
		    guard let url2 = URL(string: jsonUrlString2) else {return}
		    URLSession.shared.dataTask(with: url2) { (data, response, err) in
		        guard let data = data else { return }
		        do {
		            let json = try JSON(data: data)
		            
		            // list of weekday buses
		            let busSchedule = json[userDirection][userWeek].arrayValue
		            
		            // check if the last bus has left
		            let lastBus = busSchedule.last!
		            let dateFormatter = DateFormatter()
		            dateFormatter.dateFormat = "yyyy/MM/dd"
		            // ex: 2019/01/11
		            let currDateOnly = dateFormatter.string(from: currUserTime)
		            // currDateOnly + busHour:busMin   ex: 2019/01/11 09:25
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
		                        _nextBus = bus
		                        break
		                    }
		                }
		            }

//                    print("1 \(_nextBus)")
				    callback(_nextBus)

		        } catch let jsonErr {
		            print("Error serializing json:", jsonErr)
		        }
		        
		        }.resume() //end of 2nd url session

       
        } catch let jsonErr {
            print("Error serializing json:", jsonErr)
        }
        }.resume()  // end of 1st urlsession    
    
    
    
    
    
}


class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
//
//        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//
//            let nextBus = main()
//            if nextBus == nil{
//                print("No BUS")
//            } else{
//                print(nextBus!)
//            }
//        }
//


        main() { (nextBus) -> () in
//            print("2 \(nextBus)")
            if nextBus == nil{
                print("No BUS")
            } else{
                print("The next bus is")
                print(nextBus!)
            }
        }
        
    
        
		
	}
	
	
}
