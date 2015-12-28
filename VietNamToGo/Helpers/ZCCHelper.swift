//
//  ZCCHelper.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/25/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit

class ZCCHelper: NSObject {
    
    static func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    static func appDelegate () -> AppDelegate
    {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
}
