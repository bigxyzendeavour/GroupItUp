//
//  NearbyGroupCommentEntryCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class NearbyGroupCommentEntryCell: UITableViewCell {

    @IBOutlet weak var commentTextField: UITextField!
    
    var selectedGroup: Group!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    func getNearbyGroupDetailCommentCell() -> NearbyGroupDetailCommentCell {
//        return 
//    }


    func setSelectedGroup(group: Group) {
        selectedGroup = group
    }

    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if let comment = commentTextField.text {
            if comment != "" {
                var comments = selectedGroup.groupComments
                let userEntryComment = Comment()
                userEntryComment.comment = comment
                let count = comments.count
                if count + 1 < 10 {
                    userEntryComment.commentID = "0\(count + 1)"
                } else {
                    userEntryComment.commentID = "\(count + 1)"
                }
                comments.append(userEntryComment)
                let commentData = [userEntryComment.commentID: ["Comment": comment, "User ID": userEntryComment.userID, "Username": userEntryComment.username]]
                DataService.ds.REF_GROUPS.child(selectedGroup.groupID).child("Comments").updateChildValues(commentData)
                let viewController = self.viewController() as! GroupDetailVC
                viewController.tableView.reloadData()
            }
        }
    }

}
