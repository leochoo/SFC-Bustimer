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
        form
            +++ Section("Config")
            <<< ActionSheetRow<String>("") {
                $0.title = "使用駅"
                $0.selectorTitle = "駅を選択"
                $0.options = ["湘南台","辻堂"]
                $0.value = "湘南台"    // 初期選択項目
                }.onChange{row in
                    print(row.value as Any)
            }
            <<< ButtonRow { row in
                row.title = "時刻表データの更新"
                }.onCellSelection{cell,row in
                    DataUtils.displayAlert(viewController: self)
                    DataUtils.saveData()
            }
        // Do any additional setup after loading the view.
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
