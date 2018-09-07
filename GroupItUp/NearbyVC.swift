//
//  NearbyVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import SwiftKeychainWrapper
import NVActivityIndicatorView

class NearbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, NearbyGroupCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var nearbyGroups = [Group]()
    var city: String!
    var selectedGroup: Group!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    private var refreshControl = UIRefreshControl()
    var inUse = false
    var isFromSignUp = false
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.startRefreshing()
        })
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
            if isRefreshing == true {
                self.refreshControl.endRefreshing()
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Network connection issue, please refresh", actionTitle: ["Cancel"])
                self.refreshControl.endRefreshing()
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.contentInset = insets
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshNearbyGroups), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing nearby groups", attributes: nil)
        
        initialize()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if city != nil && city != "" {
//            fetchNearbyGroups(city: city)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.endRefrenshing()
        self.refreshControl.endRefreshing()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.authorizedWhenInUse:
            inUse = true
            locationManager.startUpdatingLocation()
        case CLAuthorizationStatus.authorizedAlways:
            inUse = true
            locationManager.startUpdatingLocation()
        case CLAuthorizationStatus.denied:
            inUse = false
            self.endRefrenshing()
            isRefreshing = false
            self.sendAlertWithoutHandler(alertTitle: "Location Service Disabled", alertMessage: "Please make sure location service is enabled for GroupUp.", actionTitle: ["OK"])
        default:
            //Not determined
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locationManager.location
        if currentLocation != nil {
            locationManager.stopUpdatingLocation()
        }
        LocationServices.shared.getAdress { address, error in
            if error != nil {
                self.endRefrenshing()
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.sendAlertWithoutHandler(alertTitle: "Location Error", alertMessage: "\(error!.localizedDescription). Please refresh.", actionTitle: ["Cancel"])
                
                return
            }
            if let a = address, let city = a["City"] as? String, let country = a["Country"] as? String {
                self.city = city
                if currentUser.region == "" {
                    currentUser.region = country
                    DataService.ds.REF_USERS_CURRENT.child("Region").setValue(country)
                }
                
                
                self.fetchAllGroupStatus()
                //                    self.fetchNearbyGroups(city: city)
                //                    self.dispatchGroup.enter()
                
                self.fetchNearbyGroups(city: city, completion: { (nearbyGroups) in
                    self.nearbyGroups = nearbyGroups
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    self.endRefrenshing()
                    self.tableView.reloadData()
                })
                //                    self.dispatchGroup.leave()
                //
                //                    self.dispatchGroup.notify(queue: .main, execute: {
                //                        if self.refreshControl.isRefreshing {
                //                            self.refreshControl.endRefreshing()
                //                        }
                //                        self.endRefrenshing()
                //                        self.tableView.reloadData()
                //                    })
                
            }
        }
    }

    func initialize() {
        if countries.isEmpty == true {
            parseCountriesCSV()
        }
        
        
//        if KeychainWrapper.standard.bool(forKey: "In Use Status") != nil {
//            inUse = KeychainWrapper.standard.bool(forKey: "In Use Status")!
//            if inUse == true {
//                currentLocation = locationManager.location
//                if currentLocation != nil {
//                    locationManager.stopUpdatingLocation()
//                }
//                LocationServices.shared.getAdress { address, error in
//                    if error != nil {
//                        self.sendAlertWithoutHandler(alertTitle: "Location Error", alertMessage: "\(error?.localizedDescription). Please refresh.", actionTitle: ["Cancel"])
//                        return
//                    }
//                    if let a = address, let city = a["City"] as? String, let country = a["Country"] as? String {
//                        self.city = city
//                        if currentUser.region == "" {
//                            currentUser.region = country
//                            DataService.ds.REF_USERS_CURRENT.child("Region").setValue(country)
//                        }
//                        self.dispatchGroup.enter()
//                        self.fetchAllGroupStatus()
//                        self.dispatchGroup.leave()
//                        
//                        self.dispatchGroup.enter()
//                        self.fetchNearbyGroups(city: city)
//                        self.dispatchGroup.leave()
//                        
//                        self.dispatchGroup.notify(queue: .main, execute: { 
//                            if self.refreshControl.isRefreshing {
//                                self.refreshControl.endRefreshing()
//                            }
//                            self.endRefrenshing()
//                            self.tableView.reloadData()
//                        })
//                    }
//                }
//            }
//        } else {
//            inUse = false
//            KeychainWrapper.standard.set(false, forKey: "In Use Status")
//            locationManager.requestWhenInUseAuthorization()
//        }
        
    }
    
    func parseCountriesCSV() {
        let path = Bundle.main.path(forResource: "countries_provinces", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let country = row["country"]!
                
                let province = row["state"]!
                if !countries.contains(country) {
                    countries.append(country)
                    provinces.removeAll()
                    provinces.append("")
                    provinces.append(province)
                    countries_provinces[country] = provinces
                } else {
                    provinces.append(province)
                    countries_provinces[country] = provinces
                }
            }
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nearbyGroups.count < 20 {
            return nearbyGroups.count
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = nearbyGroups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupCell") as! NearbyGroupCell
        cell.delegate = self
        cell.configureCell(group: group)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup = nearbyGroups[indexPath.row]
        performSegue(withIdentifier: "GroupDetailVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GroupDetailVC {
            destination.selectedGroup = selectedGroup
        }
    }
    
    @objc private func refreshNearbyGroups() {
        self.refreshControl.beginRefreshing()
        isRefreshing = true
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
            if isRefreshing == true {
                self.refreshControl.endRefreshing()
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Network connection issue, please refresh", actionTitle: ["Cancel"])
                self.refreshControl.endRefreshing()
            }
        })
        if inUse == true {
            currentLocation = locationManager.location
            if currentLocation != nil {
                locationManager.stopUpdatingLocation()
            }
            LocationServices.shared.getAdress { address, error in
                if error != nil {
                    self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error?.localizedDescription). Please refresh.", actionTitle: ["Cancel"])
                    return
                }
                if let a = address, let city = a["City"] as? String, let country = a["Country"] as? String {
                    self.city = city
                    if currentUser.region == "" {
                        currentUser.region = country
                        DataService.ds.REF_USERS_CURRENT.child("Region").setValue(country)
                    }
                    
                    isRefreshing = true
                    self.fetchAllGroupStatus()
                    
                    self.fetchNearbyGroups(city: city, completion: { (nearbyGroups) in
                        self.nearbyGroups = nearbyGroups
                        if self.refreshControl.isRefreshing {
                            self.refreshControl.endRefreshing()
                        }
                        self.tableView.reloadData()
                    })
                    
                } else {
                    self.endRefrenshing()
                    self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Network connection issue, please check your network.", actionTitle: ["OK"])
                }
            }
            
        } else {
             locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func fetchNearbyGroups(city: String, completion: @escaping ([Group]) -> Void) {
    
        var tempGroups = [Group]()
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
            if isRefreshing == true {
                self.refreshControl.endRefreshing()
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Network connection issue, please refresh", actionTitle: ["Cancel"])
            }
        })
        DataService.ds.REF_BASE.child("Groups").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            self.tabBarItem.isEnabled = false
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapShot {
                    let group = Group()
                    var comments = [Comment]()
                    var previousPhotos = [Photo]()
                    
                    let groupID = snap.key
                    let groupData = snap.value as! Dictionary<String, Any>
                    let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
                    if let addressData = groupDetailData["Address"] as? Dictionary<String, String> {
                        let groupCity = addressData["City"]!
                        if groupCity == city {
                            if let commentData = groupData["Comments"] as? Dictionary<String, Any> {
                                for eachComment in commentData {
                                    let commentID = eachComment.key
                                    let commentDetail = eachComment.value as! Dictionary<String, Any>
                                    let comment = Comment(commentID: commentID, commentData: commentDetail)
                                    comments.append(comment)
                                }
                                let newComments = self.orderCommentsByID(comments: comments)
                                group.groupComments = newComments
                            }
                            if let previousPhotoData = groupData["Previous Photos"] as? Dictionary<String, String> {
                                for eachPhoto in previousPhotoData {
                                    let photoID = eachPhoto.key
                                    let photoURL = eachPhoto.value
                                    let photo = Photo(photoID: photoID, photoURL: photoURL)
                                    previousPhotos.append(photo)
                                }
                                let newPhotos = self.orderPhotosByID(photos: previousPhotos)
                                group.groupPhotos = newPhotos
                            }
                            group.groupID = groupID
                            let details = GroupDetail(groupID: groupID, groupDetailData: groupDetailData)
                            group.groupDetail = details
                            tempGroups.append(group)
                            
                        }
                        
                    }
                }
                tempGroups = self.orderGroupsByID(groups: tempGroups)
                if tempGroups.count == 0 {
                    
                    if isRefreshing == true {
                        self.endRefrenshing()
                        self.refreshControl.endRefreshing()
                    }
                    self.sendAlertWithoutHandler(alertTitle: "No groups nearby", alertMessage: "There are no groups around, please search by another location or interest.", actionTitle: ["OK"])
                    return
                }
                
                self.tableView.reloadData()
                print("Ready to process photo urls")
                
                for j in 0..<tempGroups.count {
                    let group = tempGroups[j]
                    var photoURLs = [String]()
                    let displayURL = group.groupDetail.groupDisplayImageURL
                    photoURLs.append(displayURL)
                    for photo in group.groupPhotos {
                        let url = photo.photoURL
                        photoURLs.append(url)
                    }
                    
                    for i in 0..<photoURLs.count {
                        let url = photoURLs[i]
                        Storage.storage().reference(forURL: url).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                            
                            if error != nil {
                                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error!.localizedDescription)", actionTitle: ["Cancel"])
                                self.refreshControl.endRefreshing()
                                self.endRefrenshing()
                                return
                            } else {
                                let image = UIImage(data: data!)
                                if i == 0 {
                                    group.groupDetail.groupDisplayImage = image!
                                    
                                } else {
                                    group.groupPhotos[i - 1].photo = image!
                                }
                                if j == tempGroups.count - 1 && i == group.groupPhotos.count - 1 {
                                    completion(tempGroups)
                                }
                            }
                        })
                    }
                    
                }
//                self.tableView.reloadData()
//                self.endRefrenshing()
            }
        })
        
    }
    
    func fetchAllGroupStatus() {
        DataService.ds.REF_GROUPS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    if let groupData = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
                        
                        let attendingMembers = groupDetailData["Attending Users"] as! Dictionary<String, Any>
                        let host = groupDetailData["Host"] as! String
                        
                        let date = groupDetailData["Time"] as! String
                        
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd HH:mm"
                        let currentDate = NSDate() as Date
                        let groupMeetingDate = df.date(from: date)!
                        let daysDiff = NSDate().calculateIntervalBetweenDates(newDate: groupMeetingDate, compareDate: currentDate)
                        if daysDiff > 1 {
                            DataService.ds.REF_GROUPS.child(key).child("Group Detail").child("Status").setValue("Completed")
                            if attendingMembers.keys.contains(currentUser.userID) {
                                DataService.ds.REF_USERS_CURRENT.child("Attending").child(key).removeValue()
                                DataService.ds.REF_USERS_CURRENT.child("Joined").child(key).setValue(true)
                            }
                            if host == currentUser.userID {
                                DataService.ds.REF_USERS_CURRENT.child("Hosting").child(key).removeValue()
                                DataService.ds.REF_USERS_CURRENT.child("Hosted").child(key).setValue(true)
                            }
                        }
                    }
                }
                print("finishing updating status")
            }
        })
    }
    
    func updateNearbyGroups(groups: [Group]) {
        nearbyGroups = groups
    }
    
    func getNearbyGroups() -> [Group] {
        return nearbyGroups
    }
    
    func callEndRefreshing() {
        tableView.reloadData()
        endRefrenshing()
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
}
