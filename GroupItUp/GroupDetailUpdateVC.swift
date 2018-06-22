//
//  GroupDetailUpdateVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-24.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol GroupDetailUpdateVCDelegate {
    func updateGroupDetailFromGroupDetailUpdateVC(detail:GroupDetail)
    func updateGroupAddressFromGroupDetailUpdateVC(address: Address)
}

class GroupDetailUpdateVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, GroupDetailUpdateCellDelegate, GroupAddressUpdateCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let categoryArray = ["", "Sport", "Entertainment", "Travel", "Food", "Study"]
    var countries: [String] = []
    var countryPicker: UIPickerView!
    var pickerView: UIPickerView!
    var groupMeetingAddress: Address!
    var groupDetail: Dictionary<String, Any>!
    var currentGroup: Group!
    var delegate: GroupDetailUpdateVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
//        parseCountriesCSV()
    }
    
//    func parseCountriesCSV() {
//        let path = Bundle.main.path(forResource: "countries", ofType: "csv")!
//        
//        do {
//            let csv = try CSV(contentsOfURL: path)
//            let rows = csv.rows
//            
//            for row in rows {
//                let country = row["country"]!
//                countries.append(country)
//            }
//            
//        } catch let err as NSError {
//            
//            print(err.debugDescription)
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailUpdateCell") as! GroupDetailUpdateCell
            cell.maxTextField.keyboardType = .numberPad
            //            cell.timeSwitch.setOn(false, animated: false)
            let datePicker = UIDatePicker()
            datePicker.minimumDate = NSDate() as Date
            cell.timeTextField.inputView = datePicker
            cell.datePicker = datePicker
            cell.contactTextField.keyboardType = .default
            cell.phoneTextField.keyboardType = .phonePad
            cell.emailTextField.keyboardType = .emailAddress
            cell.categoryTextField.inputView = pickerView
            cell.pickerView = pickerView
            cell.delegate = self
            cell.configureCell(group: currentGroup)
            cell.setCurrentGroup(group: currentGroup)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupAddressUpdateCell") as! GroupAddressUpdateCell
            
            cell.countryTextField.inputView = countryPicker
            cell.countryPicker = countryPicker
            cell.countries = countries
            cell.delegate = self
            cell.setCurrentGroup(group: currentGroup)
            cell.configureCell(group: currentGroup)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Group Detail"
        } else {
            return "Address"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(countryPicker) {
            return countries.count
        }
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(countryPicker) {
            return countries[row]
        }
        return categoryArray[row]
    }
    
    //From GroupAddressUpdateCell
    func updateGroupAddressForFirebase(address: Dictionary<String, String>) {
        for (key, value) in address {
            DataService.ds.REF_GROUPS.child(currentGroup.groupID).child("Group Detail").child("Address").child(key).setValue(value)
        }
        
    }
    
    func updateGroupAddressForCurrentGroup(address: Address) {
        if let delegate = self.delegate {
            delegate.updateGroupAddressFromGroupDetailUpdateVC(address: address)
        }
    }
    
    
    // From GroupDetailUpdateCell
    func updateGroupDetailForFirebase(detail: Dictionary<String, Any>) {
        groupDetail = detail as Dictionary<String, Any>
        for (key, value) in groupDetail {
            DataService.ds.REF_GROUPS.child(currentGroup.groupID).child("Group Detail").child(key).setValue(value)
        }
    }
    
    func updateGroupDetailForCurrentGroup(detail: GroupDetail) {
        currentGroup.groupDetail = detail
        if let delegate = self.delegate {
            delegate.updateGroupDetailFromGroupDetailUpdateVC(detail: currentGroup.groupDetail)
        }
    }
}
