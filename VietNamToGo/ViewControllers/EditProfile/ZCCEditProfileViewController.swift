//
//  ZCCEditProfileViewController.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/2/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import UIKit
import Former
import Parse
import ParseFacebookUtilsV4

final class ZCCEditProfileViewController: ZCCViewController {
    
    var isOtherAvatar:Bool?
    
    @IBAction func btnSaveTapped(sender: AnyObject) {
        showHUDProgress()
        
        let currentUser = PFUser.currentUser()
        /* avatar */
        if let _ = self.isOtherAvatar {
            if let avatarImg = Profile.sharedInstance.image
            {
                // Compress image 10 times before uploading
                let imageFile = PFFile(name: "profileImage.jpg", data: UIImageJPEGRepresentation(avatarImg, 0.1)!)
                currentUser?.setObject(imageFile!, forKey:"facebookProfilePicture")
            }
        }
        
        /* self-introduction */
        if let introduction = Profile.sharedInstance.introduction{
            currentUser?.setObject(introduction, forKey:"introduction")
        }
        
        /* Name */
        if let name = Profile.sharedInstance.name{
            currentUser?.setObject(name, forKey:"fullname")
        }
        
        /* Gender */
        if let gender = Profile.sharedInstance.gender{
            currentUser?.setObject(gender, forKey:"gender")
            
        }
        
        /* birthday */
        if let birthday = Profile.sharedInstance.birthDay{
            currentUser?.setObject(birthday, forKey:"dateofbirth")
            
        }
        
        /* nickname */
        if let nickname = Profile.sharedInstance.nickname{
            currentUser?.setObject(nickname, forKey:"nickname")
            
        }
        
        /* country */
        if let country = Profile.sharedInstance.nationality{
            currentUser?.setObject(country, forKey:"nationality")
            
        }
        
        /* phone */
        if let phone = Profile.sharedInstance.phoneNumber{
            currentUser?.setObject(phone, forKey:"phonenumber")
            
        }
        
        /* job */
        if let job = Profile.sharedInstance.job{
            currentUser?.setObject(job, forKey:"job")
            
        }
        
        PFUser.currentUser()!.saveInBackgroundWithBlock { (sucess, error) -> Void in
            if (error == nil){
                self.showDialog("Success", message: "Your profile has been saved.")
            }else {
                self.showDialog("Error", message: "Please try again!")
            }
            
            self.hideHUDProgressAfter(0)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingProfileCurentUser()
        setup()
        configure()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadingProfileCurentUser(){
        showHUDProgress()
        
        if ((PFUser.currentUser()) == nil){
            /* back to login page */
            
        }else {
            let currentUser = PFUser.currentUser()
            
            /* avatar */
            if let imageFile = currentUser?.objectForKey("facebookProfilePicture"){
                
                let imageURL = NSURL(string: imageFile.url!!)
                let sd_web_mamanger = SDWebImageManager.sharedManager()
                sd_web_mamanger.downloadWithURL(imageURL, options: SDWebImageOptions.RetryFailed, progress: { (receivedSize, expectedSize) -> Void in
                    //Progress Here
                    }, completed: { (image, error, SDImageCache:SDImageCacheType, finished:Bool) -> Void in
                        // Do something with image downloaded
                        if (error == nil){
                            Profile.sharedInstance.image = image
                            self.imageRow.cellUpdate {
                                $0.iconView.image = image
                            }

                        }
                })
                
            }else {
                Profile.sharedInstance.image = UIImage(named: "default_avatar@2x.png")
            }
            
            /* self-introduction */
            if let introduction = currentUser?.objectForKey("introduction") {
                Profile.sharedInstance.introduction = introduction as? String
            }
            
            /* Name */
            if let name = currentUser?.objectForKey("fullname"){
                Profile.sharedInstance.name = name as? String
                
            }
            
            /* Gender */
            if let gender = currentUser?.objectForKey("gender"){
                Profile.sharedInstance.gender = gender as? String
                
            }
            
            /* birthday */
            if let birthday = currentUser?.objectForKey("dateofbirth"){
                Profile.sharedInstance.birthDay = birthday as? NSDate
                
            }
            
            /* nickname */
            if let nickname = currentUser?.objectForKey("nickname"){
                Profile.sharedInstance.nickname = nickname as? String
                
            }
            
            /* country */
            if let country = currentUser?.objectForKey("nationality"){
                Profile.sharedInstance.nationality = country as? String
                
            }
            
            /* phone */
            if let phone = currentUser?.objectForKey("phonenumber"){
                Profile.sharedInstance.phoneNumber = phone as? String
                
            }
            
            /* job */
            if let job = currentUser?.objectForKey("job"){
                Profile.sharedInstance.job = job as? String
                
            }
            
            
        }
        hideHUDProgress()
    }
    
    internal let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .Grouped)
        tableView.backgroundColor = .clearColor()
        tableView.contentInset.bottom = 10
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    internal lazy var former: Former = Former(tableView: self.tableView)
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    private lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.image = Profile.sharedInstance.image
            }.configure {
                $0.text = "Choose profile image from library"
                $0.rowHeight = 200
            }.onSelected { [weak self] _ in
                self?.former.deselect(true)
                self?.presentImagePicker()
        }
    }()
    
    private lazy var informationSection: SectionFormer = {
        let nicknameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Nickname"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your nickname"
                $0.text = Profile.sharedInstance.nickname
            }.onTextChanged {
                Profile.sharedInstance.nickname = $0
        }
        let locationRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Country"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your country"
                $0.text = Profile.sharedInstance.nationality
            }.onTextChanged {
                Profile.sharedInstance.nationality = $0
        }
        let phoneRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.keyboardType = .PhonePad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your phone number"
                $0.text = Profile.sharedInstance.phoneNumber
            }.onTextChanged {
                Profile.sharedInstance.phoneNumber = $0
        }
        let jobRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Job"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your job"
                $0.text = Profile.sharedInstance.job
            }.onTextChanged {
                Profile.sharedInstance.job = $0
        }
        return SectionFormer(rowFormer: nicknameRow, locationRow, phoneRow, jobRow)
    }()
    
    
    private func configure() {
        title = "Edit Profile"
        tableView.contentInset.top = 0
        tableView.contentInset.bottom = 0
        
        // Create RowFomers
        
        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your name"
                $0.text = Profile.sharedInstance.name
            }.onTextChanged {
                Profile.sharedInstance.name = $0
        }
        let genderRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Gender"
            }.configure {
                let genders = ["Male", "Female", "LGBT"]
                $0.pickerItems = genders.map {
                    InlinePickerItem(title: $0)
                }
                if let gender = Profile.sharedInstance.gender {
                    $0.selectedRow = genders.indexOf(gender) ?? 0
                }
            }.onValueChanged {
                Profile.sharedInstance.gender = $0.title
        }
        let birthdayRow = InlineDatePickerRowFormer<ProfileLabelCell>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Birthday"
            }.configure {
                $0.date = Profile.sharedInstance.birthDay ?? NSDate()
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .Date
            }.displayTextFromDate {
                return String.mediumDateNoTime($0)
            }.onDateChanged {
                Profile.sharedInstance.birthDay = $0
        }
        let introductionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFontOfSize(15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your self-introduction"
                $0.text = Profile.sharedInstance.introduction
            }.onTextChanged {
                Profile.sharedInstance.introduction = $0
        }
        let moreRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Add more information ?"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFontOfSize(15)
            $0.switchButton.onTintColor = .formerSubColor()
            }.configure {
                $0.switched = Profile.sharedInstance.moreInformation
                $0.switchWhenSelected = true
            }.onSwitchChanged { [weak self] in
                Profile.sharedInstance.moreInformation = $0
                self?.switchInfomationSection()
        }
        
        // Create Headers
        
        let createHeader: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        
        let imageSection = SectionFormer(rowFormer: imageRow)
            .set(headerViewFormer: nil)
        let introductionSection = SectionFormer(rowFormer: introductionRow)
            .set(headerViewFormer: createHeader("Introduction"))
        let aboutSection = SectionFormer(rowFormer: nameRow, genderRow, birthdayRow)
            .set(headerViewFormer: createHeader("About"))
        let moreSection = SectionFormer(rowFormer: moreRow)
            .set(headerViewFormer: createHeader("More Infomation"))
        
        former.append(sectionFormer: imageSection, introductionSection, aboutSection, moreSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        if Profile.sharedInstance.moreInformation {
            former.append(sectionFormer: informationSection)
        }
    }
    
    // MARK: Private
    
    private final func setup() {
        view.backgroundColor = .groupTableViewBackgroundColor()
        view.insertSubview(tableView, atIndex: 0)
        let tableConstraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[table]-0-|",
                options: [],
                metrics: nil,
                views: ["table": tableView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[table]-0-|",
                options: [],
                metrics: nil,
                views: ["table": tableView]
            )
            ].flatMap { $0 }
        view.addConstraints(tableConstraints)
    }
    
    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = false
        presentViewController(picker, animated: true, completion: nil)
    }
    
    private func switchInfomationSection() {
        if Profile.sharedInstance.moreInformation {
            former.insertUpdate(sectionFormer: informationSection, toSection: former.numberOfSections, rowAnimation: .Top)
        } else {
            former.removeUpdate(sectionFormer: informationSection, rowAnimation: .Top)
        }
    }
}


extension ZCCEditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        Profile.sharedInstance.image = image
        imageRow.cellUpdate {
            $0.iconView.image = image
            self.isOtherAvatar = true
        }
    }
}

