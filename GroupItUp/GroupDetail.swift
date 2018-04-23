//
//  GroupDetail.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-20.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class GroupDetail {
    
    private var _groupID: String!
    private var _groupDisplayImageURL: String!
    private var _groupDisplayImage: UIImage!
    private var _groupTitle: String!
    private var _groupDetailDescription: String!
    private var _groupCategory: String!
    private var _groupContact: String!
    private var _groupContactEmail: String!
    private var _groupContactPhone: Int!
    private var _groupLikes: Int!
    private var _groupAttending: Int!
    private var _groupMeetingTime: String!
    private var _groupMeetUpAddress: Address!
    
    init() {
        
    }
    
    init(groupID: String, groupDetailData: Dictionary<String, Any>) {
        self._groupID = groupID
        if let title = groupDetailData["Title"] as? String {
            self._groupTitle = title
        }
        
        if let groupDisplayImageURL = groupDetailData["Group Display Photo URL"] as? String {
            self._groupDisplayImageURL = groupDisplayImageURL
            Storage.storage().reference(forURL: groupDisplayImageURL).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("GroupDetailModel: Error - \(error?.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    self._groupDisplayImage = image
                }
            })
        }
        
        if let detailDescription = groupDetailData["Detail Description"] as? String {
            self._groupDetailDescription = detailDescription
        }
        
        if let category = groupDetailData["Category"] as? String {
            self._groupCategory = category
        }
        
        if let contact = groupDetailData["Contact"] as? String {
            self._groupContact = contact
        }
        
        if let contactEmail = groupDetailData["Email"] as? String {
            self._groupContactEmail = contactEmail
        }
        
        if let contactPhone = groupDetailData["Phone"] as? Int {
            self._groupContactPhone = contactPhone
        }
        
        if let likes = groupDetailData["Likes"] as? Int {
            self._groupLikes = likes
        }
        
        if let attending = groupDetailData["Attending"] as? Int {
            self._groupAttending = attending
        }
        
        if let meetingTime = groupDetailData["Time"] as? String {
            self._groupMeetingTime = meetingTime
        }
        
        if let meetUpAddressData = groupDetailData["Address"] as? Dictionary<String, String> {
            let street = meetUpAddressData["Street"]!
            let city = meetUpAddressData["City"]!
            let province = meetUpAddressData["Province"]!
            let postal = meetUpAddressData["Postal"]!
            let country = meetUpAddressData["Country"]!
            let address = Address(street: street, city: city, province: province, postal: postal, country: country)
            self._groupMeetUpAddress = address
        }
    }
    
    var groupID: String {
        get {
            return _groupID
        }
        set {
            _groupID = newValue
        }
    }
    
    var groupDisplayImageURL: String {
        get {
            return _groupDisplayImageURL
        }
        set {
            _groupDisplayImageURL = newValue
        }
        
    }
    
    var groupDisplayImage: UIImage {
        get {
            return _groupDisplayImage
        }
        set {
            _groupDisplayImage = newValue
        }
    }
    
    var groupTitle: String {
        get {
            return _groupTitle
        }
        set {
            _groupTitle = newValue
        }
    }
    
    var groupDetailDescription: String {
        get {
            return _groupDetailDescription
        }
        set {
            _groupDetailDescription = newValue
        }
    }
    
    var groupCategory: String {
        get {
            return _groupCategory
        }
        set {
            _groupCategory = newValue
        }
    }
    
    var groupContact: String {
        get {
            return _groupContact
        }
        set {
            _groupContact = newValue
        }
    }
    
    var groupContactEmail: String {
        get {
            return _groupContactEmail
        }
        set {
            _groupContactEmail = newValue
        }
    }
    
    var groupContactPhone: Int {
        get {
            return _groupContactPhone
        }
        set {
            _groupContactPhone = newValue
        }
    }
    
    var groupLikes: Int {
        get {
            return _groupLikes
        }
        set {
            _groupLikes = newValue
        }
    }
    
    var groupAttending: Int {
        get {
            return _groupAttending
        }
        set {
            _groupAttending = newValue
        }
    }
    
    var groupMeetingTime: String {
        get {
            return _groupMeetingTime
        }
        set {
            _groupMeetingTime = newValue
        }
    }
    
    var groupMeetUpAddress: Address {
        get {
            return _groupMeetUpAddress
        }
        set {
            _groupMeetUpAddress = newValue
        }
    }
}
