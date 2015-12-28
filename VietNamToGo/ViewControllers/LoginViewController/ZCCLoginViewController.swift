//
//  ZCCLoginViewController.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/24/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit
import Parse
import UNAlertView

class ZCCLoginViewController: ZCCViewController {
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var fieldsView: UIView!
    
    @IBOutlet weak var fieldEmail: ZCCTextField!
    @IBOutlet weak var fieldPassword: ZCCTextField!
    
    var imageBG : UIImage!
    var blurView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(animated: Bool) {
        
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
    
    func loginToParse(username:String,password:String){
        
        self.showHUDProgress()

        PFUser.logInWithUsernameInBackground(username, password: password) {(user, error:NSError?) -> Void in
            if (error == nil) {
                //Login Sucess
                self.passeAuthentication()
                
            }else {
                let alertView = UNAlertView(title: "Login failed", message: "Your email or password was entered incorrectly")
                
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

    @IBAction func btnBackTapped(sender: AnyObject) {
        self.fieldsView.hidden = true
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            self.blurView.effect = nil
            self.imgBackground.transform = CGAffineTransformMakeScale(1, 1)
            }) { (isComplettion) -> Void in
                self.navigationController?.popViewControllerAnimated(false)
        }
    }
    
    @IBAction func btnLoginTapped(sender: AnyObject) {
        if (!ZCCHelper.isValidEmail((self.fieldEmail.text)!)){
            return
        }
        if (self.fieldPassword.text!.characters.count < 6){
            return
        }
        
        loginToParse(self.fieldEmail.text!, password: self.fieldPassword.text!)
    }

}
