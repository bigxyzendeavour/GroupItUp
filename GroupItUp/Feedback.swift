//
//  Feedback.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-14.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class Feedback {
    
    private var _feedbackID: String!
    private var _userID: String!
    private var _username: String!
    private var _feedbackTitle: String!
    private var _feedback: String!
    private var _created: String!
    
    init() {
        self._feedbackID = ""
        self._username = ""
        self._userID = ""
        self._feedbackTitle = ""
        self._feedback = ""
        self._created = ""
    }
    
    //Initiate a feedback to be sent, no ID yet, this is set when initiating a comment
    init(userID: String) {
        self._feedbackID = ""
        self._userID = userID
        
    }
    
    //Download data
    init(feedbackID: String, feedbackData: Dictionary<String, Any>) {
        self._feedbackID = feedbackID
        
        let userID = feedbackData["User ID"] as! String
        self._userID = userID
        
        let feedbackTitle = feedbackData["Title"] as! String
        self._feedbackTitle = feedbackTitle
        
        let feedbackDescription = feedbackData["Feedback Description"] as! String
        self._feedback = feedbackDescription
        
        let username = feedbackData["Username"] as! String
        self._username = username
        
        let creationTime = feedbackData["Created"] as! String
        self._created = creationTime
    }
    
    var feedbackID: String {
        get {
            if _feedbackID == nil {
                _feedbackID = ""
            }
            return _feedbackID
        }
        set {
            _feedbackID = newValue
        }
    }
    
    var userID: String {
        get {
            if _userID == nil {
                _userID = ""
            }
            return _userID
        }
        set {
            _userID = newValue
        }
    }
    
    var username: String {
        get {
            if _username == nil {
                _username = ""
            }
            return _username
        }
        set {
            _username = newValue
        }
    }
    
    var feedbackTitle: String {
        get {
            if _feedbackTitle == nil {
                _feedbackTitle = ""
            }
            return _feedbackTitle
        }
        set {
            _feedbackTitle = newValue
        }
    }
    
    var feedback: String {
        get {
            if _feedback == nil {
                _feedback = ""
            }
            return _feedback
        }
        set {
            _feedback = newValue
        }
    }
    
    var created: String {
        get {
            if _created == nil {
                _created = ""
            }
            return _created
        }
        set {
            _created = newValue
        }
    }
}
