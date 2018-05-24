//
//  MySavedGroupVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class MySavedGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedSavedOption: String!
    var displayedGroups = [Group]()
    var selectedGroup: Group!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshGroups), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Groups", attributes: nil)
        
        self.view.isUserInteractionEnabled = false
        fetchBySelectedOption(option: selectedSavedOption)
        self.view.isUserInteractionEnabled = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = displayedGroups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCategoryCell") as! SavedCategoryCell
        cell.configureCell(group: group)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup = displayedGroups[indexPath.row]
        performSegue(withIdentifier: "GroupDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GroupDetailVC {
            destination.selectedGroup = selectedGroup
        }
    }
    
    @objc private func refreshGroups() {
        fetchBySelectedOption(option: selectedSavedOption)
    }

    func fetchBySelectedOption(option: String) {
        DispatchQueue.global().async {
            self.activityIndicator.startAnimating()
//            self.view.isUserInteractionEnabled = false
            let ref = DataService.ds.REF_USERS_CURRENT
            ref.child(option).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    var keyGroups = [String]()
                    var tempGroups = [Group]()
                    for snap in snapShot {
                        let key = snap.key
                        keyGroups.insert(key, at: 0)
                    }
                    DataService.ds.REF_GROUPS.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let groupsSnap = snapshot.children.allObjects as? [DataSnapshot] {
                            for snap in groupsSnap {
                                let group = Group()
                                let key = snap.key
                                if keyGroups.contains(key) {
                                    var comments = [Comment]()
                                    var groupComments = [Comment]()
                                    var photos = [Photo]()
                                    var groupPhotos = [Photo]()
                                    let groupData = snap.value as! Dictionary<String, Any>
                                    let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
                                    if let commentData = groupData["Comments"] as? Dictionary<String, Any> {
                                        for eachComment in commentData {
                                            let commentID = eachComment.key
                                            let commentDetail = eachComment.value as! Dictionary<String, Any>
                                            let comment = Comment(commentID: commentID, commentData: commentDetail)
                                            comments.append(comment)
                                        }
                                        groupComments = self.orderCommentsByID(comments: comments)
                                        group.groupComments = groupComments
                                    } else {
                                        
                                    }
                                    if let previousPhotoData = groupData["Previous Photos"] as? Dictionary<String, String> {
                                        for eachPhoto in previousPhotoData {
                                            let photoID = eachPhoto.key
                                            let photoURL = eachPhoto.value
                                            let photo = Photo(photoID: photoID, photoURL: photoURL)
                                            photos.append(photo)
                                        }
                                        groupPhotos = self.orderPhotosByID(photos: photos)
                                        group.groupPhotos = groupPhotos
                                    }
                                    
                                    group.groupID = key
                                    let details = GroupDetail(groupID: key, groupDetailData: groupDetailData)
                                    group.groupDetail = details
                                    tempGroups.append(group)
                                }
                            }
                            self.displayedGroups = self.orderGroupsByID(groups: tempGroups)
                            
                            for group in self.displayedGroups {
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
                                            print("Error: \(error!.localizedDescription)")
                                        } else {
                                            let image = UIImage(data: data!)
                                            if i == 0 {
                                                group.groupDetail.groupDisplayImage = image!
                                            } else {
                                                group.groupPhotos[i - 1].photo = image!
                                            }
                                            self.updateDisplayedGroups(groups: self.displayedGroups)
                                            self.tableView.reloadData()
                                        }
                                    })
                                }
                            }
                            
                            self.refreshControl.endRefreshing()
                            self.activityIndicator.stopAnimating()
//                            self.view.isUserInteractionEnabled = true
                            
//                            for group in self.displayedGroups {
//                                let groupID = group.groupID
//                                DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child("Display").getData(maxSize: 1024 * 1024, completion: { (data, error) in
//                                    if error != nil {
//                                        print("\(error?.localizedDescription)")
//                                    } else {
//                                        let image = UIImage(data: data!)
//                                        group.groupDetail.groupDisplayImage = image!
//                                    }
//                                })
//                            }
//                            
//                            for group in tempGroups {
//                                for photo in group.groupPhotos {
//                                    let url = photo.photoURL
//                                    Storage.storage().reference(forURL: url).getData(maxSize: 1024 * 1024, completion: { (data, error) in
//                                        if error != nil {
//                                            print("MySavedGroupVC: \(error?.localizedDescription)")
//                                        } else {
//                                            let image = UIImage(data: data!)
//                                            photo.photo = image!
//                                        }
//                                    })
//                                }
//                            }
                            
                        }
                    })
                }
            })
        }
    }
    
    func updateDisplayedGroups(groups: [Group]) {
        displayedGroups = groups
    }

    
    func getDisplayedGroups() -> [Group] {
        return displayedGroups
    }
    
    func setDisplayPhoto(image: UIImage) {
        
    }
}
