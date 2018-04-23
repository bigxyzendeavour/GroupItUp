//
//  NearbyGroupDetailPreviousMeetPhotoCollectionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-16.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NearbyGroupDetailPreviousMeetPhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var groupPhotoImage: UIImageView!
    
    func configureCell(photo: Photo) {
        
        groupPhotoImage.image = photo.photo
    }
    
}
