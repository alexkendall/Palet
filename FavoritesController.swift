//
//  saved_data_controller.swift
//  Color_Generator
//
//  Created by Alex Harrison on 5/5/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

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
        table_view.registerClass(FavoriteTableViewCell.self, forCellReuseIdentifier: "cell");
        table_view.separatorStyle = UITableViewCellSeparatorStyle.None;
        table_view.backgroundColor = UIColor.lightGrayColor();
        table_view.layer.borderWidth = 1.0;
        table_view.layer.borderColor = UIColor.blackColor().CGColor;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        current_color = getColor(indexPath.row, &favorites_data.colors);
        tabBarController?.selectedViewController = picker_controller;
        picker_controller.viewDidLoad();
        //picker_controller.notification_controller.set_text("Loaded " + current_color.hex_string + " From Favorites");
        //picker_controller.notification_controller.bring_up();
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}