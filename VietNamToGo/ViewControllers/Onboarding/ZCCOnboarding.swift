//
//  ZCCOnboarding.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/20/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class ZCCOnboarding: ZCCViewController {
    
    let timeChangeImage = 8.0
    
    var timer : NSTimer!
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var imgOnboarding: UIImageView!
    @IBOutlet weak var lblOnboarding: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var imgAvatarFacebook: UIImageView!
    @IBOutlet weak var lblWelcomeBack: UILabel!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var facebookView: UIView!
    
    // MARK: - IB Actions
    @IBAction func swipeToRight(sender: UISwipeGestureRecognizer) {
        
        changeImageWhenSwipeToRight(ofImageView: imgOnboarding, pageControl: pageControl, arrayImages: arrayImagesOnboarding)
        self.resetTimer()
    }

    
    @IBAction func swipeToLeft(sender: UISwipeGestureRecognizer) {
        changeImageWhenSwipeToLeft(ofImageView: imgOnboarding, pageControl: pageControl, arrayImages: arrayImagesOnboarding)
        self.resetTimer()
    }
    
    
    // MARK: - View Cycle
    
    let arrayImagesOnboarding = ["vietnam1@2x.png","vietnam2@2x.png","vietnam3@2x.png","vietnam4@2x.png","vietnam5@2x.png"]
    let arrayDescriptions = ["Despite being a quick 45-minute turboprop flight from Ho Chi Minh City, Con Son is a world away from Vietnam’s well-beaten tourist trail, with inexplicably few Western travellers.",
                             "A product of Vietnam’s colonial past, the beloved concoction combines a crunchy French baguette with pork, pate and an ever-changing array of fresh vegetables.",
                             "The Dong Van district’s Hmong villages and spectacular peaks remain so isolated, foreign tourists are all but unknown.",
    "Donita Richards is planning to take her children, 3½ and 1½, to Vietnam next February and wants to know what to do and what to avoid. Our Facebook fans weighed in with travel advice.",
    "Ho Chi Minh City – once the Saigon of French diplomats, English writers and American soldiers – is now in its own role as the powerhouse of Vietnam."];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupContent()
        self.checkLogin()
        self.loadData()
        
        
    }
    
    func loadData(){
        self.showProgres(0,status: "Cập nhật dữ liệu")
        /* get Cities and Types */
        CityType.syncCityTypeWithParse { () -> Void in
            self.showProgres(0.5,status: "Xin vui lòng đợi trong giây lát")
            City.syncCityWithParse(){
                self.showProgres(1,status: "Hoàn thành !")
                self.hideHUDProgressAfter(0.5)
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeChangeImage, target: self, selector: "nextImageAutomatic", userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer.invalidate()
        self.timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    func setupContent(){
        
        pageControl.numberOfPages = arrayImagesOnboarding.count
        let image = UIImage(named: arrayImagesOnboarding[pageControl.currentPage] )
        imgOnboarding.image = image
        lblOnboarding.text = arrayDescriptions[pageControl.currentPage]
    }
    
    func checkLogin(){
        
        if ((PFUser.currentUser()) == nil){
            self.loginView.hidden = false
        }else {
            updateFacebookStatus()
        }

    }
    
    func updateFacebookStatus(){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let currentUser = PFUser.currentUser()
            
            if let imageFile = currentUser?.objectForKey("facebookProfilePicture"){
                let imageURL = NSURL(string: imageFile.url!!)
                let imageData = NSData(contentsOfURL: imageURL!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    if (imageData != nil){
                        self.imgAvatarFacebook.image = UIImage(data: imageData!)
                    }
                }

            }
            
            if let usernameString = currentUser?.objectForKey("fullname"){
                dispatch_async(dispatch_get_main_queue()) {
                    self.lblWelcomeBack.text = "Hi " + (usernameString as! String) as? String
                }
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    self.lblWelcomeBack.text = "Hi " + ((currentUser?.objectForKey("email"))! as! String) as? String
                }
            }
            
        }
        self.imgAvatarFacebook.image = UIImage(named: "default_avatar@2x.png")
        self.facebookView.hidden = false
    }

    
    func resetTimer(){
        self.timer.invalidate()
        self.timer = nil
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeChangeImage, target: self, selector: "nextImageAutomatic", userInfo: nil, repeats: true)
        
    }
    
    func nextImageAutomatic(){
       changeImageWhenSwipeToLeft(ofImageView: imgOnboarding, pageControl: pageControl, arrayImages: arrayImagesOnboarding)
    }
    
    func changeText(){
        lblOnboarding.text = arrayDescriptions[pageControl.currentPage]
    }
    
    func changeImageWhenSwipeToRight(ofImageView imageView:UIImageView, pageControl:UIPageControl, arrayImages:NSArray){
        var nextIndex:Int?
        
        if (pageControl.currentPage == 0){
            nextIndex = arrayImages.count - 1
        }else {
            nextIndex = pageControl.currentPage - 1
        }
        
        pageControl.currentPage = nextIndex!
        
        let image = UIImage(named: arrayImages[nextIndex!] as! String)
    
        UIView .transitionWithView(imageView, duration: 0.8, options: .TransitionCrossDissolve, animations: { () -> Void in
                imageView.image = image
            }, completion: nil)
        
        changeText()

    }
    
    func changeImageWhenSwipeToLeft(ofImageView imageView:UIImageView, pageControl:UIPageControl, arrayImages:NSArray){
        
        var nextIndex:Int?
        
        if (pageControl.currentPage == arrayImages.count - 1){
            nextIndex = 0
        }else {
            nextIndex = pageControl.currentPage + 1
        }
        
        pageControl.currentPage = nextIndex!
        
        let image = UIImage(named: arrayImages[nextIndex!] as! String)
        
        UIView .transitionWithView(imageView, duration: 0.8, options: .TransitionCrossDissolve, animations: { () -> Void in
            imageView.image = image
            }, completion: nil)
        
        changeText()
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "Segue_Login"){
            let loginVC = segue.destinationViewController as! ZCCLoginViewController
            loginVC.imageBG = self.imgOnboarding.image
            
        }
        if (segue.identifier == "Segue_Register"){
            let registerVC = segue.destinationViewController as! ZCCRegisterViewController
            registerVC.imageBG = self.imgOnboarding.image
            
        }
    }

    


}
