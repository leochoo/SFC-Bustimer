//
//  ConfigViewController.swift
//  BusTimerJSON
//
//  Created by 笠原悠生人 on 2019/03/16.
//  Copyright © 2019 team-sfcbustimer. All rights reserved.
//

import UIKit
import Eureka

class ConfigViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let location = UserDefaults.standard.string(forKey: "location")
        form
            +++ Section("Config")
            <<< ActionSheetRow<String>("") {
                $0.title = "使用駅"
                $0.selectorTitle = "駅を選択"
                $0.options = ["Shonandai","Tsujido"]
                $0.value = location    // 初期選択項目
                }.onChange{row in
                    print(row.value as Any)
                    if(row.value == "Shonandai"){
                        UserDefaults.standard.set("Shonandai", forKey: "location")
                    } else if(row.value == "Tsujido"){
                        UserDefaults.standard.set("Tsujido", forKey: "location")
                    }
            }
            <<< ButtonRow { row in
                row.title = "時刻表データの更新"
                }.onCellSelection{cell,row in
                    DataUtils.saveData()
                    DataUtils.displayAlert(viewController: self)
            }
        // Do any additional setup after loading the view.
    }
    
    //このビューを表示するときにナビゲーションバーを表示して、戻るときは非表示にする
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
