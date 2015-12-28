//
//  ZCCRegisterViewController.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/24/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit
import UNAlertView
import Parse
import ParseFacebookUtilsV4

class ZCCRegisterViewController: ZCCViewController {
    
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var fieldsView: UIView!
    
    @IBOutlet weak var fieldEmail: ZCCTextField!
    @IBOutlet weak var fieldPassword: ZCCTextField!
    @IBOutlet weak var fieldRetypePassword: ZCCTextField!
    
    
    var blurView = UIVisualEffectView()
    var imageBG : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fieldsView.hidden = true
        self.imgBackground.image = imageBG
        
        //Overlay Blur
        blurView = UIVisualEffectView()
        blurView.frame = self.imgBackground.frame
        self.imgBackground.addSubview(blurView)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.imgBackground.transform = CGAffineTransformMakeScale(1.1, 1.1)
            }) { (isComplettion) -> Void in
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.blurView.effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                    }) { (isComplettion) -> Void in
                        
                        self.fieldsView.hidden = false
                }
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackTapped(sender: AnyObject) {
        self.fieldsView.hidden = true
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            self.blurView.effect = nil
            self.imgBackground.transform = CGAffineTransformMakeScale(1, 1)
            }) { (isComplettion) -> Void in
                self.navigationController?.popViewControllerAnimated(false)
        }
    }
    
    @IBAction func btnRegisterTapped(sender: AnyObject) {
        
        if (!ZCCHelper.isValidEmail((self.fieldEmail.text)!)){
            return
        }
        if (self.fieldPassword.text!.characters.count < 6){
            return
        }
        if (self.fieldPassword.text != self.fieldRetypePassword.text){
            return
        }
        
        registerAccountToParse(self.fieldEmail.text!, password: self.fieldPassword.text!)
        
    }
    
    func registerAccountToParse(username:String,password:String){
        
        self.showHUDProgress()
        
        var user = PFUser()
        
        user.username = username
        user.password = password
        user.email = username
        
        user.signUpInBackgroundWithBlock { (succeded, error) -> Void in
            if (error == nil) {
                //Register Sucess
                self.passeAuthentication()
                
            }else {
                //Register Fail
                let alertView = UNAlertView(title: "Register failed", message: "Your email or password was entered incorrectly")
                
                alertView.addButton("Close",
                    backgroundColor: UIColor.orangeColor(),
                    fontColor: UIColor.whiteColor(),
                    action: {
                        
                        print("Some Action")
                })
                
                
                // Show
                alertView.show()
                
                self.hideHUDProgress()

                
            }
        }
        
    }
    


}
