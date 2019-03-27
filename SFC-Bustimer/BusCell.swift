//
//  BusCell.swift
//  BusTimerJSON
//
//  Created by 笠原悠生人 on 2019/03/21.
//  Copyright © 2019 team-sfcbustimer. All rights reserved.
//

import UIKit
import SwiftyJSON

class BusCell: UITableViewCell {


    @IBOutlet weak var busImage: UIImageView!
    @IBOutlet weak var busTimeText: UILabel!
    @IBOutlet weak var busDetailText: UILabel!
    
    func show(busTimeText: String, imageName: String, busDetailText: String){
        self.busTimeText.text = busTimeText
        self.busImage.image = UIImage(named: imageName)
        self.busDetailText.text = busDetailText
    }
}
