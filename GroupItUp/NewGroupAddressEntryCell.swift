//
//  NewGroupAddressEntryCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-14.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol NewGroupAddressEntryCellDelegate {
    func setAddress(address: Address)
}

class NewGroupAddressEntryCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var addressComponentTextField: UITextField!
    
    var delegate: NewGroupAddressEntryCellDelegate?
    var countries: [String]!
    var addressFields = ["Street", "City", "Province", "Postal Code", "Country"]
    var countryPicker: UIPickerView!
    static var address = Address()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addressComponentTextField.delegate = self
    }

    func configureCell(placeHolderValue: String) {
        addressComponentTextField.placeholder = placeHolderValue
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            let tag = addressComponentTextField.tag
            switch tag {
            case 0:
                if let street = addressComponentTextField.text, street != "" {
                    NewGroupAddressEntryCell.address.street = street
                } else {
                    NewGroupAddressEntryCell.address.street = ""
                }
                break
            case 1:
                if let city = addressComponentTextField.text, city != "" {
                    NewGroupAddressEntryCell.address.city = city
                } else {
                    NewGroupAddressEntryCell.address.city = ""
                }
                break
            case 2:
                if let province = addressComponentTextField.text, province != "" {
                    NewGroupAddressEntryCell.address.province = province
                } else {
                    NewGroupAddressEntryCell.address.province = ""
                }
                break
            case 3:
                if let postal = addressComponentTextField.text, postal != "" {
                    NewGroupAddressEntryCell.address.postal = postal
                } else {
                    NewGroupAddressEntryCell.address.postal = ""
                }
                break
            case 4:
                let selectedRow = countryPicker.selectedRow(inComponent: 0)
                let selectedCountry = countries[selectedRow]
                addressComponentTextField.text = selectedCountry
                NewGroupAddressEntryCell.address.country = selectedCountry
                break
            default:
                break
            }
            
            let street = NewGroupAddressEntryCell.address.street
            let city = NewGroupAddressEntryCell.address.city
            let province = NewGroupAddressEntryCell.address.province
            let postal = NewGroupAddressEntryCell.address.postal
            let country = NewGroupAddressEntryCell.address.country
            if street != "" && city != "" && province != "" && postal != "" && country != "" {
                delegate.setAddress(address: NewGroupAddressEntryCell.address)
            }
        }
    }
    
}
