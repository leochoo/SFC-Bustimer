//
//  ViewController.swift
//  SFCBustimer
//
//  Created by Leonard Choo on 2019/03/03.
//  Copyright © 2019 LeonardChoo. All rights reserved.
//

import UIKit

struct Direction: Codable{
    let shosfc: [Day]
    let tsujisfc: [Day]
    let sfcsho: [Day]
    let sfctsuji: [Day]
}

struct Day: Codable{
    let weekday: [Bus]
    let sat: [Bus]
    let sun: [Bus]
}

struct Bus: Codable{
    let hour: Int
    let min: Int
    let type: String
    
    // I might have to have all the values representing hour min and type here? wtf...
    enum CodingKeys: String, CodingKey {
        case h1 = "1"
        case h2 = "2"
        case h3 = "3"
        case h4 = "4"
        case h5 = "5"
        case h6 = "6"
        case h7 = "7"
        case h8 = "8"
        case h9 = "9"
        case h10 = "10"
        case h11 = "11"
        case h12 = "12"
        case h13 = "13"
        case h14 = "14"
        case h15 = "15"
        case h16 = "16"
        case h17 = "17"
        case h18 = "18"
        case h19 = "19"
        case h20 = "20"
        case h21 = "21"
        case h22 = "22"
        case h23 = "23"
    }
    
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Download JSON
        if let url = URL(string: "https://api.myjson.com/bins/10zfwo") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // upwrapping data
                if let data = data {
                    // unwrap to deserealize
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        // unwrap one more time since try? was above
                        if let jsonDictionary = json {
                            // update Views in main thread
                            DispatchQueue.main.async {
                                
                                if let usd = jsonDictionary["USD"] {
                                    self.usdLabel.text = self.formatCurrency(price: usd, currencyCode: "USD")
                                    UserDefaults.standard.set(usd, forKey: "USD")
                                }
                                if let krw = jsonDictionary["KRW"] {
                                    UserDefaults.standard.set(krw, forKey: "KRW")
                                    self.krwLabel.text = self.formatCurrency(price: krw, currencyCode: "KRW")
                                }
                                if let jpy = jsonDictionary["JPY"] {
                                    UserDefaults.standard.set(jpy, forKey: "JPY")
                                    self.jpyLabel.text = self.formatCurrency(price: jpy, currencyCode: "JPY")
                                }
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                } else {
                    print("Something went wrong")
                }
                }.resume()
        }
        
        
        
        UserDefaults.standard.data(forKey: <#T##String#>)
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }


}

