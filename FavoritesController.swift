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

class FavoritesController: UIViewController, UITableViewDelegate
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
        add_subview(table_view, superview, margin, margin + toolbar_height, margin, margin);
        
        // configure table view
        table_view.delegate = self;
        table_view.dataSource = favorites_data;
        table_view.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell");
        table_view.separatorStyle = UITableViewCellSeparatorStyle.None;
        table_view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8);
        table_view.layer.borderWidth = 1.0;
        table_view.layer.borderColor = UIColor.blackColor().CGColor;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        current_color = CustomColor(color: favorites_data.colors[favorites_data.colors.count - indexPath.row - 1]); // LIFO STACK
        tabBarController?.selectedViewController = picker_controller;
        picker_controller.viewDidLoad();
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}