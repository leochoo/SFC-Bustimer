//
//  ViewController.swift
//  BusTimerJSON
//
//  Created by Leonard Choo on 2018/10/27.
//  Copyright © 2018 team-sfcbustimer. All rights reserved.
//
import UIKit

struct Direction: Decodable{
    let shosfc: [Day]?
    let sfcsho: [Day]?
}

struct Day: Decodable{
    let weekday: [Bus]?
    let sat: [Bus]?
    let sun: [Bus]?
}

struct Bus: Decodable{
    let h: Int?
    let m: Int?
    let type: String?
}

func getDate() -> String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.timeZone = TimeZone(abbreviation: "JST")
    var today = dateFormatter.string(from: date)
    today = today.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
    return today
}

func getDay() -> Int{
    let date = Date()
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
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

func identifyDay(today:String, holidays:[String]){
    let weekday = getDay()
    if(isHoliday(today: today, holidays: holidays)){
        print("Holiday スケジュール")
    } else if(weekday == 1){
        print("Sunday スケジュール")
    } else if(weekday == 7){
        print("Saturday スケジュール")
    } else {
        print("Weekday スケジュール")
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = getDate()
        let jsonUrlString = "https://holidays-jp.github.io/api/v1/date.json"
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode([String: String].self, from: data)
                var keys = Array(response.keys)
                identifyDay(today: today, holidays: keys)
                
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
        
        
        
        //        let jsonUrlString = "https://api.myjson.com/bins/y7ito"
        //        guard let url = URL(string: jsonUrlString) else {return}
        //
        //        URLSession.shared.dataTask(with: url) { (data, response, err) in
        //            guard let data = data else { return }
        //            //         let dataAsString = String(data: data, encoding: .utf8)
        //            //            print(dataAsString)
        //            do {
        //                //  Swift 4
        //                let busTimer = try JSONDecoder().decode(Direction.self, from: data)
        //                //                print(busTimer)
        //                //                print(busTimer.shosfc)
        //                for i in busTimer.shosfc![0].weekday! {
        //                    print(i.h!)
        //                    print(i.m!)
        //                }
        //                print("Sho->SFC, Weekday: ",busTimer.shosfc?[0].weekday!)
        //                print("Sho->SFC, Saturday: ",busTimer.shosfc?[1].sat!)
        //
        //                //write functions to get busNum, get hh, mm etc?
        //
        //            } catch let jsonErr {
        //                print("Error serializing json:", jsonErr)
        //            }
        //
        //            }.resume()
        
    }
    
    
}
