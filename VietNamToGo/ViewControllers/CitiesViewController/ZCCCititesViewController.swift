//
//  ZCCCititesViewController.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/25/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit
import Parse
import PullToMakeFlight

class ZCCCititesViewController: ZCCViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: ZCCButton!
    
    var arrayCities:NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Btn layout
        self.btnFilter.drawBorder(colorYellow)
        
        

        self.tableView.registerNib(UINib(nibName: "ZCCCityTableViewCell", bundle: nil), forCellReuseIdentifier: "ZCCCityTableViewCell")
        
        tableView.addPullToRefresh(PullToMakeFlight(), action: { () -> () in
            //Async Data
            City.syncCityWithParse(){
                self.loadDataFromDBToView()
                self.tableView.endRefreshing()
            }
        })

        loadDataFromDBToView()
        
        //Async Data
        City.syncCityWithParse(){
            self.loadDataFromDBToView()
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        


    }
    
    @IBAction func btnFilterTapped(sender: AnyObject) {

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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : ZCCCityTableViewCell = tableView.dequeueReusableCellWithIdentifier("ZCCCityTableViewCell", forIndexPath: indexPath) as! ZCCCityTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let city = self.arrayCities[indexPath.section] as! City
        cell.loadData(city)
        
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.arrayCities.count // count of items
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
}
