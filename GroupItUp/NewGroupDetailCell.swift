//
//  NewGroupDetailCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-06.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol NewGroupDetailCellDelegate {
    func setGroupDetail(detail: Dictionary<String, Any>)
    
}

class NewGroupDetailCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var groupDetailTextField: UITextField!

    var delegate: NewGroupDetailCellDelegate?
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    let categoryArray = ["Sport", "Entertainment", "Travel", "Food", "Study"]
    static var detail = [String: Any]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupDetailTextField.delegate = self
        
    }
    
    func configureCell(detail: String) {
        groupDetailTextField.placeholder = detail
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            let tag = groupDetailTextField.tag
            switch tag {
            case 0:
                if let max = Int(groupDetailTextField.text!) {
                    NewGroupDetailCell.detail["Max Attending Members"] = max
                } else {
                    NewGroupDetailCell.detail["Max Attending Members"] = nil
                }
                break
            case 1:
                let selectedDate = datePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let date = dateFormatter.string(from: selectedDate as Date)
                groupDetailTextField.text = date
                NewGroupDetailCell.detail["Time"] = date
                break
            case 2:
                let contactPerson = groupDetailTextField.text
                if contactPerson != "" {
                    NewGroupDetailCell.detail["Contact"] = contactPerson
                } else {
                    NewGroupDetailCell.detail["Contact"] = nil
                }
                break
            case 3:
                if let phoneNumber = Int(groupDetailTextField.text!) {
                    if phoneNumber != Int() {
                        NewGroupDetailCell.detail["Phone"] = phoneNumber
                    } else {
                        NewGroupDetailCell.detail["Phone"] = nil
                    }
                }
                break
            case 4:
                let emailAddress = groupDetailTextField.text
                if emailAddress != "" {
                    NewGroupDetailCell.detail["Email"] = emailAddress
                } else {
                    NewGroupDetailCell.detail["Email"] = nil
                }
                break
            case 5:
                
                let locationAddress = groupDetailTextField.text
                if locationAddress != "" {
                    NewGroupDetailCell.detail["Address"] = locationAddress
                } else {
                    NewGroupDetailCell.detail["Address"] = nil
                }
                break
            case 6:
                let selectedRow = pickerView.selectedRow(inComponent: 0)
                let selectedCategory = categoryArray[selectedRow]
                if selectedCategory != "" {
                    groupDetailTextField.text = selectedCategory
                    NewGroupDetailCell.detail["Category"] = selectedCategory
                } else {
                    NewGroupDetailCell.detail["Category"] = nil
                }
            default:
                break
            }
            delegate.setGroupDetail(detail: NewGroupDetailCell.detail)
        }
    }
}
