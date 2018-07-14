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

class MeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, EditProfileVCDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDisplayImageView: UIImageView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var fansNumberLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var previousHostedGroupDisplayImage: UIImageView!
    
    let savedCategory = ["Likes", "Follow", "Attending", "Joined", "Hosting", "Hosted"]
    var selectedSavedOption: String!
    var fromNewGroupCreationCompleteVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        
        userDisplayImageView.heightCircleView()
        
        let layout = userCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (self.view.frame.width - 20)/3, height: (self.view.frame.width - 20)/3)
        
        initialize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fromNewGroupCreationCompleteVC == true {
            self.navigationItem.hidesBackButton = true
            self.tabBarController?.tabBar.isHidden = false
            fromNewGroupCreationCompleteVC = false
        }
        
    }
    
    func initialize() {
        usernameLabel.text = currentUser.username
        userDisplayImageView.image = currentUser.userDisplayImage
        
        DataService.ds.REF_USERS_CURRENT.child("Hosted").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                let snapCount = snapShot.count
                if snapCount > 0 {
                    let previousHostedGroupID = snapShot[snapCount - 1].key
                    DataService.ds.REF_GROUPS.child(previousHostedGroupID).child("Group Detail").child("Group Display Photo URL").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let displayURL = snapshot.value as? String {
                            Storage.storage().reference(forURL: displayURL).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                                if error != nil {
                                    self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error?.localizedDescription)", actionTitle: ["Cancel"])
                                    return
                                } else {
                                    let image = UIImage(data: data!)
                                    self.previousHostedGroupDisplayImage.image = image!
                                }
                            })
                        }
                    })
                }
                
            }
            
        })
        
        DataService.ds.REF_USERS_CURRENT.child("Fans").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapCount = snapshot.childrenCount
            self.fansNumberLabel.text = "\(snapCount)"
        })
        
        /*
        DataService.ds.REF_USERS_CURRENT.child("Hosted").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                let snapCount = snapShot.count
                let previousGroupID = snapShot[snapCount - 1].key
                DataService.ds.REF_GROUPS.child(previousGroupID).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let groupSnapShot = snapshot.value as? Dictionary<String, Any> {
                        let group = Group()
                        group.groupID = previousGroupID
                        group.groupDetail.groupID = previousGroupID
                        var comments = [Comment]()
                        var photos = [Photo]()
                        let groupDetailData = groupSnapShot["Group Detail"] as! Dictionary<String, Any>
                        if let commentData = groupSnapShot["Comments"] as? Dictionary<String, Any> {
                            for eachComment in commentData {
                                let commentID = eachComment.key
                                let commentDetail = eachComment.value as! Dictionary<String, Any>
                                let comment = Comment(commentID: commentID, commentData: commentDetail)
                                comments.append(comment)
                            }
                            group.groupComments = self.orderCommentsByID(comments: comments)
                        }
                        
                        if let previousPhotoData = groupSnapShot["Previous Photos"] as? Dictionary<String, String> {
                            for eachPhoto in previousPhotoData {
                                let photoID = eachPhoto.key
                                let photoURL = eachPhoto.value
                                let photo = Photo(photoID: photoID, photoURL: photoURL)
                                photos.append(photo)
                            }
                            group.groupPhotos = self.orderPhotosByID(photos: photos)
                        }
                        
                        let details = GroupDetail(groupID: previousGroupID, groupDetailData: groupDetailData)
                        group.groupDetail = details
                        
                        var photoURLs = [String]()
                        let displayURL = group.groupDetail.groupDisplayImageURL
                        photoURLs.append(displayURL)
                        for photo in group.groupPhotos {
                            let url = photo.photoURL
                            photoURLs.append(url)
                        }
                        
                        for i in 0..<photoURLs.count {
                            let url = photoURLs[i]
                            Storage.storage().reference(forURL: url).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                                if error != nil {
                                    self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error?.localizedDescription)", actionTitle: ["Cancel"])
                                    return
                                } else {
                                    let image = UIImage(data: data!)
                                    if i == 0 {
                                        group.groupDetail.groupDisplayImage = image!
                                        self.previousHostedGroupDisplayImage.image = image!
                                    } else {
                                        group.groupPhotos[i - 1].photo = image!
                                    }
                                }
                            })
                        }
                    }
                })
            }
        })
 */
        
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
        if let destination = segue.destination as? EditProfileVC {
            destination.delegate = self
            let displayImage = userDisplayImageView.image!
            destination.displayImage = displayImage
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        newGroup = Group()
        newGroupForFirebase = [String: Any]()
        performSegue(withIdentifier: "NewGroupCreationVC", sender: nil)
    }
    
    @IBAction func editProfileBtnPressed(_ sender: UIButton) {
        
        
        performSegue(withIdentifier: "EditProfileVC", sender: nil)
    }
    
    func updateProfileDisplayImageFromEditProfileVC(image: UIImage) {
        userDisplayImageView.image = image
    }
    
    func updateUsernameFromEditProfileVC(newName: String) {
        usernameLabel.text = newName
    }
}
