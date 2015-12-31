//
//  ZCCDropDownViewController.swift
//  Fuot
//
//  Created by Zoom Nguyen on 12/31/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import UIKit

class ZCCDropDownViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView = UITableView()
        self.tableView.frame = self.view.frame
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "ZCCDropDownTableViewCell", bundle: nil), forCellReuseIdentifier: "ZCCDropDownTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : ZCCDropDownTableViewCell = tableView.dequeueReusableCellWithIdentifier("ZCCDropDownTableViewCell", forIndexPath: indexPath) as! ZCCDropDownTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.lblTitleCell.text = "hiii"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }


}
