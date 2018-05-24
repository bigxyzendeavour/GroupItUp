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
    
    func configureCell(comment: Comment) {
        userDisplayImage.image = comment.userDisplayImage
        usernameLabel.text = comment.username
        userCommentLabel.text = comment.comment        
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

