//
//  NearbyGroupDescriptionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-21.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class NearbyGroupDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDetailDescriptionLabel: UILabel!
    @IBOutlet weak var groupAttendingNumberLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!

    var selectedGroup: Group!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configureCell(group: Group) {
        let groupDetail = group.groupDetail
        groupTitleLabel.text = groupDetail.groupTitle
        groupDetailDescriptionLabel.text = groupDetail.groupDetailDescription
        groupAttendingNumberLabel.text = "\(groupDetail.groupAttending)"
        if groupDetail.groupHost != DataService.ds.uid {
            for member in groupDetail.groupAttendingUsers {
                if member == DataService.ds.uid {
                    joinBtn.setTitle("I'm Out!", for: .normal)
                    break
                }
            }
            if groupDetail.groupAttending >= groupDetail.groupMaxMembers {
                let currentUserID = DataService.ds.uid!
                let groupAttendingMembers = groupDetail.groupAttendingUsers
                if !groupAttendingMembers.contains(currentUserID) {
                    joinBtn.isEnabled = false
                    joinBtn.backgroundColor = UIColor.lightGray
                }
            }
            let myLikeRef = DataService.ds.REF_USERS_CURRENT_LIKE
            myLikeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.value as? Dictionary<String, Bool> {
                    for snap in snapShot {
                        if snap.key == group.groupID {
                            self.likeBtn.setImage(UIImage(named: "filled-heart"), for: .normal)
                            break
                        }
                    }
                }
            })
        } else {
            joinBtn.isEnabled = false
            joinBtn.backgroundColor = UIColor.lightGray
            likeBtn.isHidden = true
        }
    }
    
    func setSelectedGroup(group: Group) {
        selectedGroup = group
    }
    
    @IBAction func likeBtnPressed(_ sender: UIButton) {
        let likeRef = DataService.ds.REF_GROUPS.child(selectedGroup.groupID).child("Group Detail").child("Likes")
        var likes: Int!
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let likesNum = snapshot.value as? Int {
                likes = likesNum
                if self.likeBtn.currentImage != UIImage(named: "filled-heart") {
                    let filledHeartImg = UIImage(named: "filled-heart")
                    self.likeBtn.setImage(filledHeartImg, for: .normal)
                    likes = likes + 1
                    DataService.ds.REF_USERS_CURRENT_LIKE.child(self.selectedGroup.groupID).setValue(true)
                } else {
                    let emptyHeartImg = UIImage(named: "empty-heart")
                    self.likeBtn.setImage(emptyHeartImg, for: .normal)
                    likes = likes - 1
                    DataService.ds.REF_USERS_CURRENT_LIKE.child(self.selectedGroup.groupID).removeValue()
                }
                let likeData = ["Likes": likes!]
                DataService.ds.REF_GROUPS.child(self.selectedGroup.groupID).child("Group Detail").updateChildValues(likeData)
            }
        })
        //        loadingView.hide()

    }
    

    @IBAction func joinBtnPressed(_ sender: UIButton) {
        let attendingRef = DataService.ds.REF_GROUPS.child(selectedGroup.groupID).child("Group Detail").child("Attending")
        var attending: Int!
        attendingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let attendingNum = snapshot.value as? Int {
                attending = attendingNum
                if self.joinBtn.currentTitle == "I'm In!" {
                    self.joinBtn.setTitle("I'm Out!", for: .normal)
                    attending = attending + 1
                    DataService.ds.REF_USERS_CURRENT_ATTENDING.child(self.selectedGroup.groupID).setValue(true)
                    DataService.ds.REF_GROUPS.child(self.selectedGroup.groupID).child("Group Detail").child("Attending Users").child(DataService.ds.uid!).setValue(true)
                } else {
                    self.joinBtn.setTitle("I'm In!", for: .normal)
                    attending = attending - 1
                    DataService.ds.REF_USERS_CURRENT_ATTENDING.child(self.selectedGroup.groupID).removeValue()
                    DataService.ds.REF_GROUPS.child(self.selectedGroup.groupID).child("Group Detail").child("Attending Users").child(DataService.ds.uid!).removeValue()
                }
                self.groupAttendingNumberLabel.text = "\(attending!)"
                let attendingData = ["Attending": attending!]
                DataService.ds.REF_GROUPS.child(self.selectedGroup.groupID).child("Group Detail").updateChildValues(attendingData)
            }
        })

    }


    
}