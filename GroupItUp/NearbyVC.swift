//
//  NearbyVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class NearbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nearbyGroups = [Group]()
    var selectedGroup: Group!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationServices.shared.getAdress { address, error in
            if let a = address, let city = a["City"] as? String {
                self.fetchNearbyGroups(city: city)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        LocationServices.shared.getAdress { address, error in
            if let a = address, let city = a["City"] as? String {
                self.fetchNearbyGroups(city: city)
            }
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupCell") as? NearbyGroupCell {
            let group = nearbyGroups[indexPath.row]
            cell.configureCell(group: group)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup = nearbyGroups[indexPath.row]
        performSegue(withIdentifier: "GroupDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GroupDetailVC {
            destination.selectedGroup = selectedGroup
        }
    }
    
    func fetchNearbyGroups(city: String) {
        nearbyGroups.removeAll()
        var tempGroups = [Group]()
        DataService.ds.REF_BASE.child("Groups").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    let group = Group()
                    var comments = group.groupComments
                    var previousPhotos = group.groupPhotos
                    let groupID = snap.key
                    group.groupID = groupID
                    let groupData = snap.value as! Dictionary<String, Any>
                    let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
                    let addressData = groupDetailData["Address"] as! Dictionary<String, String>
                    let groupCity = addressData["City"]
//                    let status = groupDetailData["Status"] as! String
                    if groupCity == city {
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
                        tempGroups.append(group)
                    }
                }
                self.nearbyGroups = self.orderGroupsByID(groups: tempGroups)
                self.tableView.reloadData()
            }
        })
    }
    

}
