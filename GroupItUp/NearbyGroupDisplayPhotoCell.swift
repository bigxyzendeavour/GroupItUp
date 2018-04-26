//
//  NearbyGroupDisplayPhotoCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-24.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class NearbyGroupDisplayPhotoCell: UITableViewCell {
    
    @IBOutlet weak var groupDisplayPhotoImage: UIImageView!

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
                self.groupDisplayPhotoImage.image = image
            }
        }
    }
    

}
