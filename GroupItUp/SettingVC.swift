//
//  SettingVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-15.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class SettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    let settingOptions = ["Update display photo", "Update group detail", "Add previous group photos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        let option = settingOptions[indexPath.row]
        cell.configureCell(option: option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "DisplayPhotoUpdateVC", sender: nil)
        }
    }
}
