//
//  ZCCMakeTripStepOneViewController.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/1/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import THCalendarDatePicker

class ZCCMakeTripStepOneViewController: ZCCViewController,ZCCCititesViewControllerDelegate,THDatePickerDelegate {
    
    enum calendarType {
        case Arrival
        case Depart
    }
    
    var calendarPickerType:calendarType?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnContinue: ZCCButton!
    @IBOutlet weak var imgBackground: UIImageView!
    
    var curDate : NSDate? = NSDate()
    lazy var formatter: NSDateFormatter = {
        var tmpFormatter = NSDateFormatter()
        tmpFormatter.dateFormat = "dd/MM/yyyy"
        return tmpFormatter
    }()
    lazy var datePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker.delegate = self
        picker.date = self.curDate
        picker.setAllowClearDate(false)
        picker.setClearAsToday(false)
        picker.setAutoCloseOnSelectDate(true)
        picker.setAllowSelectionOfSelectedDate(true)
        picker.setDisableYearSwitch(true)
        //picker.setDisableFutureSelection(false)
        picker.setDaysInHistorySelection(1)
        picker.setDaysInFutureSelection(0)
        picker.setDateTimeZoneWithName("UTC")
        picker.autoCloseCancelDelay = 5.0
        picker.rounded = true
        picker.dateTitle = "Calendar"
        picker.selectedBackgroundColor = colorYellow
        picker.currentDateColor = colorYellow
        picker.currentDateColorSelected = UIColor.whiteColor()
        return picker
    }()
    
    /* Data  */
    var cityPicked:City?
    var dateArrival:NSDate?
    var dateDepart:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        /* Tableview layout */
        self.tableView.registerNib(UINib(nibName: "ZCCPickCityTableViewCell", bundle: nil), forCellReuseIdentifier: "ZCCPickCityTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ZCCMoneySliderTableViewCell", bundle: nil), forCellReuseIdentifier: "ZCCMoneySliderTableViewCell")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnContinueTapped(sender: AnyObject) {
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: THDatePickerDelegate
    
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
        curDate = datePicker.date
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: NSDate!) {
        print("Date selected: ", formatter.stringFromDate(selectedDate))
        if (self.calendarPickerType == .Arrival){
            dateArrival = selectedDate
        }else{
            dateDepart = selectedDate
        }
        
//        if (self.dateDepart < self.dateArrival){
//            self.showDialog("Error",message:"Please a depart date after arrival date")
//            return
//        }
        
        self.tableView.reloadData()
    }
    
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let value = Unmanaged<CFStringRef>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFStringRef
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    

    // MARK: TableViewDelegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        if (indexPath.section == 3){
            let cellMoney = tableView.dequeueReusableCellWithIdentifier("ZCCMoneySliderTableViewCell", forIndexPath: indexPath) as! ZCCMoneySliderTableViewCell
            cellMoney.selectionStyle = .None
            cellMoney.lblPickLocation.text = "Chọn số tiền"
            cellMoney.setIcon(UIImage(named: "budget@2x.png")!)
            
            return cellMoney
  
        }else{
            
            let cell : ZCCPickCityTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ZCCPickCityTableViewCell", forIndexPath: indexPath) as! ZCCPickCityTableViewCell
            cell.selectionStyle = .None
            
            
            switch (indexPath.section) {
            case 0:
                cell.lblPickLocation.text = "Chọn nơi đến"
                cell.lblValueLocationPicked.text = self.cityPicked?.name
                cell.setIcon(UIImage(named: "destination@2x.png")!)
                break
            case 1:
                cell.lblPickLocation.text = "Chọn ngày đi"
                if let dateArrival = self.dateArrival{
                    cell.lblValueLocationPicked.text = formatter.stringFromDate(dateArrival)
                }
                cell.setIcon(UIImage(named: "time@2x.png")!)
                break
            case 2:
                cell.lblPickLocation.text = "Chọn ngày về"
                if let dateDepart = self.dateDepart{
                    cell.lblValueLocationPicked.text = formatter.stringFromDate(dateDepart)
                }

                cell.setIcon(UIImage(named: "time@2x.png")!)
                break
            default:
                break
            }
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section) {
        case 0:
            /* Pick City */
            let citiesVC = self.storyboard?.instantiateViewControllerWithIdentifier("ZCCCititesViewController") as! ZCCCititesViewController
            citiesVC.citiesType = .Picker
            citiesVC.delegate = self
            self.navigationController?.pushViewController(citiesVC, animated: true)
            break
        case 1:
            self.calendarPickerType = .Arrival
            datePicker.date = self.curDate
            presentSemiViewController(datePicker, withOptions: [
                convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.1 as Float,
                convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 0.5 as Float,
                convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
                ])
            
            break
        case 2:
            /* Pick Date */
            self.calendarPickerType = .Depart
            datePicker.date = self.curDate
            presentSemiViewController(datePicker, withOptions: [
                convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.1 as Float,
                convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 0.5 as Float,
                convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
                ])

            break
        case 3:
            /* Pick Budget */
            
            break
            
        default:
            break
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return ZCCPickCityTableViewCell.heightOfCell()
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 0; // space b/w cells
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10; // space b/w cells
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clearColor()
        return header
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.clearColor()
        return footer
    }
    
    // MARK: Cities Delegate
    func pickCity(city:City){
        self.cityPicked = city
        
        if let imageUrl = city.cityImage{
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                
            }
            
            let url = NSURL(string: imageUrl)
            
            self.imgBackground.sd_setImageWithURL(url,placeholderImage: UIImage(named: "fuot@2x.png") ,completed: block)
            
        }

        self.tableView.reloadData()
    }
    
}
