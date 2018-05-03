//
//  LocationSearchVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-29.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class LocationSearchVC: UIViewController {

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var provinceSpliterView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var citySpliterView: UIView!
    
    var selectedOption: String!
    var locationValue: Dictionary<String, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    func initialize() {
        let allTextFields = [countryTextField, provinceTextField, cityTextField]
        configureTextFieldWithoutImage(textFields: allTextFields as! [UITextField])
        
        switch selectedOption {
        case "Province":
            provinceTextField.isHidden = false
            provinceSpliterView.isHidden = false
            break
        case "City":
            provinceTextField.isHidden = false
            provinceSpliterView.isHidden = false
            cityTextField.isHidden = false
            citySpliterView.isHidden = false
            break
        default:
            break
        }
    }

    @IBAction func searchBtnPressed(_ sender: UIButton) {
        if selectedOption == "Country" {
            guard let country = countryTextField.text, country != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the country you are interested in.", actionTitle: ["Cancel"])
                return
            }
            locationValue = ["Country": country]
        } else if selectedOption == "Province" {
            guard let country = countryTextField.text, country != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the country you are interested in.", actionTitle: ["Cancel"])
                return
            }
            
            guard let province = provinceTextField.text, province != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the province you are interested in.", actionTitle: ["Cancel"])
                return
            }
            locationValue = ["Country": country, "Province": province]
        } else {
            guard let country = countryTextField.text, country != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the country you are interested in.", actionTitle: ["Cancel"])
                return
            }
            
            guard let province = provinceTextField.text, province != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the province you are interested in.", actionTitle: ["Cancel"])
                return
            }
            
            guard let city = cityTextField.text, city != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the city you are interested in.", actionTitle: ["Cancel"])
                return
            }
            locationValue = ["Country": country, "Province": province, "City": city]
        }
        performSegue(withIdentifier: "SearchResultVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchResultVC {
            destination.selectedOption = selectedOption
            destination.locationValue = locationValue
        }
    }
}
