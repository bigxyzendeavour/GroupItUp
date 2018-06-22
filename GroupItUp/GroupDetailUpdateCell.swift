//
//  GroupDetailUpdateCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-24.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

protocol GroupDetailUpdateCellDelegate {
    func updateGroupDetailForFirebase(detail: Dictionary<String, Any>)
    func updateGroupDetailForCurrentGroup(detail: GroupDetail)
}

class GroupDetailUpdateCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var maxTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    var delegate: GroupDetailUpdateCellDelegate?
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    let categoryArray = ["", "Sport", "Entertainment", "Travel", "Food", "Study"]
    static var detail = [String: Any]()
    var currentGroup: Group!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        maxTextField.delegate = self
        timeTextField.delegate = self
        contactTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        categoryTextField.delegate = self
        
        if !timeSwitch.isOn {
            timeTextField.isEnabled = false
        }
        
    }

    func configureCell(group: Group) {
        maxTextField.text = "\(group.groupDetail.groupMaxMembers)"
        timeTextField.text = group.groupDetail.groupMeetingTime
        contactTextField.text = group.groupDetail.groupContact
        phoneTextField.text = "\(group.groupDetail.groupContactPhone)"
        emailTextField.text = group.groupDetail.groupContactEmail
        categoryTextField.text = group.groupDetail.groupCategory
    }
    
    func setCurrentGroup(group: Group) {
        currentGroup = group
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            let tag = textField.tag
            switch tag {
            case 0:
                if let max = Int(maxTextField.text!) {
                    GroupDetailUpdateCell.detail["Max Attending Members"] = max
                    currentGroup.groupDetail.groupMaxMembers = max
                } else {
                    GroupDetailUpdateCell.detail["Max Attending Members"] = nil
                }
                break
            case 1:
                let selectedDate = datePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let date = dateFormatter.string(from: selectedDate as Date)
                if timeSwitch.isOn {
                    timeTextField.text = date
                    GroupDetailUpdateCell.detail["Time"] = date
                    currentGroup.groupDetail.groupMeetingTime = date
                }
                break
            case 2:
                let contactPerson = contactTextField.text
                if contactPerson != "" {
                    GroupDetailUpdateCell.detail["Contact"] = contactPerson
                    currentGroup.groupDetail.groupContact = contactPerson!
                } else {
                    GroupDetailUpdateCell.detail["Contact"] = nil
                }
                break
            case 3:
                if let phoneNumber = phoneTextField.text {
                    if phoneNumber != "" {
                        GroupDetailUpdateCell.detail["Phone"] = phoneNumber
                        currentGroup.groupDetail.groupContactPhone = phoneNumber
                    } else {
                        GroupDetailUpdateCell.detail["Phone"] = nil
                    }
                }
                break
            case 4:
                let emailAddress = emailTextField.text
                if emailAddress != "" {
                    GroupDetailUpdateCell.detail["Email"] = emailAddress
                    currentGroup.groupDetail.groupContactEmail = emailAddress!
                } else {
                    GroupDetailUpdateCell.detail["Email"] = nil
                }
                break
            case 5:
                let selectedRow = pickerView.selectedRow(inComponent: 0)
                let selectedCategory = categoryArray[selectedRow]
                if selectedCategory != "" {
                    categoryTextField.text = selectedCategory
                    GroupDetailUpdateCell.detail["Category"] = selectedCategory
                    currentGroup.groupDetail.groupCategory = selectedCategory
                } else {
                    categoryTextField.text = ""
                    GroupDetailUpdateCell.detail["Category"] = nil
                }
                break
            default:
                break
            }
            delegate.updateGroupDetailForFirebase(detail: GroupDetailUpdateCell.detail)
            delegate.updateGroupDetailForCurrentGroup(detail: currentGroup.groupDetail)
        }
    }
    
    @IBAction func timeSwitchChanged(_ sender: UISwitch) {
        if timeSwitch.isOn {
            timeTextField.isEnabled = true
            timeTextField.backgroundColor = UIColor.clear
        } else {
            timeTextField.isEnabled = false
            timeTextField.text = ""
            self.backgroundColor = UIColor.lightGray
        }
    }
    
}
