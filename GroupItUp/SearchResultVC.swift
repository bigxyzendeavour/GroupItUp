//
//  SearchResultVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-29.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class SearchResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [Group]()
    var selectedOption: String!
    var locationValue: Dictionary<String, String>!
    var selectedGroup: Group!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBySelectedOption(selectedOption: selectedOption)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.title = selectedOption!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
        cell.configureCell(group: group)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = searchResults[indexPath.row]
        selectedGroup = group
        performSegue(withIdentifier: "GroupDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GroupDetailVC {
            destination.selectedGroup = selectedGroup
        }
    }
    
    func fetchBySelectedOption(selectedOption: String) {
        let ref = DataService.ds.REF_GROUPS
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                var tempGroups = [Group]()
                for snap in snapShot {
                    let groupData = snap.value as! Dictionary<String, Any>
                    let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
                    let addressData = groupDetailData["Address"] as! Dictionary<String, String>
                    switch selectedOption {
                        case "Country":
                            let country = addressData["Country"]!
                            let location = ["Country": country]
                            if location == self.locationValue {
                                let group = self.addGroups(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Province":
                            let country = addressData["Country"]!
                            let province = addressData["Province"]!
                            let location = ["Country": country, "Province": province]
                            if location == self.locationValue {
                                let group = self.addGroups(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "City":
                            let country = addressData["Country"]!
                            let province = addressData["Province"]!
                            let city = addressData["City"]!
                            let location = ["Country": country, "Province": province, "City": city]
                            if location == self.locationValue {
                                let group = self.addGroups(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Sport":
                            let category = groupDetailData["Category"] as! String
                            if category == "Sport" {
                                let group = self.addGroups(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Entertainment":
                            let category = groupDetailData["Category"] as! String
                            if category == "Entertainment" {
                                let group = self.addGroups(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Travel":
                            let category = groupDetailData["Category"] as! String
                            if category == "Travel" {
                                let group = self.addGroups(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Food":
                            let category = groupDetailData["Category"] as! String
                            if category == "Food" {
                                let group = self.addGroups(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Study":
                            let category = groupDetailData["Category"] as! String
                            if category == "Study" {
                                let group = self.addGroups(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        default:
                            break
                    }
                }
                self.searchResults = self.orderGroupsByID(groups: tempGroups)
                if self.searchResults.count == 0 {
                    self.sendAlertWithoutHandler(alertTitle: "Currently Empty", alertMessage: "We can find a group, there isn't a group yet or please double check the location entered", actionTitle: ["Cancel"])
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func addGroups(snap: DataSnapshot) -> Group {
        let group = Group()
        var comments = [Comment]()
        var previousPhotos = [Photo]()
        let groupID = snap.key
        group.groupID = groupID
        let groupData = snap.value as! Dictionary<String, Any>
        let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
        let status = groupDetailData["Status"] as! String
        if status != "Cancelled" || status != "Completed" {
            if let commentData = groupData["Comments"] as? Dictionary<String, Any> {
                for eachComment in commentData {
                    let commentID = eachComment.key
                    let commentDetail = eachComment.value as! Dictionary<String, Any>
                    let comment = Comment(commentID: commentID, commentData: commentDetail)
                    comments.append(comment)
                }
                let newComments = self.orderCommentsByID(comments: comments)
                group.groupComments = newComments
            }
            if let previousPhotoData = groupData["Previous Photos"] as? Dictionary<String, String> {
                for eachPhoto in previousPhotoData {
                    let photoID = eachPhoto.key
                    let photoURL = eachPhoto.value
                    let photo = Photo(photoID: photoID, photoURL: photoURL)
                    previousPhotos.append(photo)
                }
                let newPhotos = self.orderPhotosByID(photos: previousPhotos)
                group.groupPhotos = newPhotos
            }
            let groupDetail = GroupDetail(groupID: groupID, groupDetailData: groupDetailData)
            group.groupDetail = groupDetail
        }
        return group

    }
    
    func orderCommentsByID(comments: [Comment]) -> [Comment]{
        var newComments = comments
        var newCommentID: Int!
        for i in 0..<comments.count {
            let commentID = comments[i].commentID
            let startIndex = commentID.startIndex
            if commentID[startIndex] == "0" {
                let id = commentID.substring(from: commentID.index(after: startIndex))
                newCommentID = Int(id)
            } else {
                newCommentID = Int(commentID)
            }
            newComments[newCommentID - 1] = comments[i]
        }
        return newComments
    }
    
    func orderPhotosByID(photos: [Photo]) -> [Photo] {
        var newPhotos = photos
        var newPhotoID: Int!
        for i in 0..<photos.count {
            let photoID = photos[i].photoID
            let startIndex = photoID.startIndex
            if photoID[startIndex] == "0" {
                let id = photoID.substring(from: photoID.index(after: startIndex))
                newPhotoID = Int(id)
            } else {
                newPhotoID = Int(photoID)
            }
            newPhotos[newPhotoID - 1] = photos[i]
        }
        return newPhotos
    }

    func orderGroupsByID(groups: [Group]) -> [Group] {
        var newGroups = groups
        for i in 0..<groups.count {
            newGroups[groups.count - 1 - i] = groups[i]
        }
        return newGroups
    }
}
