//
//  NearbyGroupDetailCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-24.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol NearbyGroupDetailCellDelegate {
    func sendAlertWithoutHandler(alertTitle: String, alertMessage: String, actionTitle: [String])
}


class NearbyGroupDetailCell: UITableViewCell {

    @IBOutlet weak var groupStatusLabel: UILabel!
    @IBOutlet weak var groupMaxMembersLabel: UILabel!
    @IBOutlet weak var groupCategoryLabel: UILabel!
    @IBOutlet weak var groupMeetingUpTimeLabel: UILabel!
    @IBOutlet weak var groupContactPersonLabel: UILabel!
    @IBOutlet weak var groupContactPhoneLabel: UILabel!
    @IBOutlet weak var groupContactEmailLabel: UILabel!
    @IBOutlet weak var groupMeetUpAddressLabel: UILabel!
    
    var delegate: NearbyGroupDetailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(group: Group) {
        let groupDetail = group.groupDetail
        groupStatusLabel.text = groupDetail.groupStatus
        if groupDetail.groupStatus == "Cancel" {
            groupStatusLabel.backgroundColor = UIColor.red
            let viewController = UIViewController(nibName: "GroupDetailVC", bundle: nil)
            viewController.sendAlertWithoutHandler(alertTitle: "Cancelled", alertMessage: "This group has been cancelled!", actionTitle: ["Cancel"])
        }
        groupMaxMembersLabel.text = "\(groupDetail.groupMaxMembers)"
        groupCategoryLabel.text = groupDetail.groupCategory
        groupMeetingUpTimeLabel.text = groupDetail.groupMeetingTime
        groupContactPersonLabel.text = groupDetail.groupContact
        groupContactPhoneLabel.text = "\(groupDetail.groupContactPhone)"
        groupContactEmailLabel.text = groupDetail.groupContactEmail
        groupMeetUpAddressLabel.text = groupDetail.groupMeetUpAddress.address
    }

    @IBAction func directionBtnPressed(_ sender: UIButton) {
        let geoCoder = CLGeocoder()
        let address = groupMeetUpAddressLabel.text
        if address != "" {
            geoCoder.geocodeAddressString(address!, completionHandler: { (placemarks, error) in
                if error != nil {
                    if let delegate = self.delegate {
                        delegate.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Address is not found or incorrect, please contact the host for correction.", actionTitle: ["Cancel"])
                    }
                } else {
                    if let placemark = placemarks?.first {
                        let location = placemark.location!
                        let regionDistance: CLLocationDistance = 1000
                        let coordinate = location.coordinate
                        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
                        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
                        let destinationPlacemark = MKPlacemark(coordinate: coordinate)
                        let mapItem = MKMapItem(placemark: destinationPlacemark)
                        mapItem.name = "Destination"
                        mapItem.openInMaps(launchOptions: options)
                    }
                }
            })
        }
    }

}
