//
//  BugReportVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-17.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class BugReportVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BugReportCreationTitleDescriptionCell") as! BugReportCreationTitleDescriptionCell
        return cell
    }
}
