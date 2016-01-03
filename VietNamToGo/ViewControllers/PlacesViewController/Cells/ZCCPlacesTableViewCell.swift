//
//  ZCCPlacesTableViewCell.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/3/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import UIKit

let heightOfCellPlaces = 100

class ZCCPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPlace: ZCCImageCircle!
    @IBOutlet weak var lblTitlePlace: UILabel!
    @IBOutlet weak var lblDescriptionPlace: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func heightOfCell() -> CGFloat {
        return CGFloat(heightOfCellPlaces)
    }
    
}
