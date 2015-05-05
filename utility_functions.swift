//
//  utility_functions.swift
//  Color Creator
//
//  Created by Alex Harrison on 5/5/15.
//  Copyright (c) 2015 dAlex Harrison. All rights reserved.
//

import Foundation
import UIKit

//-------------------------------------------------------------------------------------------------------------------------

// requires: nothing
// modifies: subview
// effects: centers subview to superview, sets height and width to height and width ratios of superview
func add_subview(subview:UIView, superview:UIView, width_ratio:CGFloat, height_ratio: CGFloat, in_alpha:CGFloat)
{
    subview.setTranslatesAutoresizingMaskIntoConstraints(false);
    
    // confogure constraints
    var center_x = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
    
    var center_y = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
    
    var width = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Width, multiplier: width_ratio, constant: 0.0);
    
    var height = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Height, multiplier: height_ratio, constant: 0.0);
    
    // configure hiearchy
    superview.addSubview(subview);
    
    // apply constraints
    superview.addConstraint(center_x);
    superview.addConstraint(center_y);
    superview.addConstraint(width);
    superview.addConstraint(height);
    
    // set alpha value
    subview.alpha = in_alpha;
}

//-------------------------------------------------------------------------------------------------------------------------
// created gradient on background view
func configure_gradient(inout super_view:UIView, inout background:UIView, top_color:UIColor, bottom_color:UIColor)
{
    background.setTranslatesAutoresizingMaskIntoConstraints(false);
    
    // generate constraints for background
    var width = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
    
    var height = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
    
    var centerx = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
    
    var centery = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
    
    super_view.addSubview(background);
    super_view.addConstraint(width);
    super_view.addConstraint(height);
    super_view.addConstraint(centerx);
    super_view.addConstraint(centery);
    
    var test_loc = [0,1];
    var test_color = [top_color.CGColor, bottom_color.CGColor];
    
    var gradient = CAGradientLayer();
    gradient.frame = super_view.bounds;
    gradient.locations = test_loc;
    gradient.colors = test_color;
    gradient.startPoint = CGPoint(x: 0.5, y: 0.0);
    gradient.endPoint = CGPoint(x: 0.5, y: 1.0);
    background.layer.insertSublayer(gradient, atIndex: 0);
    
    super_view.addSubview(background);
    super_view.addConstraint(width);
    super_view.addConstraint(height);
    super_view.addConstraint(centerx);
    super_view.addConstraint(centery);
}

//-------------------------------------------------------------------------------------------------------------------------