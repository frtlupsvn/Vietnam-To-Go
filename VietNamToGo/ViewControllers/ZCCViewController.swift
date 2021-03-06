//
//  ZCCViewController.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/20/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit
import UNAlertView
import Parse
import ParseFacebookUtilsV4

let colorYellow = UIColor(netHex:0xf39c12)
let colorBlue = UIColor(netHex:0x2c3e50)

class ZCCViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pushToViewController(identifier: String) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as! ZCCViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getProfPic(fid: String) -> NSData? {
        if (fid != "") {
            let imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
            let imgURL = NSURL(string: imgURLString)
            let imageData = NSData(contentsOfURL: imgURL!)
            return imageData
        }
        return nil
    }

    
    func loginViaFacebook(){
        
        self.showHUDProgress()
        
        if ((PFUser.currentUser()) != nil){
            self.passeAuthentication()
        }else{
            let permissions = ["public_profile"]
            
            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
                (user: PFUser?, error: NSError?) -> Void in
                if let user = user {
                    if user.isNew {
                        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name,email,picture"])
                        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                            if ((error) != nil){
                                
                            } else {
                                let userFullName = result.valueForKey("name") as? String
                                let userEmail = result.valueForKey("email") as? String
                                
                                let facebookId = result.valueForKey("id") as? String
                                let imageFile = PFFile(name: "profileImage.png", data: self.getProfPic(facebookId!)!)
                                
                                // Here I try to add the retrieved Facebook data to the PFUser object
                                user["fullname"] = userFullName
                                user.email = userEmail
                                user["facebookProfilePicture"] = imageFile
                                
                                user.saveInBackgroundWithBlock({ (boolValue, error) -> Void in
                                    self.passeAuthentication()
                                })
                                
                            }
                        })
                    } else {
                        print("User logged in through Facebook!")
                        self.passeAuthentication()
                        
                    }
                } else {
                    print("Uh oh. The user cancelled the Facebook login.")
                }
            }
            
        }

    }
    
    func passeAuthentication(){
        let appdelegate:AppDelegate = ZCCHelper.appDelegate()
        
        // get your storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        // instantiate your desired ViewController
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("ZCCTabbarController") as! YALFoldingTabBarController
        self.setupTabbar(tabBarController)
        
        
        
        
        // Because self.window is an optional you should check it's value first and assign your rootViewController
        if let window = appdelegate.window {
            window.rootViewController = tabBarController
        }
        
        self.hideHUDProgress()
        
    }
    
    func setupTabbar(tabBarController:YALFoldingTabBarController){
        // Prepare leftBarItems
        let feedItem = YALTabBarItem(itemImage:UIImage(named: "feed") ,leftItemImage:UIImage(named: "edit_icon"), rightItemImage:nil)
        let makeTripItem = YALTabBarItem(itemImage:UIImage(named: "edit_icon") ,leftItemImage:nil, rightItemImage:nil)
        tabBarController.leftBarItems = [feedItem,makeTripItem]
        
        
        // Prepare center
        tabBarController.centerButtonImage = UIImage(named:"plus_icon")
        
        // Prepare rightBarItems
        let activityItem = YALTabBarItem(itemImage:UIImage(named: "activity") ,leftItemImage:UIImage(named: "edit_icon"), rightItemImage:nil)
        let profileItem = YALTabBarItem(itemImage:UIImage(named: "profile_icon") ,leftItemImage:UIImage(named: "edit_icon"), rightItemImage:nil)
        let settingsItem = YALTabBarItem(itemImage:UIImage(named: "settings_icon") ,leftItemImage:UIImage(named: "edit_icon"), rightItemImage:nil)
        tabBarController.rightBarItems = [profileItem,settingsItem]

        
        
        //Customize TabbarView
        tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
        tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        tabBarController.tabBarView.backgroundColor = UIColor.clearColor()
        tabBarController.tabBarView.tabBarColor = colorYellow
        tabBarController.tabBarView.dotColor = UIColor(netHex:0xFFFFFF)
        
        tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight
        tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
    }
    

    @IBAction func goBtnTapped(sender: AnyObject) {
        self.passeAuthentication()
    }
    
    @IBAction func btnLoginFacebookTapped(sender: AnyObject) {
        self.loginViaFacebook()
    }
    
    func showDialog(title:String,message:String){
        let alertView = UNAlertView(title: title, message: message)
        
        alertView.addButton("Close",
            backgroundColor: UIColor.orangeColor(),
            fontColor: UIColor.whiteColor(),
            action: {
                
                print("Some Action")
        })
        
        
        // Show
        alertView.show()
    }
    
    
    func showHUDProgress(){
       SVProgressHUD.show()
    }
    
    func showHUDProgressWithStatus(status:NSString){
        SVProgressHUD.showWithStatus(status as String)
    }
    
    func hideHUDProgress(){
        SVProgressHUD.dismiss()
    }
    
    func hideHUDProgressAfter(time:NSTimeInterval){
        SVProgressHUD.dismissWithDelay(time)
    }
    
    func showProgres(progress:Float,status:NSString){
        SVProgressHUD.showProgress(progress, status: status as String)
    }
    
}
