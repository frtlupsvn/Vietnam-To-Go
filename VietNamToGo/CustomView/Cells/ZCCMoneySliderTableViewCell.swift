//
//  ZCCMoneySliderTableViewCell.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/2/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import UIKit

class ZCCMoneySliderTableViewCell: UITableViewCell {

    @IBOutlet weak var viewView: UIVisualEffectView!
    @IBOutlet weak var lblValueLocationPicked: UILabel!
    @IBOutlet weak var lblPickLocation: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    var money:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.viewView.layer.cornerRadius = self.viewView.frame.size.height/2
        self.viewView.layer.masksToBounds = true
        self.lblValueLocationPicked.text = String(money) + " vnd"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnPlusTapped(sender: AnyObject) {
        PlusMoney(100000)
        setMoneylabel()
    }
    @IBAction func btnMinusTapped(sender: AnyObject) {
        MinusMoney(100000)
        setMoneylabel()
    }
    @IBAction func btnPlusTappedRepeat(sender: AnyObject) {
        PlusMoney(500000)
        setMoneylabel()
    }
    @IBAction func btnMinusTappedRepeat(sender: AnyObject) {
        MinusMoney(500000)
        setMoneylabel()

    }
    
    func setMoneylabel(){
        self.lblValueLocationPicked.text = String(money.stringFormatedWithSepator) + " vnd"
    }
    
    func PlusMoney(distance:Int){
        if (money < 100000000) {
            money += distance
        }
    }
    func MinusMoney(distance:Int){
        if (money > 0) {
            money -= distance
        }
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
