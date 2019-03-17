//
//  DateUtils.swift
//  BusTimerJSON
//
//  Created by 笠原悠生人 on 2019/03/13.
//  Copyright © 2019 team-sfcbustimer. All rights reserved.
//

import Foundation
import SwiftyJSON

class DateUtils{
    //return date time info as string (yyyy/M/dd H:mm)
    class func getDateTime() -> String{
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
    class func getUserWeek() -> String {
        let arrayKeys = Array(holidaysJson.dictionaryValue.keys)
        var todayFormatted = DateUtils.getDateTime()
        todayFormatted = todayFormatted.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
        return DateUtils.identifyDayType(today: todayFormatted, holidays: arrayKeys)
    }
    class func identifyDayType(today:String, holidays:[String]) -> String{
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
    
    class func isHoliday(today:String, holidays:[String]) -> Bool {
        var result = false
        for i in holidays {
            if(today == i){
                result = true
            }
        }
        return result
    }
    
    class func getDayOfWeek() -> Int{
        let date = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        //    print("Weekday \(weekday)") // 1, 2, 3, .... 2 is Monday
        return dayOfWeek
    }
    
    class func strToDate(str:String)-> Date?{
        //    print("str",str)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd H:mm"
        //    dateFormatter.locale = Locale(identifier: "en_US_POSIX") //王道パターン
        let date = dateFormatter.date(from: str)
        //    print(dateFormatter.string(from: date!)) //値自体は変わらない
        return date
    }
    
    class func dateToStr(dateObj: Date?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd H:mm"
        return dateFormatter.string(from: dateObj!)
    }
    
    class func jsonToDateObj(jsonObj: JSON?) -> Date?{
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
}
