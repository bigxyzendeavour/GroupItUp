//
//  NewGroupDescriptionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-06.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol NewGroupDescriptionCellDelegate {
    func setGroupDescription(description: String)
    func getGroupDescription() -> String
    func setGroupTitle(title: String)
}

class NewGroupDescriptionCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var groupTitleTextField: UITextField!
    @IBOutlet weak var groupDescriptionTextView: UITextView!
    
    var delegate: NewGroupDescriptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupDescriptionTextView.delegate = self
    }
    
    func configureCell(description: String) {
        groupDescriptionTextView.text = description
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let delegate = self.delegate
        let tag = groupDescriptionTextView.tag
        if tag == 0 {
            if let groupDescription = groupDescriptionTextView.text, groupDescription != "" {
                delegate?.setGroupDescription(description: groupDescription)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let delegate = self.delegate
        if let groupTitle = groupTitleTextField.text, groupTitle != "" {
            delegate?.setGroupTitle(title: groupTitle)
        }
        
    }
    
    func getGroupDescription() -> String {
        if groupDescriptionTextView.text != "" {
            return groupDescriptionTextView.text
        }
        return ""
    }

}
