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

    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!

    
    var delegate: NewGroupAddressEntryCellDelegate?
    var countries : [String]!
    var addressFields = ["Street", "City", "Province", "Postal Code", "Country"]
    var countryPicker: UIPickerView!
    static var address = Address()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        streetTextField.delegate = self
        cityTextField.delegate = self
        provinceTextField.delegate = self
        postalTextField.delegate = self
        countryTextField.delegate = self
    }
//
//    func configureCell(address: Address) {
//        if address.street != "" {
//            streetTextField.text = address.street
//        }
//        if address.city != ""{
//            cityTextField.text = address.city
//        }
//        if address.province != "" {
//            provinceTextField.text = address.province
//        }
//        if address.postal != "" {
//            postalTextField.text = address.postal
//        }
//        if address.country != "" {
//            countryTextField.text = address.country
//        }
//    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            let tag = textField.tag
            switch tag {
            case 0:
                if let street = streetTextField.text, street != "" {
                    NewGroupAddressEntryCell.address.street = street
                } else {
                    NewGroupAddressEntryCell.address.street = ""
                }
                break
            case 1:
                if let city = cityTextField.text, city != "" {
                    NewGroupAddressEntryCell.address.city = city
                } else {
                    NewGroupAddressEntryCell.address.city = ""
                }
                break
            case 2:
                if let province = provinceTextField.text, province != "" {
                    NewGroupAddressEntryCell.address.province = province
                } else {
                    NewGroupAddressEntryCell.address.province = ""
                }
                break
            case 3:
                if let postal = postalTextField.text, postal != "" {
                    NewGroupAddressEntryCell.address.postal = postal
                } else {
                    NewGroupAddressEntryCell.address.postal = ""
                }
                break
            case 4:
                let selectedRow = countryPicker.selectedRow(inComponent: 0)
                let selectedCountry = countries[selectedRow]
                if selectedCountry != "" {
                    countryTextField.text = selectedCountry
                    NewGroupAddressEntryCell.address.country = selectedCountry
                } else {
                    countryTextField.text = ""
                    NewGroupAddressEntryCell.address.country = ""
                }
                break
            default:
                break
            }
            
            if NewGroupAddressEntryCell.address.street != "" &&
                NewGroupAddressEntryCell.address.city != "" &&
                NewGroupAddressEntryCell.address.province != "" &&
                NewGroupAddressEntryCell.address.postal != "" &&
                NewGroupAddressEntryCell.address.country != "" {
                delegate.setAddress(address: NewGroupAddressEntryCell.address)
            } else {
                delegate.setAddress(address: Address())
            }
        }
    }
    
}
