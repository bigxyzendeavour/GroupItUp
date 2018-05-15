//
//  MeVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class MeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDisplayImageView: UIImageView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    let savedCategory = ["Like", "Follow", "Attending", "Joined", "Hosted", "Hosting"]
    var selectedSavedOption: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        
        userDisplayImageView.heightCircleView()
        
        let layout = userCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (self.view.frame.width - 20)/2, height: (self.userCollectionView.frame.height - 10)/3)
    }

    func initialize() {
        if KeychainWrapper.standard.string(forKey: CURRENT_USER_PROFILE_IMAGE_URL) != nil {
            let url = KeychainWrapper.standard.string(forKey: CURRENT_USER_PROFILE_IMAGE_URL)
            Storage.storage().reference(forURL: url!).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error?.localizedDescription)", actionTitle: ["Cancel"])
                } else {
                    let image = UIImage(data: data!)
                    self.userDisplayImageView.image = image
                }
            })
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = savedCategory[indexPath.item]
        let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: "UserSavedGroupCollectionCell", for: indexPath) as! UserSavedGroupCollectionCell
//        cell.frame.size.width = (userCollectionView.frame.width / 2) * 2/3
//        cell.frame.size.height = cell.frame.size.width
//        cell.savedCategoryImageView.frame.size.height = cell.frame.size.height * 2/3
        cell.configureCell(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSavedOption = savedCategory[indexPath.item]
        performSegue(withIdentifier: "MySavedGroupVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MySavedGroupVC {
            destination.selectedSavedOption = selectedSavedOption
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "NewGroupCreationVC", sender: nil)
    }
    
}
