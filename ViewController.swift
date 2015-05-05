//
//  ViewController.swift
//  Color Creator
//
//  Created by Alex Harrison on 5/5/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var current_color = UIColor.blackColor();
    var background = UIView();
    var super_view = UIView();
    var red_slider = UISlider();
    var green_slider = UISlider();
    var blue_slider = UISlider();
    var color_view = UIButton();
    var indicators = Array<UILabel>();
    var indicator_text = ["R","G","B"];
    var RGB = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()];
    var table_view = UITableView();
    var saved_colors = Array<UIColor>();
    
    func moved_slider(sender:UISlider!)
    {
        var max_val:CGFloat = 255.0;
        var red_val:CGFloat = CGFloat(red_slider.value) / max_val;
        var green_val:CGFloat = CGFloat(green_slider.value) / max_val;
        var blue_val:CGFloat = CGFloat(blue_slider.value) / max_val;
        current_color = UIColor(red: red_val, green: green_val, blue: blue_val, alpha: 1.0);
        color_view.backgroundColor = current_color;
    }
    func save_color(sender:UIButton!)
    {
        saved_colors.append(current_color);
        table_view.reloadData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super_view = self.view;
        add_subview(background, super_view, 1.0, 1.0, 1.0);
        background.backgroundColor = UIColor.whiteColor();
        
        var super_height:CGFloat = super_view.bounds.width;
        var super_width:CGFloat = super_view.bounds.height;
        var margin:CGFloat = 25.0;
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE COLOR VIEW IN RHS OF DEVICE
        //-------------------------------------------------------------------------------------------
        color_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        color_view.backgroundColor = current_color;
        color_view.layer.borderColor = UIColor.blackColor().CGColor;
        color_view.layer.borderWidth = 1.0;
        super_view.addSubview(color_view);
        var left = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: margin);
        var top = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: margin);
        var right = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -margin);
        var height = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Width, multiplier: 0.0, constant: margin * 3.0);
        // add constraints
        super_view.addConstraint(left);
        super_view.addConstraint(top);
        super_view.addConstraint(right);
        super_view.addConstraint(height);
        // add target to enable saving the color
        color_view.addTarget(self, action: "save_color:", forControlEvents: UIControlEvents.TouchUpInside);
        //-------------------------------------------------------------------------------------------
        // CONFIGURE LABELS IN RHS OF DEVICE
        //-------------------------------------------------------------------------------------------
        for(var i = 0; i < 3; ++i)
        {
            indicators.append(UILabel());
        }
        for(var i = 0; i < indicators.count; ++i)
        {
            indicators[i].setTranslatesAutoresizingMaskIntoConstraints(false);
            indicators[i].text = indicator_text[i];
            indicators[i].textColor = UIColor.blackColor();
            indicators[i].textAlignment = NSTextAlignment.Center;
            indicators[i].layer.backgroundColor = UIColor.whiteColor().CGColor;
            indicators[i].layer.borderWidth = 1.0;
            background.addSubview(indicators[i]);
            var baseline = margin + (1.5 * margin * CGFloat(i));
            var left = NSLayoutConstraint(item: indicators[i], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0);
            var right = NSLayoutConstraint(item: indicators[i], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: indicators[i], attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: margin);
            var top = NSLayoutConstraint(item: indicators[i], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:baseline);
            super_view.addConstraint(left);
            super_view.addConstraint(right);
            super_view.addConstraint(top);
        }
        //-------------------------------------------------------------------------------------------
        // CONFIGURE SLIDERS ON TOP LHS OF DEVICE
        //-------------------------------------------------------------------------------------------
        var sliders = [red_slider, green_slider, blue_slider];
        var width = (super_view.bounds.width / 2.0) - (margin * 3.0);
        for(var i = 0; i < sliders.count; ++i)
        {
            sliders[i].setTranslatesAutoresizingMaskIntoConstraints(false);
            background.addSubview(sliders[i]);
            sliders[i].minimumValue = 0.0;
            sliders[i].maximumValue = 255.0;    // RGB 0-256
            sliders[i].minimumTrackTintColor = RGB[i];
            sliders[i].maximumTrackTintColor = UIColor.blackColor();
            // add extra margin space on left side to put rgb labels to left of sliders
            var left = NSLayoutConstraint(item: sliders[i], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: indicators[i], attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: margin);
            var right = NSLayoutConstraint(item: sliders[i], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -margin);
            var center_y = NSLayoutConstraint(item: sliders[i], attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: indicators[i], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant:0.0);
            super_view.addConstraint(left);
            super_view.addConstraint(right);
            super_view.addConstraint(center_y);
            // add target when slider is adjusted and tag each -> r = 0, b = 1, g = 2
            sliders[i].tag = i;
            sliders[i].addTarget(self, action: "moved_slider:", forControlEvents: UIControlEvents.ValueChanged);
        }
        //-------------------------------------------------------------------------------------------
        // CONFIGURE TABLE VIEW
        //-------------------------------------------------------------------------------------------
        table_view.dataSource = self;
        table_view.delegate = self;
        table_view.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell");
        table_view.separatorStyle = UITableViewCellSeparatorStyle.None;
        table_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        background.addSubview(table_view);
        table_view.backgroundColor = UIColor.grayColor();
        var table_top = NSLayoutConstraint(item: table_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: indicators[indicators.count-1], attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:margin);
        var table_bottom = NSLayoutConstraint(item: table_view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -margin);
        var width_table = NSLayoutConstraint(item: table_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant:0.0);
        var table_centerx = NSLayoutConstraint(item: table_view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant:0.0);
        super_view.addConstraint(table_top);
        super_view.addConstraint(table_bottom);
        super_view.addConstraint(width_table);
        super_view.addConstraint(table_centerx);
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // gets count to determine number of cells to create
        return self.saved_colors.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell;
        cell.backgroundColor = self.saved_colors[indexPath.row];    // set cell color to saved color
        //var view = UIView();
        //view.backgroundColor = self.saved_colors[indexPath.row];
        //add_subview(view, cell, 1.0, 1.0, 1.0);
        return cell;
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("You clicked a cell");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

