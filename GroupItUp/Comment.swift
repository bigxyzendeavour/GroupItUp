//
//  Comment.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-20.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class Comment {
    
    private var _commentID: String!
    private var _userID: String!
    private var _username: String!
    private var _comment: String!
    private var _userDisplayImageURL: String?
    private var _userDisplayImage: UIImage?
    
    //Initiate a comment to be sent, no commentID yet, this is set when initiating a comment
    init() {
        self._userID = DataService.ds.uid
        let username = KeychainWrapper.standard.string(forKey: CURRENT_USERNAME)
        self._username = username
        DataService.ds.REF_USERS_CURRENT.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.value as? Dictionary<String, String> {
                let url = snapShot["User Display Photo URL"]
                self._userDisplayImageURL = url
            }
        })
        
        DataService.ds.STORAGE_USER_IMAGE.child("\(userID).jpg").getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("Comment(2): Error - \(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self._userDisplayImage = image
            }
        }
    }
    
    //Download data
    init(commentID: String, commentData: Dictionary<String, Any>) {
        self._commentID = commentID
        let userID = commentData["User ID"] as! String
        self._userID = userID
//        DataService.ds.REF_USERS.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
//                print(snapShot)
//            }
//        })
        DataService.ds.STORAGE_USER_IMAGE.child("\(userID).jpg").getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("Comment(2): Error - \(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self._userDisplayImage = image
            }
        }
        let comment = commentData["Comment"] as! String
        self._comment = comment
        let username = commentData["Username"] as! String
        self._username = username
    }
    
    init(commentID: String, userID: String, username: String, comment: String, userDisplayImageURL: String) {
        self._commentID = commentID
        self._userID = userID
        self._username = username
        self._comment = comment
        self._userDisplayImageURL = userDisplayImageURL
        let ref = Storage.storage().reference(forURL: userDisplayImageURL)
        ref.getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("Comment(3): Error - \(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self._userDisplayImage = image
            }
        }
    }
    
    var commentID: String {
        get {
            return _commentID
        }
        set {
            _commentID = newValue
        }
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
    
    var comment: String {
        get {
            if _comment != nil {
                return _comment
            } else {
                _comment = ""
                return _comment
            }
        }
        set {
            _comment = newValue
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
