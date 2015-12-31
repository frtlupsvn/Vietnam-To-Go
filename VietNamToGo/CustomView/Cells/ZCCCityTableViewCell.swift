//
//  ZCCCityTableViewCell.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/25/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit

let heightOfCellCity = 400

class ZCCCityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgCity: UIImageView!
    
    @IBOutlet weak var lblNameCity: UILabel!
    @IBOutlet weak var lblShortDescription: UILabel!

    @IBOutlet weak var viewView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewView.layer.cornerRadius = 10
        self.viewView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func heightOfCell() -> CGFloat {
        return CGFloat(heightOfCellCity)
    }
    
    func loadData(city:City){
        
        self.lblNameCity.text = city.name?.uppercaseString
        self.lblShortDescription.text = city.cityShortDescription
        
        if let imageUrl = city.cityImage{
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                
            }
            
            let url = NSURL(string: imageUrl)
            
            self.imgCity.sd_setImageWithURL(url,placeholderImage: UIImage(named: "fuot@2x.png") ,completed: block)
            
        }

    }
        
}
