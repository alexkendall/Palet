//
//  myTableView.swift
//  Color_Generator
//
//  Created by Alex Harrison on 5/10/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import Foundation
import UIKit

class myTableViewCell:UITableViewCell
{
    var originalCenter = CGPoint();
    var deleteOnDragRelease = false;
    var delete_button = UIButton();
    
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
        }
        
        if(recognizer.state == UIGestureRecognizerState.Ended)
        {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height);
            UIView.animateWithDuration(0.025, animations: {self.frame = originalFrame})
        }
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


class FavoriteTableViewCell:UITableViewCell
{
    var originalCenter = CGPoint();
    var deleteOnDragRelease = false;
    var rgb_label = UILabel();
    var hex_label = UILabel();
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
            UIView.animateWithDuration(0.025, animations: {self.frame = originalFrame})
        }
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
    
    func set_info(var hex_string:String, var rgb_string:String, var custom_color:CustomColor, var row:Int)
    {
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
        hex_label.setTranslatesAutoresizingMaskIntoConstraints(false);
        hex_label.text = hex_string;
        hex_label.font = UIFont.systemFontOfSize(14.0);
        self.addSubview(hex_label);
        var centerx_const = cell_margin;
        var center_hex = NSLayoutConstraint(item: hex_label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: cell_margin * 2.0);
        var center_y = NSLayoutConstraint(item: hex_label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        self.addConstraint(center_hex);
        self.addConstraint(center_y);
        
        // configure rgb font to display
        var rgb_string:String = custom_color.rgb_str();
        self.addSubview(rgb_label);
        rgb_label.setTranslatesAutoresizingMaskIntoConstraints(false);
        rgb_label.text = rgb_string;
        rgb_label.font = UIFont.systemFontOfSize(14.0);
        self.addSubview(hex_label);
        var center_rgb = NSLayoutConstraint(item: rgb_label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -30.0);
        var center_yrgb = NSLayoutConstraint(item: rgb_label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        self.addConstraint(center_rgb);
        self.addConstraint(center_yrgb);
        self.selectionStyle = UITableViewCellSelectionStyle.None;
        
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
        // remove data source
        var index = favorites_data.colors.count - self.row - 1;
        favorites_data.colors.removeAtIndex(index);
        favorites_controller.table_view.reloadData();
        
        println("favorite color count is now " + String(favorites_data.colors.count));
    }
}


