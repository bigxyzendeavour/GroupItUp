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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchResults = [Group]()
    var selectedOption: String!
    var locationValue: Dictionary<String, String>!
    var selectedGroup: Group!
    private var refreshControl = UIRefreshControl()
    var isRefreshing: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBySelectedOption(selectedOption: selectedOption)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.title = selectedOption!
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshGroups), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing nearby groups", attributes: nil)
        
        self.title = selectedOption
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.endRefrenshing()
    }
    
    @objc private func refreshGroups() {
        fetchBySelectedOption(selectedOption: selectedOption)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GroupDetailVC {
            destination.selectedGroup = selectedGroup
        }
    }
    
    func fetchBySelectedOption(selectedOption: String) {
        searchResults.removeAll()
        var tempGroups = [Group]()
        self.startRefreshing()
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block:  { (timer) in
            if self.isRefreshing == true {
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Time out, please refresh", actionTitle: ["Cancel"])
            }
        })
        let ref = DataService.ds.REF_GROUPS
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    let groupData = snap.value as! Dictionary<String, Any>
                    let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
                    let addressData = groupDetailData["Address"] as! Dictionary<String, String>
                    switch selectedOption {
                        case "Country":
                            let country = addressData["Country"]!
                            let location = ["Country": country]
                            if location == self.locationValue {
                                let group = self.addGroup(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Province":
                            let country = addressData["Country"]!
                            let province = addressData["Province"]!.lowercased()
                            let location = ["Country": country, "Province": province]
                            if location == self.locationValue {
                                let group = self.addGroup(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "City":
                            let country = addressData["Country"]!
                            let province = addressData["Province"]!.lowercased()
                            let city = addressData["City"]!.lowercased()
                            let location = ["Country": country, "Province": province, "City": city]
                            if location == self.locationValue {
                                let group = self.addGroup(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Sport":
                            let category = groupDetailData["Category"] as! String
                            if category == "Sport" {
                                let group = self.addGroup(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Entertainment":
                            let category = groupDetailData["Category"] as! String
                            if category == "Entertainment" {
                                let group = self.addGroup(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Travel":
                            let category = groupDetailData["Category"] as! String
                            if category == "Travel" {
                                let group = self.addGroup(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Food":
                            let category = groupDetailData["Category"] as! String
                            if category == "Food" {
                                let group = self.addGroup(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        case "Study":
                            let category = groupDetailData["Category"] as! String
                            if category == "Study" {
                                let group = self.addGroup(snap: snap)
                                tempGroups.append(group)
                            }
                            break
                        default:
                            break
                    }
                }
                self.searchResults = self.orderGroupsByID(groups: tempGroups)
                self.processPhotos(groups: self.searchResults)
                if self.searchResults.count == 0 {
                    self.sendAlertWithoutHandler(alertTitle: "Currently Empty", alertMessage: "We can't find a group, there isn't a group yet or please double check the location entered", actionTitle: ["Cancel"])
                    self.endRefrenshing()
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func addGroup(snap: DataSnapshot) -> Group {
        let group = Group()
        var comments = [Comment]()
        var previousPhotos = [Photo]()
        let groupID = snap.key
        group.groupID = groupID
        let groupData = snap.value as! Dictionary<String, Any>
        let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
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
        
        return group

    }
    
    func processPhotos(groups: [Group]) {
        for group in groups {
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
                        self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error!.localizedDescription)", actionTitle: ["Cancel"])
                        self.endRefrenshing()
                        return
                    } else {
                        let image = UIImage(data: data!)
                        if i == 0 {
                            group.groupDetail.groupDisplayImage = image!
                        } else {
                            group.groupPhotos[i - 1].photo = image!
                        }
                        self.tableView.reloadData()
                        self.endRefrenshing()
                    }
                })
            }
        }
    }
    
    func startRefreshing() {
        self.isRefreshing = true
        self.activityIndicator.startAnimating()
        self.refreshControl.beginRefreshing()
        self.tableView.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
    }
    
    func endRefrenshing() {
        self.isRefreshing = false
        self.activityIndicator.stopAnimating()
        self.refreshControl.endRefreshing()
        self.tableView.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
    }
    
}
