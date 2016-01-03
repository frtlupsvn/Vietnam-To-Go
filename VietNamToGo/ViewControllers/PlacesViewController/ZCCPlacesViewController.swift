//
//  ZCCPlacesViewController.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/3/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import UIKit

class ZCCPlacesViewController: ZCCViewController {

    @IBOutlet weak var tableView: UITableView!
    var city:City?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = city?.name
        
        /* Tableview layout */
        self.tableView.registerNib(UINib(nibName: "ZCCPlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "ZCCPlacesTableViewCell")
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
        
        let placeCell:ZCCPlacesTableViewCell = tableView.dequeueReusableCellWithIdentifier("ZCCPlacesTableViewCell", forIndexPath: indexPath) as! ZCCPlacesTableViewCell
        
        return placeCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return ZCCPlacesTableViewCell.heightOfCell()
    }

}
