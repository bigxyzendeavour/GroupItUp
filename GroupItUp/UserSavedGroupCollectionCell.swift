//
//  UserSavedGroupCollectionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class UserSavedGroupCollectionCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var savedCategoryImageView: UIImageView!
    @IBOutlet weak var savedCategoryLabel: UILabel!
    
    func configureCell(category: String) {
        savedCategoryLabel.text = category
        savedCategoryImageView.image = UIImage(named: category)
    }
}
