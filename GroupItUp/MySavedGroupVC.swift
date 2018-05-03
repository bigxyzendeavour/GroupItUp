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
    
    var selectedSavedOption: String!
    var displayedGroups: [Group]!
    var selectedGroup: Group!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBySelectedOption(option: selectedSavedOption)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
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

    func fetchBySelectedOption(option: String) {
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
                            let key = snap.key
                            if keyGroups.contains(key) {
                                var comments = [Comment]()
                                var groupComments = [Comment]()
                                var photos = [Photo]()
                                var groupPhotos = [Photo]()
                                let groupData = snap.value as! Dictionary<String, Any>
                                let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
                                let groupDetail = GroupDetail(groupID: key, groupDetailData: groupDetailData)
                                if let commentData = groupData["Comments"] as? Dictionary<String, Any> {
                                    for eachComment in commentData {
                                        let commentID = eachComment.key
                                        let commentDetail = eachComment.value as! Dictionary<String, Any>
                                        let comment = Comment(commentID: commentID, commentData: commentDetail)
                                        comments.append(comment)
                                    }
                                    let newComments = self.orderCommentsByID(comments: comments)
                                    groupComments = newComments
                                }
                                if let previousPhotoData = groupData["Previous Photos"] as? Dictionary<String, String> {
                                    for eachPhoto in previousPhotoData {
                                        let photoID = eachPhoto.key
                                        let photoURL = eachPhoto.value
                                        let photo = Photo(photoID: photoID, photoURL: photoURL)
                                        photos.append(photo)
                                    }
                                    let newPhotos = self.orderPhotosByID(photos: photos)
                                    groupPhotos = newPhotos
                                }
                                let group = Group(groupID: key, groupComments: groupComments, groupDetails: groupDetail, groupPhotos: groupPhotos)
                                tempGroups.append(group)
                            }
                        }
                        self.displayedGroups = self.orderGroupsByID(groups: tempGroups)
                        self.tableView.reloadData()
                    }
                })
            }
        })

    }
    
}
