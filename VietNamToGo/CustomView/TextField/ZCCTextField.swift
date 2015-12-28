//
//  ZCCTextField.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/24/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit

class ZCCTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 40/2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.orangeColor().CGColor
        
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

}
