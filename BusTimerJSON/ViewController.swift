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

func jsonToDateObj(jsonObj: JSON?) -> Date?{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    // ex: 2019/01/11
    let currDateOnly = dateFormatter.string(from: currUserTime)
    // "currDateOnly + busHour:busMin"   ex: "2019/01/11 09:25"
    let jsonTimeStr = "\(currDateOnly) \(jsonObj!["hour"].intValue):\(jsonObj!["min"].intValue)"
    // convert string to dateTime object
    let busDateObj = strToDate(str:jsonTimeStr)
    return busDateObj
}


func getNextBus( callback: @escaping (Date?)->() ) {
    // User inputs
    
    var userWeek = ""
    var _nextBus: Date? = nil
    // update current time
    currUserTime = Date()
    
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
            let jsonUrlString2 = "https://api.myjson.com/bins/10zfwo" // before type 2
//            let jsonUrlString2 = "https://api.myjson.com/bins/1ehrmg" // before adding type
//            let jsonUrlString2 = "https://api.myjson.com/bins/gd65c" //1/14/2019 data
//            let jsonUrlString2 = "https://api.myjson.com/bins/12dxt4" //testData generated for every h:m on 1/31
            guard let url2 = URL(string: jsonUrlString2) else {return}
            URLSession.shared.dataTask(with: url2) { (data, response, err) in
                guard let data = data else { return }
                do {
                    let json = try JSON(data: data)
                    
                    // list of weekday buses
                    let busSchedule = json[userDirection][userWeek].arrayValue
                    // check if the last bus has left
                    let lastBus = busSchedule.last
                    // convert JSON to date object
                    let lastBusObj = jsonToDateObj(jsonObj: lastBus)
                    // Compare
                    if lastBusObj! < currUserTime{
                        print("Last bus has left!")
                    }
                    else{
                        // Find the next bus
                        for bus in busSchedule{
                            // convert JSON to date object
                            let busTimeObj = jsonToDateObj(jsonObj: bus)
                            // Compare
                            if busTimeObj! > currUserTime{
                                print("Found next bus at",dateToStr(dateObj: busTimeObj))
                                _nextBus = busTimeObj
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


extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = Int(self)
        //        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        //        print("5 here?")
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
}


// global variables
var currUserTime = Date()
var nextBusTime: Date? = nil
var userDirection = "sfcsho"
var dept = "sfc"
var arrv = "Shonandai"

class ViewController: UIViewController {
    
    
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var arrival: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var changeDirection: UIButton!
    @IBOutlet weak var busInfo: UILabel!
    @IBOutlet var changeLocation: UIButton!
    
    var timer = Timer()
    
    func updateTimeLeft(busTime: Date?) {
        if busTime == nil{
            self.timeLeft.text = "no more bus"
        }else{
            currUserTime = Date()
            //    print("current user time \(currUserTime)")
            //    print("busTime \(busTime)")
            //            print("4 nextBusTime: \(busTime)")
            let elapsedTime = busTime?.timeIntervalSince(currUserTime)
            if Double(elapsedTime ?? 0) > 0 {
                print("elap: \(elapsedTime) double: \(Double(elapsedTime ?? 0)) int: \(Int(elapsedTime ?? 0))")
                self.timeLeft.text = elapsedTime?.stringFromTimeInterval()
            } else{
                main()
            }
        }
    }
    
    func main() {
        getNextBus() { (nextBusDateObj) -> () in
            // no bus left
            if nextBusDateObj == nil{
//                print("No BUS")
                DispatchQueue.main.async {//ui update always uses main thread
                    self.busInfo.text = "No bus!"
                }
            } else {
                //show next bus
                DispatchQueue.main.async {
                    self.busInfo.numberOfLines = 0
                    self.busInfo.text = dateToStr(dateObj: nextBusDateObj)
                    nextBusTime = nextBusDateObj
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let group = DispatchGroup()
        
        group.enter()
        main()
        group.leave()
        
        group.notify(queue: .main){
            if self.timer.isValid{
                self.timer.invalidate()
                self.timer = Timer()
            }
            
            //            print("2 nextBusTime: \(nextBusTime)")
            //call every 1 sec
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                //                print("3 nextBusTime: \(nextBusTime)")
                self.updateTimeLeft(busTime: nextBusTime)
            }
        }
        
    }
    
    @IBAction func changeDirection(_ sender: Any) {
        var dept = "SFC"
        var arrv = "Shonandai"
        // 2/1 Finish switching from shonandai to tsujido
        
        
        if self.departure.text == "SFC" || self.arrival.text == "SFC" {
            if self.departure.text == "SFC"{
                self.departure.text = "Shonandai"
                self.arrival.text = "SFC"
                // "shosfc"
                userDirection = "shosfc"
                main()
            } else {
                self.departure.text = "SFC"
                self.arrival.text = "Shonandai"
                // "sfcsho"
                userDirection = "sfcsho"
                main()
            }
        } else {
            if self.departure.text == "Tsujido"{
                self.departure.text = "tsuji"
                self.arrival.text = "SFC"
                userDirection = "tsujisfc"
                main()
            } else {
                self.departure.text = "SFC"
                self.arrival.text = "tsuji"
                userDirection = "sfctsuji"
                main()
            }
        }
    }
    @IBAction func changeLocation(_ sender: Any) {
        if self.departure.text == "SFC" || self.arrival.text == "SFC" {
            if self.departure.text == "Tsujido"{
                self.departure.text = "tsuji"
                self.arrival.text = "SFC"
                userDirection = "tsujisfc"
                main()
            } else {
                self.departure.text = "SFC"
                self.arrival.text = "tsuji"
                userDirection = "sfctsuji"
                main()
            }
        } else {
            if self.departure.text == "SFC"{
                self.departure.text = "Shonandai"
                self.arrival.text = "SFC"
                // "shosfc"
                userDirection = "shosfc"
                main()
            } else {
                self.departure.text = "SFC"
                self.arrival.text = "Shonandai"
                userDirection = "sfcsho"
                main()
            }
        }
    }
    
    @IBAction func saveData(_ sender: Any) {
        // Get bus timetable
        let jsonUrlString = "https://api.myjson.com/bins/10zfwo" // before type 2
        //            let jsonUrlString2 = "https://api.myjson.com/bins/1ehrmg" // before adding type
        //            let jsonUrlString2 = "https://api.myjson.com/bins/gd65c" //1/14/2019 data
        //            let jsonUrlString2 = "https://api.myjson.com/bins/12dxt4" //testData generated for every h:m on 1/31
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            // storing data directly without parsing
            do{
                UserDefaults.standard.set(data, forKey: "timetable")
            } catch let Err {
                print("Error", Err)
            }
            }.resume() //end of url session
    }
    
    @IBAction func checkData(_ sender: Any){
        // should serializing json after loading from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "timetable"){
            do{
                let json = try JSON(data: data)
                print(json)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }
    }
}



