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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
//        LocationServices.shared.getAdress { (address, error) in
//            if let a = address, let city = a["City"] as? String {
//                self.city = city
//                DispatchQueue.global().async {
//                    self.fetchNearbyGroups(city: city)
//                    
//                }
//                
//            }
//        }
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
                if let a = address, let city = a["City"] as? String {
                    self.city = city
                    self.fetchNearbyGroups(city: city)
                    
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupCell") as? NearbyGroupCell {
            cell.configureCell(group: group)
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup = nearbyGroups[indexPath.row]
        performSegue(withIdentifier: "GroupDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GroupDetailVC {
            destination.selectedGroup = selectedGroup
        }
    }
    
    @objc private func refreshNearbyGroups() {
        fetchNearbyGroups(city: city)
    }
    
    func fetchNearbyGroups(city: String) {
        nearbyGroups.removeAll()
        var tempGroups = [Group]()
        DataService.ds.REF_BASE.child("Groups").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            DispatchQueue.global().async {
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
                                    print("Error: \(error!.localizedDescription)")
                                } else {
                                    let image = UIImage(data: data!)
                                    if i == 0 {
                                        group.groupDetail.groupDisplayImage = image!
                                    } else {
                                        group.groupPhotos[i - 1].photo = image!
                                    }
                                    self.updateNearbyGroups(groups: self.nearbyGroups)
                                    self.tableView.reloadData()
                                }
                            })
                        }
                    }
                    
                    self.refreshControl.endRefreshing()
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    //                for group in self.nearbyGroups {
                    //                    for photo in group.groupPhotos {
                    //                        let url = photo.photoURL
                    //                        Storage.storage().reference(forURL: url).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                    //                            if error != nil {
                    //                                print("NearbyVC: \(error?.localizedDescription)")
                    //                            } else {
                    //                                let image = UIImage(data: data!)
                    //                                photo.photo = image!
                    //                            }
                    //                        })
                    //                    }
                    //                }
                    //
                    //                for group in self.nearbyGroups {
                    //                    let groupID = group.groupID
                    //                    DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child("Display.jpg").getData(maxSize: 1024 * 1024, completion: { (data, error) in
                    //                        if error != nil {
                    //                            print("\(error?.localizedDescription)")
                    //                        } else {
                    //                            let image = UIImage(data: data!)
                    //                            group.groupDetail.groupDisplayImage = image!
                    //                        }
                    //                    })
                    //                    self.updateNearbyGroups(groups: self.nearbyGroups)
                    //                    self.tableView.reloadData()
                    //                }
                    
                }
            }
            
        })
        
        
    }
    
    func updateNearbyGroups(groups: [Group]) {
        nearbyGroups = groups
    }
    
    func getNearbyGroups() -> [Group] {
        return nearbyGroups
    }
}
