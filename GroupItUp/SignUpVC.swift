//
//  SignUpVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var termOfServiceAndPrivacyPolicyLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text, username != "" else {
            sendAlertWithoutHandler(alertTitle: "Missing Username", alertMessage: "Please enter your username", actionTitle: ["Cancel"])
            return
        }
        
        guard let email = emailTextField.text, email != "" else {
            sendAlertWithoutHandler(alertTitle: "Missing Email Address", alertMessage: "Please enter your email address", actionTitle: ["Cancel"])
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            sendAlertWithoutHandler(alertTitle: "Missing Password", alertMessage: "Please enter your password", actionTitle: ["Cancel"])
            return
        }
        
        if !passwordValidationPassed(password: password) {
            return
        }
    
        processSignUp(username: username, email: email, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
     
    }
    
    func initialize() {
        let allTextFields = [usernameTextField, emailTextField, passwordTextField]
        self.configureTextField(textFields: allTextFields as! [UITextField])
        signUpButton.heightCircleView()
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }

    func passwordValidationPassed(password: String) -> Bool {
        var passwordPass = true
        if password.characters.count < 8 {
            sendAlertWithoutHandler(alertTitle: "Password Error", alertMessage: "Password must be at least 8 characters. Please re-enter.", actionTitle: ["OK"])
            passwordPass = false
            return passwordPass
        }
        return passwordPass
    }
    
    func checkExistingUser(snapshot: [DataSnapshot], userName: String) -> Bool {
        var exist = false
        for snap in snapshot {
            if let userSnap = snap.value as? Dictionary<String, Any> {
                if let name = userSnap["Username"] as? String {
                    print("Grandon: username is \(name)")
                    if name == userName {
                        exist = true
                        print("Grandon: is it true? \(exist)")
                        break
                    }
                }
            }
        }
        return exist
    }
    
    func processSignUp(username: String, email: String, password: String) {
        DataService.ds.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            var usernameExisted: Bool
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                usernameExisted = self.checkExistingUser(snapshot: snapshot, userName: username)
                if usernameExisted == true {
                    self.sendAlertWithoutHandler(alertTitle: "Username Exists", alertMessage: "This username has been occupied, please use another.", actionTitle: ["Cancel"])
                    return
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: error.localizedDescription, actionTitle: ["OK"])
                        } else {
                            print("Grandon: successfully create a new user")
                            if let user = user {
                                var userData = [String: Any]()
                                userData = ["Username": username]
                                self.completeSignIn(id: user.uid, userData: userData)
                                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                    if error == nil {
                                        print("Grandon: sent email verification")
                                    } else {
                                        self.sendAlertWithoutHandler(alertTitle: "Not able to send email verification", alertMessage: (error?.localizedDescription)!, actionTitle: ["OK"])
                                    }
                                })
                            }
                        }
                    })
                }
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, Any>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        performSegue(withIdentifier: "NearbyVC", sender: nil)
    }
}
