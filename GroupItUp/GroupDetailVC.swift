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
        if tableView.tag == 0 {
            return 3
        } else {
            return 1
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 1
        } else {
            return selectedGroup.groupComments.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            var hight = CGFloat()
            if indexPath.section == 0 {
                tableView.rowHeight = 560
                return tableView.rowHeight
            } else if indexPath.section == 1 {
                hight = CGFloat(integerLiteral: 125)
                return hight
            } else {
                hight = CGFloat(integerLiteral: 120)
                return hight
            }
        } else {
            return tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDetailCell") as! NearbyGroupDetailCell
                cell.configureCell(group: selectedGroup)
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupPreviousPhotoCell") as! NearbyGroupPreviousPhotoCell
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDetailCommentCell") as! NearbyGroupDetailCommentCell
                cell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailCommentCell") as! GroupDetailCommentCell
            let comment = selectedGroup.groupComments[indexPath.row]
            cell.configureCell(comment: comment)
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 0 {
            if section == 0 {
                return CGFloat.leastNormalMagnitude
            } else {
                return 17
            }
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 0 {
            if section == 1 {
                return "Previous Photos"
            } else if section == 2 {
                return "Comments"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}
