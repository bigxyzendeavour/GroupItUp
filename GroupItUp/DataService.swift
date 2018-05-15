//
//  DataService.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    var uid = Auth.auth().currentUser?.uid
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("Users")
    private var _REF_GROUPS = DB_BASE.child("Groups")
    
    //STORAGE references
    private var _STORAGE_USER_IMAGE = STORAGE_BASE.child("Users")
    private var _STORAGE_GROUP_IMAGE = STORAGE_BASE.child("All Groups")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USERS_CURRENT: DatabaseReference {
        let currentUser = DataService.ds._REF_USERS.child(uid!)
        return currentUser
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_USERS_CURRENT_LIKE: DatabaseReference {
        return REF_USERS_CURRENT.child("Likes")
    }
    
    var REF_USERS_CURRENT_FOLLOW: DatabaseReference {
        return REF_USERS_CURRENT.child("Follow")
    }
    
    var REF_USERS_CURRENT_ATTENDING: DatabaseReference {
        return REF_USERS_CURRENT.child("Attending")
    }
    
    var REF_USERS_CURRENT_JOINED: DatabaseReference {
        return REF_USERS_CURRENT.child("Joined")
    }
    
    var REF_USERS_CURRENT_HOSTING: DatabaseReference {
        return REF_USERS_CURRENT.child("Hosting")
    }
    
    var REF_USERS_CURRENT_HOSTED: DatabaseReference {
        return REF_USERS_CURRENT.child("Hosted")
    }
    
    var STORAGE_USER_IMAGE: StorageReference {
        return _STORAGE_USER_IMAGE
    }
    
    var STORAGE_GROUP_IMAGE: StorageReference {
        return _STORAGE_GROUP_IMAGE
    }
//
//    var STEP_IMAGE: StorageReference {
//        return _STEP_IMAGE
//    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
        
        
    }
    
    //    func existingUserDetermined(profileKey: String, ref: FIRDatabaseReference) -> Bool {
    //
    //        ref.observe(.value, with: { (snapshot) in
    //            if let profileDict = snapshot.value as? Dictionary<String, String> {
    //                print("Grandon(DataService): existing user snap is \(profileDict)")
    //                let username = profileDict["userName"]
    //                print("Grandon(DataService): username in profileDict is \(username)")
    //                if username != "" && username != nil {
    //                    userName = username
    //                }
    //            }
    //        })
    //        print("Grandon(DataService): userName is \(userName)")
    //
    //        if userName != "" && userName != nil {
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    
    
}
