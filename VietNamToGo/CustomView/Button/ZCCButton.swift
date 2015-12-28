//
//  ZCCButton.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/24/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit



class ZCCButton: UIButton {
    

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
    func drawBorder(color:UIColor){
        self.layer.borderWidth = 1
        self.layer.borderColor = color.CGColor
    }


}
