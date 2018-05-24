//
//  NewGroupCreationVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-03.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import OpalImagePicker
import Firebase
import IQKeyboardManagerSwift

class NewGroupCreationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NewGroupDescriptionCellDelegate, NewGroupCreateBtnCellDelegate, NewGroupDetailCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource, OpalImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NewGroupPreviousPhotoCellDelegate, NewGroupAddressEntryCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var imagePicker: UIImagePickerController!
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    var countryPicker: UIPickerView!
    var groupCreatingInProgress: Group!
    let categoryArray = ["", "Sport", "Entertainment", "Travel", "Food", "Study"]
    var selectedIndex: Int!
    var selectedImage: UIImage?
    var groupTitle: String!
    var groupDescription: String!
    var groupDetail: Dictionary<String, Any>!
    var groupPreviousPhotos: [Photo]?
    var allowEmptyGroupDisplayImage: Bool!
    var previousPhotos = [UIImage]()
    var countries: [String] = []
    var groupMeetingAddress: Address!
    var groupDetailForGroup: GroupDetail!
    var newGroup: Group!
    
    override func viewWillAppear(_ animated: Bool) {
        reloadSection(indexSection: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
//        groupDetail = [String: Any]()
        datePicker = UIDatePicker()
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        parseCountriesCSV()
    }
    
    func parseCountriesCSV() {
        let path = Bundle.main.path(forResource: "countries", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let country = row["country"]!
                countries.append(country)
            }
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupDisplayCell") as? NewGroupDisplayCell {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                tapGesture.numberOfTapsRequired = 1
                cell.groupDisplayImageView.addGestureRecognizer(tapGesture)
                cell.groupDisplayImageView.isUserInteractionEnabled = true
                if selectedImage != nil {
                    cell.configureCell(groupDisplayImage: selectedImage!)
                }
                return cell
            }
            return UITableViewCell()
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupDescriptionCell") as! NewGroupDescriptionCell
            cell.delegate = self
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupDetailCell") as! NewGroupDetailCell
            cell.maxTextField.keyboardType = .numberPad
            datePicker.minimumDate = NSDate() as Date
            cell.timeTextField.inputView = datePicker
            cell.datePicker = datePicker
            cell.contactTextField.keyboardType = .default
            cell.phoneTextField.keyboardType = .phonePad
            cell.emailTextField.keyboardType = .emailAddress
            cell.categoryTextField.inputView = pickerView
            cell.pickerView = pickerView
            cell.delegate = self
//            cell.configureCell(detail: getGroupDetail())
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupAddressEntryCell") as! NewGroupAddressEntryCell
            cell.countryTextField.inputView = countryPicker
            cell.countryPicker = countryPicker
            cell.countries = countries
            cell.delegate = self
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupPreviousPhotoQuestionCell") as! NewGroupPreviousPhotoQuestionCell
            
            return cell
        } else if indexPath.section == 5 {
            if previousPhotos.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupPreviousPhotoCell") as! NewGroupPreviousPhotoCell
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                cell.delegate = self
                return cell
            }
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "NewGroupCreateBtnCell") as! NewGroupCreateBtnCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 190
        } else if indexPath.section == 5 {
            if previousPhotos.count > 0 {
                return 185
            } else {
                return CGFloat.leastNormalMagnitude
            }
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            let opalImagePicker = OpalImagePickerController()
            opalImagePicker.imagePickerDelegate = self
            opalImagePicker.maximumSelectionsAllowed = 10
            self.present(opalImagePicker, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 || section == 3{
            return 30
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Detail"
        } else if section == 3 {
            return "Address"
        } else {
            return ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(countryPicker) {
            return countries.count
        }
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(countryPicker) {
            return countries[row]
        }
        return categoryArray[row]
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        loadingView.show()
        //        activityIndicator.startAnimating()
        selectedImage = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        reloadSection(indexSection: selectedIndex)
        
//            groupCreatingInProgress.groupDetail.groupDisplayImage = selectedImage
//            tableView.reloadRows(at: [index], with: .automatic)
//
//            if let imageData = UIImageJPEGRepresentation(selectedImage, 0.5) {
//                let ref = DataService.ds.REF_GROUPS
//                ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
//                        let count = snapShot.count
//                        var groupID: String!
//                        if count < 10 {
//                            groupID = "0\(count + 1)"
//                        } else {
//                            groupID = "\(count + 1)"
//                        }
//                        let groupDisplayImageID = groupID
//                        let metadata = StorageMetadata()
//                        metadata.contentType = "image/jpeg"
//                        DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child(groupDisplayImageID!).putData(imageData, metadata: metadata, completion: { (metadata, error) in
//                            if error != nil {
//                                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error?.localizedDescription)", actionTitle: ["Cancel"])
//                            } else {
//                                let imageURL = metadata?.downloadURL()?.absoluteString
//                                self.groupCreatingInProgress.groupDetail.groupDisplayImageURL = imageURL!
//                                
//                            }
//                        })
//                    }
//                })
//
//                
            
                
//                step.imageData = imageData
//                step.metaData = metadata
//                DataService.ds.STEP_IMAGE.child(postId).child(stepImgName).putData(imageData, metadata: metadata) {
//                    (data, error) in
//                    if error != nil {
//                        print("Grandon(DetailStepVC): unable to upload profile image.")
//                    } else {
//                        print("Grandon(DetailStepVC): successfully upload profile image.")
//                        let imageUrl = data?.downloadURL()?.absoluteString
//                        step.stepImgUrl = imageUrl!
//                        DataService.ds.REF_POSTS.child(self.postId).child("steps").child("stepDetails").child("\(self.selectedIndex + 1)").child("stepImgUrl").setValue(imageUrl)
//                        
//                        //
//                        self.view.isUserInteractionEnabled = true
//                    }
//                }
//            }
            
            //            tableView.reloadData()
            
        
        //        activityIndicator.stopAnimating()
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    func reloadSection(indexSection: Int) {
        tableView.beginUpdates()
        let indexSet = NSIndexSet(index: indexSection)
        tableView.reloadSections(indexSet as IndexSet, with: .automatic)
        tableView.endUpdates()
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: tableView)
        let ip = tableView.indexPathForRow(at: location)!
        selectedIndex = ip.row
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        previousPhotos = images
        picker.dismiss(animated: true, completion: nil)
        reloadSection(indexSection: 5)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previousPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGroupPreviousPhotoCollectionCell", for: indexPath) as! NewGroupPreviousPhotoCollectionCell
        let photo = previousPhotos[indexPath.row]
        cell.configureCell(image: photo)
        return cell

    }
    
    func setGroupTitle(title: String) {
        groupTitle = title
    }
    
    func getGroupTitle() -> String {
        if groupTitle == nil  {
            return ""
        }
        return groupTitle
    }
    
    func getGroupDisplayImage() -> UIImage {
        if selectedImage == nil {
            return UIImage(named: "emptyImage")!
        }
        return selectedImage!
    }
    
    func setGroupDescription(description: String) {
        groupDescription = description
    }
    
    func getGroupDescription() -> String {
        if groupDescription == nil {
            return ""
        }
        print(groupDescription)
        return groupDescription!
    }
    
    func setGroupDetail(detail: Dictionary<String, Any>) {
        groupDetail = detail as Dictionary<String, Any>
    }

    func getGroupDetail() -> Dictionary<String, Any> {
        if groupDetail == nil {
            return [String: Any]()
        }
        return groupDetail
    }
    
    func getGroupDetailForGroup() -> GroupDetail {
        if groupDetailForGroup == nil {
            groupDetailForGroup = GroupDetail()
        }
        return groupDetailForGroup
    }
    
    func setAllowEmptyGroupDisplayImage(allow: Bool) {
        allowEmptyGroupDisplayImage = allow
    }
    
    func resetPreviousPhotos() {
        previousPhotos.removeAll()
        reloadSection(indexSection: 5)
    }
    
    func getPreviousGroupPhotos() -> [UIImage] {
        if previousPhotos.count > 0 {
            return previousPhotos
        }
        return [UIImage]()
    }
    
    func setAddress(address: Address) {
        if !address.isEmpty() {
            groupMeetingAddress = address
            let street = address.street
            let city = address.city
            let province = address.province
            let postal = address.postal
            let country = address.country
            groupMeetingAddress.address = "\(street), \(city), \(province), \(postal), \(country)"
        } else {
            groupMeetingAddress = nil
        }
    }
    
    func getGroupMeetingAddress() -> Dictionary<String, Any> {
        if groupMeetingAddress != nil {
            let street = groupMeetingAddress.street
            let city = groupMeetingAddress.city
            let province = groupMeetingAddress.province
            let postal = groupMeetingAddress.postal
            let country = groupMeetingAddress.country
            let groupMeetingUpAddress = ["Street": street, "City": city, "Province": province, "Postal": postal, "Country": country]
            return groupMeetingUpAddress
        } else {
            return [String: Any]()
        }
    }
    
    func getGroupAddressForGroup() -> Address {
        return groupMeetingAddress
    }
    
    func setSelectedGroup(group: Group) {
        newGroup = group
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewGroupCreationCompletedVC {
            destination.selectedGroup = newGroup
            destination.newCreatedGroup = true
        }
    }
}
