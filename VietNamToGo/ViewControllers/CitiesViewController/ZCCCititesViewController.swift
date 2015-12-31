//
//  ZCCCititesViewController.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/25/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit
import PullToMakeFlight
import BTNavigationDropdownMenu

class ZCCCititesViewController: ZCCViewController {
    
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
            //Async Data
            City.syncCityWithParse(){
                self.loadDataFromDBToView()
                self.tableView.endRefreshing()
            }
        })
        
        /* Data Prepare */
        loadDataFromDBToView()
        
        City.syncCityWithParse(){
            self.loadDataFromDBToView()
        }
        
        CityType.syncCityTypeWithParse { () -> Void in
            /* DropDown layout */

            
            
            dropDown.dataSource = filterItems
            
            dropDown.selectionAction = { [unowned self] (index, item) in
                self.btnFilter.setTitle(item, forState: .Normal)
            }
            
            dropDown.anchorView = btnFilter
            dropDown.bottomOffset = CGPoint(x: 0, y:btnFilter.bounds.height)

        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataFromDBToView(){
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
