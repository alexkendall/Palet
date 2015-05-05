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