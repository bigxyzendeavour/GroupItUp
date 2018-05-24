//
//  User.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class User {

    private var _userID: String!
    private var _userDisplayImageURL: String!
    private var _userDisplayImage: UIImage!
    private var _username: String!
    
    init() {
        _userID = ""
        _username = ""
        _userDisplayImageURL = ""
        _userDisplayImage = UIImage()
    }
    
    var userID: String {
        get {
            return _userID
        }
        set {
            _userID = newValue
        }
    }
    
    var username: String {
        get {
            return _username
        }
        set {
            _username = newValue
        }
    }
    
    var userDisplayImageURL: String {
        get {
            if _userDisplayImageURL != nil {
                return _userDisplayImageURL!
            } else {
                _userDisplayImageURL = ""
                return _userDisplayImageURL!
            }
            
        }
        set {
            _userDisplayImageURL = newValue
        }
    }
    
    var userDisplayImage: UIImage {
        get {
            if _userDisplayImage != nil {
                return _userDisplayImage!
            } else {
                _userDisplayImage = UIImage()
                return _userDisplayImage!
            }
            
        }
        set {
            _userDisplayImage = newValue
        }
    }
}
