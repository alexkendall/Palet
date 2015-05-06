//
//  saved_data_controller.swift
//  Color_Generator
//
//  Created by Alex Harrison on 5/5/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import Foundation
import UIKit

class DataController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var table_view = UITableView();
    var saved_colors = Array<CustomColor>();
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // gets count to determine number of cells to create
        return self.saved_colors.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell;
        // set cell color to saved color
        cell.backgroundColor = self.saved_colors[(saved_colors.count-1) - indexPath.row].get_UIColor();
        cell.layer.borderWidth = 0.5;
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //println(String(format:"Selected color at row %i \n", indexPath.row));
        //saved_colors[(saved_colors.count-1) - indexPath.row].print();
        // data ordered in reverse order of stack
        var cell = tableView.cellForRowAtIndexPath(indexPath);
        // set current color to color from selected cell
    }
    
}