//
//  SearchVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationSearchOptions = ["Country", "Province", "City"]
    let categorySearchOptions = ["Sport", "Entertainment", "Travel", "Food", "Study"]
    var locationselected: Bool = true
    var locationOption: String!
    var categoryValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locationselected {
            return locationSearchOptions.count
        } else {
            return categorySearchOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        var searchOption: String
        if locationselected {
            searchOption = locationSearchOptions[indexPath.row]
        } else {
            searchOption = categorySearchOptions[indexPath.row]
        }
        cell.configureCell(searchOption: searchOption)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if locationselected {
            locationOption = locationSearchOptions[indexPath.row]
            performSegue(withIdentifier: "LocationSearchVC", sender: nil)
        } else {
            categoryValue = categorySearchOptions[indexPath.row]
            performSegue(withIdentifier: "SearchResultVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocationSearchVC {
            destination.selectedOption = locationOption
        }
        if let destination = segue.destination as? SearchResultVC {
            destination.selectedOption = categoryValue
        }
    }
    
    @IBAction func byLocationBtnPressed(_ sender: UIButton) {
        locationselected = true
        tableView.reloadData()
    }
    
    @IBAction func byCategoryBtnPressed(_ sender: UIButton) {
        locationselected = false
        tableView.reloadData()
    }
}
