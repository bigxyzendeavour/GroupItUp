//
//  NearbyGroupDetailCommentCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-17.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NearbyGroupDetailCommentCell: UITableViewCell {

    @IBOutlet weak var commentTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    func setTableViewDataSourceDelegate
        <D: UITableViewDelegate & UITableViewDataSource>
        (dataSourceDelegate: D, forRow row: Int) {
        
        commentTableView.delegate = dataSourceDelegate
        commentTableView.dataSource = dataSourceDelegate
//        commentTableView.tag = row
        commentTableView.reloadData()
    }
    
}

