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
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
//        previousPhotoCollectionView.delegate = dataSourceDelegate
//        previousPhotoCollectionView.dataSource = dataSourceDelegate
//        previousPhotoCollectionView.reloadData()
    }
}
