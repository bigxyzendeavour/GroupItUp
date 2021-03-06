//
//  NearbyGroupDetailCommentCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-17.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NearbyGroupDetailCommentCell: UITableViewCell {

    @IBOutlet weak var userDisplayImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    func configureCell(comment: Comment, group: Group) {
        userDisplayImage.image = comment.userDisplayImage
        userCommentLabel.text = comment.comment
        
        if comment.userID == group.groupDetail.groupHost {
            DataService.ds.REF_USERS.child(group.groupDetail.groupHost).child("Username").observeSingleEvent(of: .value, with: { (snapshot) in
                if let hostName = snapshot.value as? String {
                    self.usernameLabel.text = "\(hostName)(Group host)"
                }
            })
        } else {
            DataService.ds.REF_USERS.child(comment.userID).child("Username").observeSingleEvent(of: .value, with: { (snapshot) in
                if let hostName = snapshot.value as? String {
                    self.usernameLabel.text = hostName
                }
            })
        }
        
        
    }

//    func setTableViewDataSourceDelegate
//        <D: UITableViewDelegate & UITableViewDataSource>
//        (dataSourceDelegate: D, forRow row: Int) {
//        
//        commentTableView.delegate = dataSourceDelegate
//        commentTableView.dataSource = dataSourceDelegate
////        commentTableView.tag = row
//        commentTableView.reloadData()
//    }
    
}

