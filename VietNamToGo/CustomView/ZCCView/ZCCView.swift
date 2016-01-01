//
//  ZCCView.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/2/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import UIKit

@IBDesignable

class ZCCView: UIView {

    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }


}
