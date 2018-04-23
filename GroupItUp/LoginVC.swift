//
//  LoginVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-11.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        navigationController?.navigationBar.barTintColor = UIColor.lightGray
//        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        if Auth.auth().currentUser != nil {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                self.performSegue(withIdentifier: "NearbyVC", sender: nil)
            })
        }
        
    }

    func initialize() {
        
        let allTextFields = [UITextField(), emailTextField, passwordTextField]
        configureTextField(textFields: allTextFields as! [UITextField])
        loginButton.heightCircleView()
    }

    @IBAction func logInBtnPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    print("Grandon: unable to sign in user - \(error)")
                    if error.debugDescription.contains("The password is invalid") {
                        self.sendAlertWithoutHandler(alertTitle: "Login Fail", alertMessage: "Forget your password? Select 'Forget Password?' to reset your password.", actionTitle: ["OK"])
                    } else if error.debugDescription.contains("There is no user record") {
                        self.sendAlertWithoutHandler(alertTitle: "Login Fail", alertMessage: "The email address entered does not exist. Please enter your email address again.", actionTitle: ["OK"])
                    } else {
                        self.sendAlertWithoutHandler(alertTitle: "Login Fail", alertMessage: "New to GroupItUp? Sign up to enjoy the jurney.", actionTitle: ["OK"])
                    }
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
//        KeychainWrapper.standard.set(id, forKey: KEY_UID)
//        DataService.ds.uid = KeychainWrapper.standard.string(forKey: KEY_UID)
//        activityIndicator.stopAnimating()
        //        loadingView.hide()
        performSegue(withIdentifier: "NearbyVC", sender: nil)
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        let email = emailTextField.text
        if email != "" {
            Auth.auth().sendPasswordReset(withEmail: email!, completion: { (error) in
                if error.debugDescription.contains("There is no user") {
                    self.sendAlertWithoutHandler(alertTitle: "Forget Password", alertMessage: "There is no user record corresponding to the email address. Please confirm your email address.", actionTitle: ["Cancel"])
                } else {
                    self.sendAlertWithoutHandler(alertTitle: "Reset Email", alertMessage: "An email has been sent to the email address to reset your password.", actionTitle: ["OK"])
                }
            })
        } else {
            self.sendAlertWithoutHandler(alertTitle: "Forget Password", alertMessage: "Missing email address. Please enter your email address.", actionTitle: ["OK"])
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "SingUpVC", sender: nil)
    }
    
}

