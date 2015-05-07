//
//  ViewController.swift
//  Color Creator
//
//  Created by Alex Harrison on 5/5/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//
import UIKit

class MainController: UIViewController
{
    var tool_bar = UIToolbar();
    var saved_controller = SavedColorsController();
    var color_controller = ColorController();
    var color_button = UIButton();
    var saved_button = UIButton();
    var super_view = UIView();
    var background_view = UIView();
    
    //-------------------------------------------------------------------------
    
    func bringUpColorPicker()
    {
        color_controller.viewDidLoad();
        self.view.addSubview(color_controller.view);
        ShowToolBar();
    }
    
    //-------------------------------------------------------------------------
    
    func bringUpSavedColors()
    {
        saved_controller.table_view.reloadData();
        self.view.addSubview(saved_controller.view);
        ShowToolBar();
    }
    
    //-------------------------------------------------------------------------
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.addChildViewController(color_controller);
        self.addChildViewController(saved_controller);
        super_view = self.view;
        super_view.backgroundColor = UIColor.lightGrayColor();
        add_subview(background_view, super_view, 1.0, 1.0, 1.0);
        // configure saved colors button
        saved_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        saved_button.setTitle("Saved Colors", forState: UIControlState.Normal);
        super_view.addSubview(saved_button);
        super_view.setNeedsLayout();
        super_view.layoutIfNeeded();
        var side_dist:CGFloat = super_view.bounds.size.width / 4.0;
        var center_x = NSLayoutConstraint(item: saved_button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: side_dist);
        var center_y = NSLayoutConstraint(item: saved_button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -50.0);
        super_view.addConstraint(center_x);
        super_view.addConstraint(center_y);
        saved_button.addTarget(self, action: "bringUpSavedColors", forControlEvents: UIControlEvents.TouchUpInside);
        
        // configure color picker button
        color_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        super_view.addSubview(color_button);
        color_button.setTitle("Pick Color", forState: UIControlState.Normal);
        super_view.setNeedsLayout();
        super_view.layoutIfNeeded();
        var color_center_x = NSLayoutConstraint(item: color_button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -side_dist);
        var color_center_y = NSLayoutConstraint(item: color_button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: saved_button, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant:0.0);
        super_view.addConstraint(color_center_x);
        super_view.addConstraint(color_center_y);
        color_button.addTarget(self, action: "bringUpColorPicker", forControlEvents: UIControlEvents.TouchUpInside);
        ShowToolBar();
    }
    
    func ShowToolBar()
    {
        // configure toolbar
        super_view.addSubview(tool_bar);
        tool_bar.backgroundColor = UIColor.whiteColor();
        tool_bar.setTranslatesAutoresizingMaskIntoConstraints(false);
        var centerx_tab = NSLayoutConstraint(item: tool_bar, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        var centery_tab = NSLayoutConstraint(item: tool_bar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0);
        var height_tab = NSLayoutConstraint(item: tool_bar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: tool_bar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -toolbar_height);
        var width_tab = NSLayoutConstraint(item: tool_bar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        super_view.addConstraint(centerx_tab);
        super_view.addConstraint(centery_tab);
        super_view.addConstraint(height_tab);
        super_view.addConstraint(width_tab);
        
        var buttons = Array<UIBarButtonItem>();
        var main_item = UIBarButtonItem();
        main_item.title = "Main";
        main_item.tintColor = UIColor.blackColor();
        buttons.append(main_item);
        
        
        var colorPicker_item = UIBarButtonItem();
        colorPicker_item.title = "Picker";
        colorPicker_item.tintColor = UIColor.blackColor();
        buttons.append(colorPicker_item);
        
        var savedColors_item = UIBarButtonItem();
        savedColors_item.title = "Colors";
        savedColors_item.tintColor = UIColor.blackColor();
        buttons.append(savedColors_item);
        
        
        tool_bar.setItems(buttons, animated: true);
         println(tool_bar.items?.count);
    }
    
    //-------------------------------------------------------------------------
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated);
    }
    
    //-------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------------------
}

class ViewController: MainController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //-------------------------------------------------------------------------
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated);
    }
    
    //-------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------------------
}

