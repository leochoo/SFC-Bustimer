import UIKit

// Date and Time
var date = Date()
let calendar = Calendar.current

let month = calendar.component(.month, from: date)
let day = calendar.component(.day, from: date)
let hour = calendar.component(.hour, from: date)
let minute = calendar.component(.minute, from: date)
let second = calendar.component(.second, from: date)

let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .full
dateFormatter.locale = Locale(identifier: "ja_JP")
dateFormatter.string(from: date) //2018年10月14日 日曜日 23時57分58秒 日本標準時

dateFormatter.timeZone = TimeZone(abbreviation: "JST")
dateFormatter.string(from: date)

let dayOfWeek = calendar.component(.weekday, from: date)
print(dateFormatter.shortWeekdaySymbols)

// Printing every second

//1st way
//for _ in 1...10
//{
//    date = Date()
//    print(dateFormatter.string(from: date))
//    sleep(1)
//}

// 2nd way
//let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//    date = Date()
//    let result = "Now is " + dateFormatter.string(from: date)
//    print(result)
//}


//let dirs = NSSearchPathForDirectoriesInDomains(.documentDirectory,                                               .userDomainMask, true)



let aString = "2018/11/11"
let newString = aString.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
