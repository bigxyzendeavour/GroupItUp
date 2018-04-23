//
//  NearbyGroupDetailCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-21.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class NearbyGroupDetailCell: UITableViewCell {
    
    @IBOutlet weak var groupDisplayImage: UIImageView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDetailDescriptionTextView: UITextView!
    @IBOutlet weak var groupAttendingNumberLabel: UILabel!
    @IBOutlet weak var groupCategoryLabel: UILabel!
    @IBOutlet weak var groupMeetingUpTimeLabel: UILabel!
    @IBOutlet weak var groupContactPersonLabel: UILabel!
    @IBOutlet weak var groupContactPhoneLabel: UILabel!
    @IBOutlet weak var groupContactEmailLabel: UILabel!
    @IBOutlet weak var groupMeetUpAddressLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(group: Group) {
        let groupDisplayImageURL = group.groupDetail.groupDisplayImageURL
        Storage.storage().reference(forURL: groupDisplayImageURL).getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("NearbyGroupDetailCell: Error - \(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self.groupDisplayImage.image = image
            }
        }
        let groupDetail = group.groupDetail
        groupTitleLabel.text = groupDetail.groupTitle
        groupDetailDescriptionTextView.text = groupDetail.groupDetailDescription
        groupAttendingNumberLabel.text = "\(groupDetail.groupAttending)"
        groupCategoryLabel.text = groupDetail.groupCategory
        groupMeetingUpTimeLabel.text = groupDetail.groupMeetingTime
        groupContactPersonLabel.text = groupDetail.groupContact
        groupContactPhoneLabel.text = "\(groupDetail.groupContactPhone)"
        groupContactEmailLabel.text = groupDetail.groupContactEmail
        groupMeetUpAddressLabel.text = groupDetail.groupMeetUpAddress.address
    }
    
    @IBAction func likeBtnPressed(_ sender: UIButton) {
    }
    

    @IBAction func joinBtnPressed(_ sender: UIButton) {
    }

    @IBAction func directionBtnPressed(_ sender: UIButton) {
    }
    
}
