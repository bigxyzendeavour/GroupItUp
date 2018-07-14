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

class NearbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var nearbyGroups = [Group]()
    var city: String!
    var selectedGroup: Group!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var inUse = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    private var refreshControl = UIRefreshControl()
    var isRefreshing: Bool!
    var isFromSignUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.contentInset = insets
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshNearbyGroups), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing nearby groups", attributes: nil)
        
        initialize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if city != nil && city != "" {
//            fetchNearbyGroups(city: city)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.endRefrenshing()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.authorizedWhenInUse:
            inUse = true
        case CLAuthorizationStatus.authorizedAlways:
            inUse = true
        default:
            inUse = false
        }
        
        if inUse == true {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if inUse == true {
            currentLocation = locationManager.location
            if currentLocation != nil {
                locationManager.stopUpdatingLocation()
            }
            LocationServices.shared.getAdress { address, error in
                if error != nil {
                    self.sendAlertWithoutHandler(alertTitle: "Location Error", alertMessage: "\(error?.localizedDescription). Please refresh.", actionTitle: ["Cancel"])
                    return
                }
                if let a = address, let city = a["City"] as? String, let country = a["Country"] as? String {
                    self.city = city
                    if currentUser.region == "" {
                        currentUser.region = country
                        DataService.ds.REF_USERS_CURRENT.child("Region").setValue(country)
                    }
                    
                    self.fetchNearbyGroups(city: city)
                    
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func initialize() {
        parseCountriesCSV()
//        currentLocation = locationManager.location
//        if currentLocation != nil {
//            LocationServices.shared.getAdress { address, error in
//                if error != nil {
//                    self.sendAlertWithoutHandler(alertTitle: "Location Error", alertMessage: "\(error?.localizedDescription). Please refresh.", actionTitle: ["Cancel"])
//                    return
//                }
//                self.inUse = true
//                if let a = address, let city = a["City"] as? String {
//                    self.city = city
//                    self.fetchNearbyGroups(city: city)
//                    
//                }
//            }
//        } else {
//            self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Network connection issue, please wait and refresh.", actionTitle: ["OK"])
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
        return nearbyGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = nearbyGroups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupCell") as! NearbyGroupCell
        cell.configureCell(group: group)
        //            DispatchQueue.main.async {
        //                self.activityIndicator.stopAnimating()
        //            }
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
                    
                    self.fetchNearbyGroups(city: city)
                    
                } else {
                    self.endRefrenshing()
                    self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Network connection issue, please check your network.", actionTitle: ["OK"])
                }
            }
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func fetchNearbyGroups(city: String) {
        
        var tempGroups = [Group]()
        self.startRefreshing()
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
            if self.isRefreshing == true {
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Time out, please refresh", actionTitle: ["Cancel"])
                
            }
        })
        DataService.ds.REF_BASE.child("Groups").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            self.tabBarItem.isEnabled = false
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                if snapShot.count == 0 {
                    self.sendAlertWithoutHandler(alertTitle: "No groups nearby", alertMessage: "There are no groups around, please search by another location or interest.", actionTitle: ["OK"])
                    return
                }
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
                self.nearbyGroups = self.orderGroupsByID(groups: tempGroups)
                
                for group in self.nearbyGroups {
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
                                self.endRefrenshing()
                                return
                            } else {
                                let image = UIImage(data: data!)
                                if i == 0 {
                                    group.groupDetail.groupDisplayImage = image!
                                } else {
                                    group.groupPhotos[i - 1].photo = image!
                                    
                                }
                                self.tableView.reloadData()
                                self.endRefrenshing()
                            }
                        })
                    }
                }
                
                
            }
            
        })
        
    }
    
    func startRefreshing() {
        self.isRefreshing = true
        self.activityIndicator.startAnimating()
        self.refreshControl.beginRefreshing()
        self.tableView.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
    }
    
    func endRefrenshing() {
        self.isRefreshing = false
        self.activityIndicator.stopAnimating()
        self.refreshControl.endRefreshing()
        self.tableView.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
    }
    
    func updateNearbyGroups(groups: [Group]) {
        nearbyGroups = groups
    }
    
    func getNearbyGroups() -> [Group] {
        return nearbyGroups
    }
}
