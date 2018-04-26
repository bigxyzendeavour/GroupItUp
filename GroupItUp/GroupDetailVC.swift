//
//  GroupDetailVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-15.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class GroupDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedGroup: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedGroup.groupPhotos.count > 0 {
            return selectedGroup.groupPhotos.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = selectedGroup.groupPhotos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyGroupDetailPreviousMeetPhotoCollectionCell", for: indexPath) as! NearbyGroupDetailPreviousMeetPhotoCollectionCell
        cell.configureCell(photo: photo)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return selectedGroup.groupComments.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDisplayPhotoCell") as! NearbyGroupDisplayPhotoCell
            cell.configureCell(group: selectedGroup)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDescriptionCell") as! NearbyGroupDescriptionCell
            cell.setSelectedGroup(group: selectedGroup)
            cell.configureCell(group: selectedGroup)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDetailCell") as! NearbyGroupDetailCell
            cell.configureCell(group: selectedGroup)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupPreviousPhotoCell") as! NearbyGroupPreviousPhotoCell
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDetailCommentCell") as! NearbyGroupDetailCommentCell
            let comment = selectedGroup.groupComments[indexPath.row]
            cell.configureCell(comment: comment)
            return cell
        } else {
            let cell = UITableViewCell() as! NearbyGroupCommentEntryCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section <= 2 {
            return CGFloat.leastNormalMagnitude
        } else if section <= 4 {
            return 25
        } else {
            return 0.0000000001
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            return "Previous Photos"
        } else if section == 4 {
            return "Comments"
        } else {
            return ""
        }
    }
    
    //Scroll to the end, then display the comment entry
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.section == 4 {
//            if indexPath.row + 1 == selectedGroup.groupComments.count {
//                commentEntryView.isHidden = false
//            } else {
//                commentEntryView.isHidden = true
//            }
//        } else {
//            commentEntryView.isHidden = true
//        }
//    }
}
