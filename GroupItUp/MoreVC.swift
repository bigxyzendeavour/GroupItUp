//
//  MoreVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import OpalImagePicker

class MoreVC: UIViewController, OpalImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("Grandon(SetupVC): the current key is \(Auth.auth().currentUser?.uid)")
            KeychainWrapper.standard.removeObject(forKey: CURRENT_USERNAME)
            performSegue(withIdentifier: "LoginVC", sender: nil)
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func picBtnPressed(_ sender: UIButton) {
        let ip = OpalImagePickerController()
        ip.imagePickerDelegate = self
        present(ip, animated: true, completion: nil)
    }
    

   }
