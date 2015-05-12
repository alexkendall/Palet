//
//  myTableView.swift
//  Color_Generator
//
//  Created by Alex Harrison on 5/10/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import Foundation
import UIKit
import CoreData

 //------------------------------------------------------------------------------------------------
 // BEGIN MY TABLE VIEW CELL
 //------------------------------------------------------------------------------------------------

class myTableViewCell:UITableViewCell
{
    var originalCenter = CGPoint();
    var deleteOnDragRelease = false;
    var delete_button = UIButton();
    var row:Int = Int();
    
    func delete_cell()
    {
        // remove this palette from data soruce
        var index:Int = row; //palette_data.palettes.count - row - 1;
        palette_data.palettes.removeAtIndex(index);
        pallettes_controller.add_controler.palette_table.reloadData();
        picker_controller.pallete_window.palette_table.reloadData();
    }
    
    //------------------------------------------------------------------------------------------------
    
    func add_delete()
    {
        //println(self.row);
        var but_width = self.frame.size.height; // button width == button height == cell height
        var left_margin = self.frame.size.width - but_width;
        delete_button.backgroundColor = UIColor.redColor();
        delete_button.setTitle("DEL", forState: UIControlState.Normal);
        delete_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        delete_button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted);
        add_subview(delete_button, self, 0.0, 0.0, left_margin, 0.0);
        delete_button.addTarget(self, action: "delete_cell", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    //------------------------------------------------------------------------------------------------
    
    func remove_delete()
    {
        delete_button.removeFromSuperview();
    }
    
    //------------------------------------------------------------------------------------------------
    
    func pan_recognizer(recognizer:UIPanGestureRecognizer!)
    {
        if(recognizer.state == UIGestureRecognizerState.Began)
        {
            originalCenter = center;
        }
        
        if(recognizer.state == UIGestureRecognizerState.Changed)
        {
            let translation = recognizer.translationInView(self);
            
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
            if(frame.origin.x < -frame.size.width / 2.0)
            {
                add_delete();
            }
            if(frame.origin.x > 50.0)
            {
                remove_delete();
            }
        }
        
        if(recognizer.state == UIGestureRecognizerState.Ended)
        {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height);
            UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
        }
    }
    
      //------------------------------------------------------------------------------------------------
    
    // override this in order to enable vertical scrolling of view table
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer
        {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y)
            {
                return true;
            }
            return false;
        }
        return false;
    }
    
    //------------------------------------------------------------------------------------------------
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
 
        // add pan recognizer
        var recognizer = UIPanGestureRecognizer(target: self, action: "pan_recognizer:");
        recognizer.delegate = self;
        addGestureRecognizer(recognizer);
    }
    
    //------------------------------------------------------------------------------------------------

    required init(coder aDecoder: NSCoder)
    {
        fatalError("NSCoding not supported");
    }
    
    //------------------------------------------------------------------------------------------------
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    //------------------------------------------------------------------------------------------------

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated);
    }
    
    //------------------------------------------------------------------------------------------------
    
}

//------------------------------------------------------------------------------------------------
// END MY TABLE VIEW CELL
//------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------------
// BEGIN FAVORITE TABLE VIEW CELL
//------------------------------------------------------------------------------------------------
class FavoriteTableViewCell:UITableViewCell
{
    var originalCenter = CGPoint();
    var deleteOnDragRelease = false;
    var rgb_label = UIButton();
    var hex_display = UIButton();
    var color_view = UIView();
    var delete_button = UIButton();
    var row:Int = Int();
    
    //------------------------------------------------------------------------------------------------
    
    func pan_recognizer(recognizer:UIPanGestureRecognizer!)
    {
        if(recognizer.state == UIGestureRecognizerState.Began)
        {
            originalCenter = center;
        }
        
        if(recognizer.state == UIGestureRecognizerState.Changed)
        {
            let translation = recognizer.translationInView(self);
        
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
            if(frame.origin.x < -frame.size.width / 2.0)
            {
                add_delete();
            }
            if(frame.origin.x > 50.0)
            {
                remove_delete();
            }
        }
        
        if(recognizer.state == UIGestureRecognizerState.Ended)
        {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height);
            UIView.animateWithDuration(0.20, animations: {self.frame = originalFrame})
        }
    }
    
    // override this in order to enable vertical scrolling of view table
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer
        {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y)
            {
                return true;
            }
            return false;
        }
        return false;
    }
    
    //------------------------------------------------------------------------------------------------
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    
        // add pan recognizer
        var recognizer = UIPanGestureRecognizer(target: self, action: "pan_recognizer:");
        recognizer.delegate = self;
        addGestureRecognizer(recognizer);
        
    }
    
    //------------------------------------------------------------------------------------------------
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("NSCoding not supported");
    }
    
    //------------------------------------------------------------------------------------------------
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    //------------------------------------------------------------------------------------------------
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated);
    }
    
    //------------------------------------------------------------------------------------------------
    
    func set_info(var hex_string:String, var rgb_string:String, var custom_color:CustomColor, var in_row:Int)
    {
        self.row = in_row;
        var subs = self.subviews;
        for(var i = 0; i < subs.count; ++i)
        {
            subs[i].removeFromSuperview();
        }
        self.backgroundColor = UIColor.whiteColor();
        self.layer.borderWidth = 0.5;
        
        //-----------------------------------------------------------------------------
        
        // get cell height and width attributes
        self.setNeedsLayout();
        self.layoutIfNeeded();
        var cell_height:CGFloat = self.bounds.size.height;
        var cell_width:CGFloat = self.frame.size.width;
        
        // configure view that will hold color
        color_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        color_view.backgroundColor = custom_color.get_UIColor();
        color_view.layer.borderWidth = 0.5;
        var cell_margin:CGFloat = 5.0;
        var color_height = (cell_height - (2.0 * cell_margin));
        var color_width = color_height;
        
        // configure color constiants
        var color_left = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: cell_margin);
        
        var color_top = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: cell_margin);
        
        var color_bottom = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -cell_margin);
        
        var color_width_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        self.addSubview(color_view);
        self.addConstraint(color_left);
        self.addConstraint(color_top);
        self.addConstraint(color_bottom);
        self.addConstraint(color_width_constr);
        
        //-----------------------------------------------------------------------------
        
        // configure hex font to display
        var hex_string:String = custom_color.hex_string;
        hex_display.setTranslatesAutoresizingMaskIntoConstraints(false);
        hex_display.setTitle(hex_string, forState: UIControlState.Normal);
        hex_display.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        hex_display.titleLabel?.font = UIFont.systemFontOfSize(14.0);
        hex_display.tag = row;
        hex_display.addTarget(self, action: "load_color:", forControlEvents: UIControlEvents.TouchUpInside);
        
        
        var centerx_const = cell_margin;
        var left_hex = NSLayoutConstraint(item: hex_display, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: cell_margin * 2.0);
        var center_y = NSLayoutConstraint(item: hex_display, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        var height_hex = NSLayoutConstraint(item: hex_display, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        var width_hex = NSLayoutConstraint(item: hex_display, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.2, constant: 0.0);
        
        self.addSubview(hex_display);
        self.addConstraint(left_hex);
        self.addConstraint(center_y);
        self.addConstraint(height_hex);
        self.addConstraint(width_hex);
        
        // configure rgb font to display
        var rgb_string:String = custom_color.rgb_str();
        rgb_label.setTranslatesAutoresizingMaskIntoConstraints(false);
        rgb_label.setTitle(rgb_string, forState: UIControlState.Normal);
        rgb_label.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        rgb_label.titleLabel?.font = UIFont.systemFontOfSize(14.0);
        rgb_label.tag = row;
        rgb_label.addTarget(self, action: "load_color:", forControlEvents: UIControlEvents.TouchUpInside);
        
        
        var left_rgb = NSLayoutConstraint(item: rgb_label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: hex_display, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10.0);
        var center_yrgb = NSLayoutConstraint(item: rgb_label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        var height_rgb = NSLayoutConstraint(item: rgb_label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        var width_rgb = NSLayoutConstraint(item: rgb_label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: 0.0);
        
        self.addSubview(rgb_label);
        self.addConstraint(left_rgb);
        self.addConstraint(center_yrgb);
        self.addConstraint(height_rgb);
        self.addConstraint(width_rgb);
        self.selectionStyle = UITableViewCellSelectionStyle.None;
    }
    
    func load_color(sender:UIButton!)
    {
        var index = sender.tag;
        current_color = CustomColor(color: getColor(index));
        picker_controller.viewDidLoad();
        tab_controller.selectedViewController = picker_controller;
    }
    
    func add_delete()
    {
        var but_width = self.frame.size.height; // button width == button height == cell height
        var left_margin = self.frame.size.width - but_width;
        delete_button.backgroundColor = UIColor.redColor();
        delete_button.setTitle("DEL", forState: UIControlState.Normal);
        delete_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        delete_button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted);
        add_subview(delete_button, self, 0.0, 0.0, left_margin, 0.0);
        delete_button.addTarget(self, action: "delete_cell", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    func remove_delete()
    {
        delete_button.removeFromSuperview();
    }
    
    func delete_cell()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        let managedContext = appDelegate.managedObjectContext!;
        
        //  get object
        var index = favorites_data.colors.count - self.row - 1;
        var object:NSManagedObject = favorites_data.colors[index];
        
        // delete object
        favorites_data.colors.removeAtIndex(index);
        managedContext.deleteObject(object);
        favorites_controller.table_view.reloadData();
        
        // save context
        var error:NSError?;
        if !managedContext.save(&error)
        {
            println("Unable to delete favorite color");
        }
    }
}

//------------------------------------------------------------------------------------------------
// END FAVORITE TABLE VIEW CELL
//------------------------------------------------------------------------------------------------