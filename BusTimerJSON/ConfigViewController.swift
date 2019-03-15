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
            +++ Section("セクション1")
            <<< TextRow { row in
                row.title = "タイトル"
                row.placeholder = "タイトルを入力"
            }
            <<< TextAreaRow { row in
                row.placeholder = "メモを入力"
            }
            // ここからセクション2のコード
            +++ Section("セクション2")
            <<< TextRow { row in
                row.title = "1行メモ"
                row.placeholder = "1行メモを入力"
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
