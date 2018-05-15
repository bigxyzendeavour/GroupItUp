//
//  NewGroupCreateBtnCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-06.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

protocol NewGroupCreateBtnCellDelegate {
    func getGroupTitle() -> String
    func getGroupDisplayImage() -> UIImage
    func getGroupDescription() -> String
    func getGroupDetail() -> Dictionary<String, Any>
    func getGroupMeetingAddress() -> Dictionary<String, Any>
    func sendAlertWithoutHandler(alertTitle: String, alertMessage: String, actionTitle: [String])
    func sendAlertWithHandler(alertTitle: String, alertMessage: String, actionTitle: [String], handlers:[(_ action: UIAlertAction) -> Void])
}

class NewGroupCreateBtnCell: UITableViewCell {
    
    var delegate: NewGroupCreateBtnCellDelegate?
//    var groupDetail: Dictionary<String, Any>!
    let stringArray = ["Max Attending Members", "Time", "Contact", "Phone", "Email", "Address", "Category"]
    var allowEmptyGroupDisplayImage: Bool = false
    var continueWithoutAccurateAddress: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func createGroupBtnPressed(_ sender: UIButton) {
        if let delegate = self.delegate {
            var currentDetail = delegate.getGroupDetail()
            print(currentDetail)
            if currentDetail.count != 6 {
                delegate.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Something is missing. Please fill in all the information for the Detail section", actionTitle: ["Cancel"])
            }
            
            if delegate.getGroupTitle() == "" {
                delegate.sendAlertWithoutHandler(alertTitle: "Missing Title", alertMessage: "Please give a title to your group event", actionTitle: ["Cancel"])
                return
            } else {
                currentDetail["Title"] = delegate.getGroupTitle()
            }
            
            if delegate.getGroupDescription() == "" {
                delegate.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Please give a description to your group event", actionTitle: ["Cancel"])
                return
            } else {
                currentDetail["Detail Description"] = delegate.getGroupDescription()
            }
            
            
            
            var groupDetail = self.addInitGroupDetail(currentDetail: currentDetail)
            
            if delegate.getGroupDisplayImage() == UIImage(named: "emptyImage") {
                let yesActionHandler = {(action: UIAlertAction) -> Void in
                    
                    

                }
                let cancelActionHandler = {(action: UIAlertAction) -> Void in
                    self.allowEmptyGroupDisplayImage = false
                }
                delegate.sendAlertWithHandler(alertTitle: "Missing Display Image", alertMessage: "The group event doesn't have a display image, are you sure to continue?", actionTitle: ["Yes", "Cancel"], handlers: [yesActionHandler, cancelActionHandler])
            } else {
                
            }
            
            
        }
        
    }
    
//    func verifyAddress(address: String, delegate: NewGroupCreateBtnCellDelegate) {
//        let geoCoder = CLGeocoder()
//        if address != "" {
//            geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
//                if error != nil {
//                    let yesActionHandler = {(action: UIAlertAction) -> Void in
//                        self.continueWithoutAccurateAddress = true
//                    }
//                    let cancelActionHandler = {(action: UIAlertAction) -> Void in
//                        self.continueWithoutAccurateAddress = false
//                    }
//                    delegate.sendAlertWithHandler(alertTitle: "Error", alertMessage: "Address cannot be located or incorrect, do you want to continue?", actionTitle: ["Yes", "Cancel"], handlers: [yesActionHandler, cancelActionHandler])
//                } else {
//                    if let placemark = placemarks?.first {
//                        let location = placemark.location!
//                        LocationServices.shared.getAddressDetail(address: location, completion: { (address, error) in
//                            if let a = address {
//                                print(a)
//                                //                                    if let street = a["Street"],
//                            }
//                            
//                        })
//                    }
//                }
//            })
//        }
//    }
    
    func addInitGroupDetail(currentDetail: Dictionary<String, Any>) -> Dictionary<String, Any> {
        var detail = currentDetail
        detail["Created"] = "\(NSDate().fullTimeCreated())"
        detail["Host"] = DataService.ds.uid
        detail["Attending"] = 1
        detail["Likes"] = 0
        detail["Status"] = "Planning"
        detail["Attending Users"] = [DataService.ds.uid]
        return detail
    }
}
