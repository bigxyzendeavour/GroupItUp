//
//  GroupAddressUpdateCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-24.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol GroupAddressUpdateCellDelegate {
    func updateGroupAddressForFirebase(address: Dictionary<String, String>)
    func updateGroupAddressForCurrentGroup(address: Address)
}

class GroupAddressUpdateCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    var delegate: GroupAddressUpdateCellDelegate?
    var countries : [String]!
    var addressFields = ["Street", "City", "Province", "Postal Code", "Country"]
    var countryPicker: UIPickerView!
    static var address = [String: String]()
    var currentGroup: Group!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        streetTextField.delegate = self
        cityTextField.delegate = self
        provinceTextField.delegate = self
        postalTextField.delegate = self
        countryTextField.delegate = self
    }
    
    func configureCell(group: Group) {
        streetTextField.text = group.groupDetail.groupMeetUpAddress.street
        cityTextField.text = group.groupDetail.groupMeetUpAddress.city
        provinceTextField.text = group.groupDetail.groupMeetUpAddress.province
        postalTextField.text = group.groupDetail.groupMeetUpAddress.postal
        countryTextField.text = group.groupDetail.groupMeetUpAddress.country
    }
    
    func setCurrentGroup(group: Group) {
        currentGroup = group
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            let tag = textField.tag
            switch tag {
            case 0:
                if let street = streetTextField.text, street != "" {
                    GroupAddressUpdateCell.address["Street"] = street
                    currentGroup.groupDetail.groupMeetUpAddress.street = street
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            case 1:
                if let city = cityTextField.text, city != "" {
                    GroupAddressUpdateCell.address["City"] = city
                    currentGroup.groupDetail.groupMeetUpAddress.city = city
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            case 2:
                if let province = provinceTextField.text, province != "" {
                    GroupAddressUpdateCell.address["Province"] = province
                    currentGroup.groupDetail.groupMeetUpAddress.province = province
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            case 3:
                if let postal = postalTextField.text, postal != "" {
                    GroupAddressUpdateCell.address["Postal"] = postal
                    currentGroup.groupDetail.groupMeetUpAddress.postal = postal
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            case 4:
                let selectedRow = countryPicker.selectedRow(inComponent: 0)
                let selectedCountry = countries[selectedRow]
                if selectedCountry != "" {
                    countryTextField.text = selectedCountry
                    GroupAddressUpdateCell.address["Country"] = selectedCountry
                    currentGroup.groupDetail.groupMeetUpAddress.country = selectedCountry
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            default:
                break
            }
            delegate.updateGroupAddressForFirebase(address: GroupAddressUpdateCell.address)
            delegate.updateGroupAddressForCurrentGroup(address: currentGroup.groupDetail.groupMeetUpAddress)
        }
    }
}
