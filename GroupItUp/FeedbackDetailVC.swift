//
//  FeedbackDetailVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-03.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class FeedbackDetailVC: UIViewController {
    
    @IBOutlet weak var feedbackTitleLabel: UILabel!
    @IBOutlet weak var feedbackContentLabel: UILabel!

    var selectedFeedback: Feedback!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func initialize() {
        feedbackTitleLabel.text = selectedFeedback.feedbackTitle
        feedbackContentLabel.text = selectedFeedback.feedbackContent
        
        
    }

    func fetchComment() {
        
    }
}
