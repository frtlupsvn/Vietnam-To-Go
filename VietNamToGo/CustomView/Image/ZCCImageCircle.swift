//
//  ZCCImageCircle.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/25/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit

class ZCCImageCircle: UIImageView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }
    
}
