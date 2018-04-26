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
        let groupDisplayURL = group.groupDetail.groupDisplayImageURL
        let groupDisplayPhotoRef = Storage.storage().reference(forURL: groupDisplayURL)
        groupDisplayPhotoRef.getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("Photo: Error - \(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self.groupDisplayImage.image = image
            }
        }
        groupTitleLabel.text = group.groupDetail.groupTitle
        groupDetailLabel.text = group.groupDetail.groupDetailDescription
        groupLocationLabel.text = group.groupDetail.groupMeetUpAddress.city
        let daysPassed = calculateInterval(group: group)
        assignPostDateLbl(daysPassed: daysPassed, group: group)
    }

    func calculateInterval(group: Group) -> Int {
        let currentDate = NSDate()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: group.groupDetail.groupCreationDate)!
        let interval = currentDate.timeIntervalSince(date as Date)
        return Int(interval) / 259200
    }
    
    func assignPostDateLbl(daysPassed: Int, group: Group) {
        if  daysPassed > 3 {
            self.groupCreationDateLabel.text = "\(daysPassed)ds ago"
        } else {
            let date = group.groupDetail.groupCreationDate
            let index = date.index(date.startIndex, offsetBy: 10)
            let shortDate = date.substring(to: index)
            self.groupCreationDateLabel.text = "\(shortDate)"
        }
    }
}
