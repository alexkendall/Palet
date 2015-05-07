//
//  saved_data_controller.swift
//  Color_Generator
//
//  Created by Alex Harrison on 5/5/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//
var saved_colors = Array<CustomColor>();

import Foundation
import UIKit

class SavedColorsController: UIViewController, UITableViewDelegate
{
    var table_view = UITableView();
    var background = UIView();
    var superview = UIView();
    var saved_colors = [CustomColor(in_red: 0, in_green: 0, in_blue: 1)];
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        superview = self.view;
        superview.backgroundColor = UIColor.whiteColor();
        add_subview(table_view, superview, 0.8, 0.8, 1.0);
        
        // configure table view
        table_view.delegate = self;
        table_view.dataSource = app_data;
        table_view.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell");
        table_view.separatorStyle = UITableViewCellSeparatorStyle.None;
        table_view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5);
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        current_color = CustomColor(color: app_data.favorites[indexPath.row]);
        self.view.removeFromSuperview();
        // go directly to Color Picker
        var parent:MainController = parentViewController as! MainController;
        parent.bringUpColorPicker();
    }
}