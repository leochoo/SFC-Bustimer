//  ViewController.swift
//  BusTimerJSON
//
//  Created by Leonard Choo on 2018/10/27.
//  Copyright © 2018 team-sfcbustimer. All rights reserved.
//
import UIKit
import SwiftyJSON

func getNextBus(callback: @escaping (Date?)->()) {
    // User inputs
    
    var userWeek = ""
    var _nextBus: Date? = nil
    // update current time
    currUserTime = Date()
    
    let arrayKeys = Array(holidaysJson.dictionaryValue.keys)
    // get today in a format comparable
    var todayFormatted = DateUtils.getDateTime()
    print(todayFormatted)
    todayFormatted = todayFormatted.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
    // Identify if today is weekday, saturday or holiday
    userWeek = DateUtils.identifyDayType(today: todayFormatted, holidays: arrayKeys)
    
    
    // Get next bus information
    // list of weekday buses
    let busSchedule = timetableJson[userDirection][userWeek].arrayValue
    // check if the last bus has left
    let lastBus = busSchedule.last
    // convert JSON to date object
    let lastBusObj = DateUtils.jsonToDateObj(jsonObj: lastBus)
    // Compare
    if lastBusObj! < currUserTime{
        print("Last bus has left!")
    }
    else{
        // Find the next bus
        for bus in busSchedule{
            // convert JSON to date object
            let busTimeObj = DateUtils.jsonToDateObj(jsonObj: bus)
            // Compare
            if busTimeObj! > currUserTime{
                print("Found next bus at", DateUtils.dateToStr(dateObj: busTimeObj))
                _nextBus = busTimeObj
                break
            }
        }
    }
    //                    print("1 \(_nextBus)")
    callback(_nextBus)
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
var timetableJson = JSON()
var holidaysJson = JSON()

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
                    self.busInfo.text = DateUtils.dateToStr(dateObj: nextBusDateObj)
                    nextBusTime = nextBusDateObj
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaultsのデータをjson化
        timetableJson = DataUtils.parseTimetableJson()
        holidaysJson = DataUtils.parseHolidaysJson()

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
    
    @IBAction func checkData(_ sender: Any){
        DataUtils.checkData()
    }
    
    @IBAction func deleteData(_ sender: Any){
        DataUtils.DeleteData()
    }
}
