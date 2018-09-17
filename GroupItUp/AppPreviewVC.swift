//
//  AppPreviewVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-09-16.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class AppPreviewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    let previewOne: [UIImage: String] = [UIImage(named: "preview1")!: "Find someone with the same interest around you and do it together with new friends"]
    let previewTwo: [UIImage: String] = [UIImage(named: "preview2")!: "Create group events or join group events to make new friends"]

    override func viewDidLoad() {
        super.viewDidLoad()
 
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if Auth.auth().currentUser != nil {
            currentUser.username = (Auth.auth().currentUser?.displayName)!
            currentUser.userDisplayImageURL = (Auth.auth().currentUser?.photoURL?.absoluteString)!
            currentUser.userID = (Auth.auth().currentUser?.uid)!
            Storage.storage().reference(forURL: currentUser.userDisplayImageURL).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("LoginVC: initialize() - \(error!.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    currentUser.userDisplayImage = image!
                }
                
            })
            DataService.ds.REF_USERS_CURRENT.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.value as? Dictionary<String, Any> {
                    if let region = snapShot["Region"] as? String {
                        currentUser.region = region
                    }
                    if let gender = snapShot["Gender"] as? String {
                        currentUser.gender = gender
                    }
                }
            })
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                self.performSegue(withIdentifier: "NearbyVC", sender: nil)
            })
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppPreviewCell", for: indexPath)
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / self.view.frame.width)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        if pageControl.currentPage == 2 {
            startButton.isHidden = false
        }
        
    }
    
    @IBAction func startBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "NearbyVC", sender: nil)
    }
}
