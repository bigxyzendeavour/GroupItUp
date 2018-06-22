//
//  NewGroupAddressEntryVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NewGroupAddressEntryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalTextField: UITextField!
    
    var countryPicker: UIPickerView!
    var provincePicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        provincePicker = UIPickerView()
        provincePicker.delegate = self
        provincePicker.dataSource = self
        
        countryTextField.inputView = countryPicker
        provinceTextField.inputView = provincePicker
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(countryPicker) {
            return countries.count
        } else {
            return provinces.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(countryPicker) {
            return countries[row]
        } else {
            return provinces[row]
        }
    }
}
