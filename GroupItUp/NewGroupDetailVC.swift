//
//  NewGroupDetailVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NewGroupDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var maxAttendentsTextField: UITextField!
    @IBOutlet weak var meetUpTimeTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    let categoryArray = ["", "Sport", "Entertainment", "Travel", "Food", "Study", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxAttendentsTextField.keyboardType = .numberPad
        emailTextField.keyboardType = .emailAddress
        phoneTextField.keyboardType = .phonePad
        
        datePicker = UIDatePicker()
        meetUpTimeTextField.inputView = datePicker
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
    }
}
