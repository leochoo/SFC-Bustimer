//
//  DataUtils.swift
//  BusTimerJSON
//
//  Created by 笠原悠生人 on 2019/03/13.
//  Copyright © 2019 team-sfcbustimer. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataUtils{
	class func saveData(){
		currUserTime = Date()

        
		// Get bus timetable
		let	BusJsonUrlString = "https://api.myjson.com/bins/173tvg" // 2019/4/8 edit
        // let BusJsonUrlString = "https://api.myjson.com/bins/1brbhu" // Until 2019/4/7
        
		guard let busUrl = URL(string: BusJsonUrlString) else { return }
		URLSession.shared.dataTask(with: busUrl) { (data, response, err) in
			guard let data = data else { return }
			// storing data directly without parsing
			UserDefaults.standard.set(data, forKey: "timetable")
			}.resume() //end of url session
		
		let holidaysJsonUrlString = "https://holidays-jp.github.io/api/v1/date.json"
		guard let dateUrl = URL(string: holidaysJsonUrlString) else { return }
		URLSession.shared.dataTask(with: dateUrl) { (data, response, err) in
			guard let data = data else { return }
			UserDefaults.standard.set(data, forKey: "holidays")
			}.resume() //end of url session
	}

/* Test Code
	 
	class func checkData(){
		if let timetableData = UserDefaults.standard.data(forKey: "timetable"){
			do{
				let json = try JSON(data: timetableData)
//                print(json)
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		} else {
			print("no timetable data stored")
		}
		
		if let holidaysData = UserDefaults.standard.data(forKey: "holidays"){
			do{
				let json = try JSON(data: holidaysData)
				print(json)
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		} else {
			print("no holidays data stored")
		}
	}
	
	class func DeleteData(){
		UserDefaults.standard.removeObject(forKey: "timetable")
		UserDefaults.standard.removeObject(forKey: "holidays")
	}
 
 */
	
	class func parseHolidaysJson() -> (JSON){
		var json = JSON()
		if let holidaysData = UserDefaults.standard.data(forKey: "holidays"){
			do{
				json = try JSON(data: holidaysData)
//                print(json)
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		} else {
			print("no holidays data stored")
		}
		return json
	}
	
	class func parseTimetableJson() -> (JSON){
		var json = JSON()
		if let timetableData = UserDefaults.standard.data(forKey: "timetable"){
			do{
				json = try JSON(data: timetableData)
//                print(json)
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		} else {
			print("no timetable data stored")
		}
		return json
	}
	
	class func displayAlert(viewController: UIViewController) {
		let title = "データを取得します。"
		let message = ""
		let okText = "OK"
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
		alert.addAction(okayButton)

		viewController.present(alert, animated: true, completion: nil)
	}
	
	class func noDataAlert(viewController: UIViewController){
		//部品のアラートを作る
		let alertController = UIAlertController(title: "時刻表データがありません！", message: "設定画面からデータをダウンロードしてください。", preferredStyle: UIAlertController.Style.alert)
		//OKボタン追加
		let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
			
			//アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				// 0.5秒後に実行したい処理
				viewController.performSegue(withIdentifier: "toConfig", sender: nil)
			}
		}
		)
		
		alertController.addAction(okAction)
		
		//アラートを表示する
		viewController.present(alertController, animated: true, completion: nil)

	}
}
