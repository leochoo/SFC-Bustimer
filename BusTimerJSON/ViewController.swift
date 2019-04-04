//  ViewController.swift
//  BusTimerJSON
//
//  Created by Leonard Choo on 2018/10/27.
//  Copyright © 2018 team-sfcbustimer. All rights reserved.
//
import UIKit
import SwiftyJSON

// global variables
var currUserTime = Date()
var nextBusTime: Date? = nil
var userDirection = "sfcsho"
var timetableJson = JSON()
var holidaysJson = JSON()
var upcomingBuses: [JSON] = []

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        // Robin: Int error check
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var arrival: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var changeDirection: UIButton!
    @IBOutlet weak var busInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var busListButton: UIButton!
    
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        busListButton.isHidden = true
        //データがないときエラー処理
        let holidaysData = UserDefaults.standard.object(forKey: "holidays")
        let timetableData = UserDefaults.standard.object(forKey: "timetable")
        if(holidaysData == nil
            || timetableData == nil){
            DataUtils.noDataAlert(viewController: self)
            UserDefaults.standard.set(false, forKey: "launchedBefore")
        } else {
            //UserDefaultsのデータをjson化
            timetableJson = DataUtils.parseTimetableJson()
            holidaysJson = DataUtils.parseHolidaysJson()
            
            //dept arrv dirc初期化
            initLocation()
            
            //テーブルビューにカスタムセルを登録
            tableView.register (UINib(nibName: "BusCell", bundle: nil),forCellReuseIdentifier:"customCell")
            
            // Run main() and wait for it to finish
            let group = DispatchGroup()
            
            group.enter()
            main()
            group.leave()
            
            // execute the timer only after
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
                RunLoop.main.add(self.timer, forMode:RunLoop.Mode.common)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //設定画面から戻るとき再描画
        //データがないときエラー処理
        let holidaysData = UserDefaults.standard.object(forKey: "holidays")
        let timetableData = UserDefaults.standard.object(forKey: "timetable")
        if(holidaysData == nil
            || timetableData == nil){
            DataUtils.noDataAlert(viewController: self)
            UserDefaults.standard.set(false, forKey: "launchedBefore")
        } else {
            //UserDefaultsのデータをjson化
            timetableJson = DataUtils.parseTimetableJson()
            holidaysJson = DataUtils.parseHolidaysJson()
            initLocation()
            main()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // ステータスバーの文字色を白で指定
        return UIStatusBarStyle.lightContent
    }
    
    func main() {
        let nextBusDateObj = getNextBus()
        // no bus left
        if nextBusDateObj == nil{
            //                print("No BUS")
            DispatchQueue.main.async {//ui update always uses main thread
                self.busInfo.text = ""
                nextBusTime = nil
                self.updateTimeLeft(busTime: nextBusTime)
                self.tableView.reloadData()
            }
        } else {
            //show next bus
            DispatchQueue.main.async {
                self.busInfo.numberOfLines = 0
                self.busInfo.text = DateUtils.dateToStr(dateObj: nextBusDateObj)
                nextBusTime = nextBusDateObj
                self.tableView.reloadData()
                self.updateTimeLeft(busTime: nextBusTime)
            }
        }
    }
    
    func getNextBus() -> (Date?) {
        // get new current time
        currUserTime = Date()
        
        var nextBus: Date? = nil
        upcomingBuses = [] //初期化
        
        //variables for searching in bus for loop
        var isNextBusFound = false
        
        // userWeek = weekend | sat | sun)
        let userWeek = DateUtils.getUserWeek()
        
        // // Get the right schedule from JSON
        let busSchedule = timetableJson[userDirection][userWeek].arrayValue
        let lastBus = busSchedule.last
        let lastBusObj = DateUtils.jsonToDateObj(jsonObj: lastBus)
        if lastBusObj! < currUserTime{
            print("Last bus has left!")
        }
        else{
            for bus in busSchedule{
                let busTimeObj = DateUtils.jsonToDateObj(jsonObj: bus)
                if busTimeObj! > currUserTime{
                    if(!isNextBusFound){
//                        print("Found next bus at", DateUtils.dateToStr(dateObj: busTimeObj))
                        nextBus = busTimeObj
                        isNextBusFound = true
                    }
                    upcomingBuses.append(bus)
                }
            }
        }
        return nextBus
    }
    
    
    func updateTimeLeft(busTime: Date?) {
        if busTime == nil{
            self.timeLeft.text = "No Bus!"
        }else{
            currUserTime = Date()
            //    print("current user time \(currUserTime)")
            //    print("busTime \(busTime)")
            //            print("4 nextBusTime: \(busTime)")
            let elapsedTime = busTime?.timeIntervalSince(currUserTime)
            if Double(elapsedTime ?? 0) > 0 {
                //print("elap: \(elapsedTime) double: \(Double(elapsedTime ?? 0)) int: \(Int(elapsedTime ?? 0))")
                self.timeLeft.text = elapsedTime?.stringFromTimeInterval()
            } else{
                main()
            }
        }
    }
    
    func initLocation() {
        let location = UserDefaults.standard.string(forKey: "location")
        if(location == "Shonandai"){
            self.departure.text = "SFC"
            self.arrival.text = "Shonandai"
            userDirection = "sfcsho"
        } else if (location == "Tsujido"){
            self.departure.text = "SFC"
            self.arrival.text = "Tsujido"
            userDirection = "sfctsuji"
        }
    }
    
    @IBAction func changeDirection(_ sender: Any) {
        
        let temp = self.departure.text
        self.departure.text = self.arrival.text
        self.arrival.text = temp
        
        if userDirection == "sfcsho" {
            userDirection = "shosfc"
            
        } else if userDirection == "shosfc"{
            userDirection = "sfcsho"
            
        } else if userDirection == "sfctsuji"{
            userDirection = "tsujisfc"
            
        } else if userDirection == "tsujisfc"{
            userDirection = "sfctsuji"
        }
        // re-calculate the next bus
        main()
        
    }
    
    @IBAction func changeLocation(_ sender: Any) {
        if self.departure.text == "Shonandai" {
            self.departure.text = "Tsujido"
            userDirection = "tsujisfc"
        }
        else if self.arrival.text == "Shonandai" {
            self.arrival.text = "Tsujido"
            userDirection = "sfctsuji"
        }
        else if self.departure.text == "Tsujido" {
            self.departure.text = "Shonandai"
            userDirection = "shosfc"
        }
        else if self.arrival.text == "Tsujido" {
            self.arrival.text = "Shonandai"
            userDirection = "sfcsho"
        }
        
        main()
    }
    
    @IBAction func checkData(_ sender: Any){
        DataUtils.checkData()
    }
    
    @IBAction func deleteData(_ sender: Any){
        DataUtils.DeleteData()
    }
    
    //table view関連セクション
    //セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingBuses.count
    }
    //セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルのインスタンス作成
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! BusCell
        let bus :JSON = upcomingBuses[indexPath.row]
        
        let busTimeText = String(DateUtils.dateToStr(dateObj:
            DateUtils.jsonToDateObj(jsonObj: bus)).suffix(5))
        var busDetailArray: [String] = []
        
        var imageName = "normal-bus-icon"
        if(bus["type"].stringValue == "t"){
            imageName = "twin-bus-icon"
            busDetailArray.append("ツインライナー")
        } else {
            imageName = "normal-bus-icon"
        }
        
        if(bus["rotary"].stringValue == "true" || bus["type"].stringValue == "19"){
            busDetailArray.append("ロータリー発")
        }
        if(bus["type"].stringValue == "s"){
            busDetailArray.append("笹久保経由")
        }
        let busDetailText = busDetailArray.joined(separator: " ")
        cell.show(busTimeText: busTimeText, imageName: imageName, busDetailText: busDetailText)
        
        return cell
    }
}
