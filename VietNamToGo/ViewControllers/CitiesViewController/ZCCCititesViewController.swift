//
//  ZCCCititesViewController.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/25/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit
import PullToMakeFlight

protocol ZCCCititesViewControllerDelegate:class {
    func pickCity(city:City)
}

class ZCCCititesViewController: ZCCViewController {

    var delegate:ZCCCititesViewControllerDelegate! = nil
    
    enum CitiesType {
        case Picker
        case List
    }
    
    var  citiesType:CitiesType?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: ZCCButton!
    
    let dropDown = DropDown()
    var arrayCities:NSMutableArray!
    var arrayCitiesSearch:NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* Button layout */
        self.btnFilter.drawBorder(colorYellow)
        
        
    
        /* Tableview layout */
        self.tableView.registerNib(UINib(nibName: "ZCCCityTableViewCell", bundle: nil), forCellReuseIdentifier: "ZCCCityTableViewCell")
        
        tableView.addPullToRefresh(PullToMakeFlight(), action: { () -> () in            
            /* get Cities and Types */
            CityType.syncCityTypeWithParse { () -> Void in
                City.syncCityWithParse(){
                    self.loadDataFromDBToView()
                    self.tableView.endRefreshing()
                }
            }
        })
        
        /* Data Prepare */
        loadDataFromDBToView()
        loadTypeToFilter()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTypeToFilter(){
        /* DropDown layout */
        let cityTypes = CityType.fetchAllCityType()
        let arrayTypeName = NSMutableArray()
        arrayTypeName.addObject("Tất Cả")
        if (cityTypes.count > 0){
            for var i = 0; i < cityTypes.count; i++ {
                let cityType = cityTypes[i] as! CityType
                arrayTypeName.addObject(cityType.nameCityType!)
            }
        }
        dropDown.dataSource = NSArray(array: arrayTypeName as [AnyObject], copyItems: true) as! [String]
        dropDown.selectionAction = { [unowned self] (index, item) in
            
            self.btnFilter.setTitle(item, forState: .Normal)
            if item == "Tất Cả"{
                self.loadDataFromDBToView()
            }else
                if let cityType = CityType.getCityTypeWithnameCityType(item) {
                    self.arrayCities = NSMutableArray(array: City.fetchCityWithType(cityType))
                    self.tableView.reloadData()
                }
            
        }
        
        self.dropDown.anchorView = self.btnFilter
        self.dropDown.bottomOffset = CGPoint(x: 0, y:btnFilter.bounds.height)
    }
    
    func loadDataFromDBToView(){
        self.btnFilter.setTitle("Filter", forState: .Normal)
        self.arrayCities = NSMutableArray(array: City.fetchAllCity())
        self.tableView.reloadData()
    }
    
    @IBAction func btnFilterTapped(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            dropDown.hide()
        }

    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SEGUE_PLACES"){
            var placesVC = segue.destinationViewController as? ZCCPlacesViewController
            placesVC?.city = sender as! City
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func searchDisplayController(controller: UISearchController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        // Do something here
        self.arrayCitiesSearch = NSMutableArray(array: City.fetchAllCity())
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.arrayCitiesSearch?.count ?? 0
        } else {
            return self.arrayCities?.count ?? 0
        }
    }
    
    // MARK: - Tableview Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : ZCCCityTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ZCCCityTableViewCell", forIndexPath: indexPath) as! ZCCCityTableViewCell
        var city:City?
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            city = self.arrayCitiesSearch[indexPath.section] as? City
        }else {
            city = self.arrayCities[indexPath.section] as? City
            
        }
        cell.loadData(city!)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.citiesType == .Picker){
            [self.delegate!.pickCity((self.arrayCities[indexPath.section] as? City)!)]
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            let city = self.arrayCities[indexPath.section]
            performSegueWithIdentifier("SEGUE_PLACES", sender: city)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return ZCCCityTableViewCell.heightOfCell()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 0; // space b/w cells
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.arrayCities.count-1{
            return 0
        }
        return 5; // space b/w cells
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

}
