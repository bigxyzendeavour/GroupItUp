//
//  Global.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-11.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

var username: String!
let CURRENT_USERNAME = "current username"

extension UIView {
    func widthCircleView() {
        layer.cornerRadius = self.frame.width / 2.0
        clipsToBounds = true
    }
    
    func heightCircleView() {
        layer.cornerRadius = self.frame.height / 2.0
        clipsToBounds = true
    }
}

extension UIViewController {
    func sendAlertWithoutHandler(alertTitle: String, alertMessage: String, actionTitle: [String]) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        for action in actionTitle {
            alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
//    
//    func setNoTextOnBackBarButton() {
//        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
//        self.navigationItem.setLeftBarButton(backButton, animated: false)
//    }
    
    func configureTextField(textFields: [UITextField]) {
        for i in 0..<textFields.count {
            textFields[i].layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
            assignImageToTextField(imageName: i, textField: textFields[i])
        }
    }
    
//    func configureTextFieldWithoutImage(textFields: [UITextField]) {
//        for i in 0..<textFields.count {
//            textFields[i].layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
//        }
//    }
    
    func assignImageToTextField(imageName: Int, textField: UITextField) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let name = UIImage().getImageName(name: imageName)
        if name != "" {
                imageView.image = UIImage(named: name)
                textField.leftView = imageView
                textField.leftViewMode = .always
        }
//        imageView.image = UIImage(named: UIImage().getImageName(name: imageName))
//        textField.leftView = imageView
//        textField.leftViewMode = .always
    }
    
    func getUnitIndex(compareUnit: String, unitsArray: [String]) -> Int {
        var index = 0
        for i in 0...unitsArray.count - 1 {
            if compareUnit == unitsArray[i] {
                index = i
            }
        }
        return index
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

extension UIImage {
    static let IMAGE_EMAIL = 0
    static let IMAGE_PASSWORD = 1
    
    public func getImageName(name: Int) -> String {
        var imageName: String!
        switch name {
        case 0:
            imageName = "profile"
            break
        case 1:
            imageName = "email"
            break
        case 2:
            imageName = "password"
            break
        default:
            imageName = ""
        }
        return imageName
    }
}
