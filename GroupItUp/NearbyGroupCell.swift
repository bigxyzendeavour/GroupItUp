//
//  NearbyGroupCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-15.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class NearbyGroupCell: UITableViewCell {
    
    @IBOutlet weak var groupDisplayImage: UIImageView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDetailLabel: UILabel!
    @IBOutlet weak var groupLocationLabel: UILabel!
    @IBOutlet weak var groupCreationDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(group: Group) {
        groupDisplayImage.image = group.groupDetail.groupDisplayImage
        groupTitleLabel.text = group.groupDetail.groupTitle
        groupDetailLabel.text = group.groupDetail.groupDetailDescription
        groupLocationLabel.text = group.groupDetail.groupMeetUpAddress.city
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDate = NSDate() as Date
        let creationDate = df.date(from: group.groupDetail.groupCreationDate)!
        let daysDiff = NSDate().calculateIntervalBetweenDates(newDate: creationDate, compareDate: currentDate)
        assignPostDateLbl(daysDifference: daysDiff, group: group)
    }

    func assignPostDateLbl(daysDifference: Int, group: Group) {
        if  daysDifference > 3 {
            self.groupCreationDateLabel.text = "\(daysDifference)ds ago"
        } else {
            let date = group.groupDetail.groupCreationDate
            let index = date.index(date.startIndex, offsetBy: 10)
            let shortDate = date.substring(to: index)
            self.groupCreationDateLabel.text = "\(shortDate)"
        }
    }
}
