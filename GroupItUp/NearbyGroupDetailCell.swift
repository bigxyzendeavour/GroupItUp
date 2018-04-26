//
//  NearbyGroupDetailCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-24.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NearbyGroupDetailCell: UITableViewCell {

    @IBOutlet weak var groupStatusLabel: UILabel!
    @IBOutlet weak var groupMaxMembersLabel: UILabel!
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
        let groupDetail = group.groupDetail
        groupStatusLabel.text = groupDetail.groupStatus
        groupMaxMembersLabel.text = "\(groupDetail.groupMaxMembers)"
        groupCategoryLabel.text = groupDetail.groupCategory
        groupMeetingUpTimeLabel.text = groupDetail.groupMeetingTime
        groupContactPersonLabel.text = groupDetail.groupContact
        groupContactPhoneLabel.text = "\(groupDetail.groupContactPhone)"
        groupContactEmailLabel.text = groupDetail.groupContactEmail
        groupMeetUpAddressLabel.text = groupDetail.groupMeetUpAddress.address
    }

    @IBAction func directionBtnPressed(_ sender: UIButton) {
    }

}
