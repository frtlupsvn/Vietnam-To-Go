//
//  ZCCPickCityTableViewCell.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/1/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import UIKit

let heightOfCellPickTrip = 70

class ZCCPickCityTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPickLocation: UILabel!
    @IBOutlet weak var lblValueLocationPicked: UILabel!
    @IBOutlet weak var viewView: UIVisualEffectView!
    @IBOutlet weak var imgIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.viewView.layer.cornerRadius = self.viewView.frame.size.height/2
        self.viewView.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadDataToCell(location:String){
        self.lblValueLocationPicked.text = location
    }
    
    func setIcon(image:UIImage){
        self.imgIcon.image = image
    }
    
    static func heightOfCell() -> CGFloat {
        return CGFloat(heightOfCellPickTrip)
    }
    
}
