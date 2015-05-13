//
//  utility_functions.swift
//  Color Creator
//
//  Created by Alex Harrison on 5/5/15.
//  Copyright (c) 2015 dAlex Harrison. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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

// requires: nothing
// modifies: subview
// effects: centers subview to superview, sets height and width to height and width ratios of superview
func add_subview(var subview:UIView, var superview:UIView, var top_margin:CGFloat, var bottom_margin:CGFloat, var left_margin:CGFloat, var right_margin:CGFloat)
{
    subview.setTranslatesAutoresizingMaskIntoConstraints(false);
    
    // confogure constraints
    var left = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: left_margin);
    
    var right = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -right_margin);
    
    var top = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: top_margin);
    
    var bottom = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -bottom_margin);
    
    // configure hiearchy
    superview.addSubview(subview);
    
    // apply constraints
    superview.addConstraint(left);
    superview.addConstraint(right);
    superview.addConstraint(top);
    superview.addConstraint(bottom);
    
}

//-------------------------------------------------------------------------------------------------------------------------

func print(var cordinates:CGRect)
{
    println(String(format: "(x, y, width, height) = (%f, %f, %f, %f)", cordinates.origin.x, cordinates.origin.y, cordinates.width, cordinates.height));
}

//-------------------------------------------------------------------------------------------------------------------------

func get_color(var palette_index:Int, var color_index:Int)->CustomColor
{
    return CustomColor(color: palette_data.palettes[palette_index].colors[color_index]);
}

//-------------------------------------------------------------------------------------------------------------------------

func get_palette(var palette_index:Int)->Palette
{
    return palette_data.palettes[palette_index];
}

//------------------------------------------------------------------------------------------------------------------

// GETS COLOR CORESPONDING TO INDEX ROW, NOTE THIS FUNCTION HANDLES LIFO STACK ORIENTATION IN WHICH COLORS ARE STORED DONT USE THIS FOR PALETTE!!!
func getColor(var index:Int, inout array:Array<NSManagedObject>) ->CustomColor
{
    var color_data = array[array.count - 1 - index];  // STACK (LIFO)
    
    var red:Int = (color_data.valueForKey("red") as? Int)!;
    var green:Int = (color_data.valueForKey("green") as? Int)!;
    var blue:Int = (color_data.valueForKey("blue") as? Int)!;
    
    var color = CustomColor(in_red: red, in_green: green, in_blue: blue);
    return color;
}

//func getPaletteColor

//------------------------------------------------------------------------------------------------------------------

func InColorArray(var color:CustomColor, inout array:Array<NSManagedObject>)->Bool
{
    for(var i = 0; i < array.count; ++i)
    {
        var temp_color = getColor(i, &array);
        if(temp_color == color)
        {
            return true;
        }
    }
    return false;
}

//------------------------------------------------------------------------------------------------------------------

func InPaletteArray(var palette_name:String)->Bool
{
    for(var i = 0; i < saved_palettes.count; ++i)
    {
        /*
        var managed_object = saved_palettes[i];
        var name:String = managed_object.valueForKey("palette_name") as! String;
        */
        
        var name = getPaletteName(i);
        if(palette_name == name)
        {
            return true;
        }
    }
    return false;
}

//------------------------------------------------------------------------------------------------------------------

func saveColor(var color:CustomColor, inout array:Array<NSManagedObject>, var entityName:String, var p_name:String)
{
    var red:Int = color.red();
    var green:Int = color.green();
    var blue:Int = color.blue();
    
    // 1
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    let managedContext = appDelegate.managedObjectContext!;
    
    // 2
    let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedContext);
    let color_data = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext);
    
    // 3
    color_data.setValue(red, forKey: "red");
    color_data.setValue(green, forKey: "green");
    color_data.setValue(blue, forKey: "blue");
    color_data.setValue(p_name, forKey: "palette_name");
    
    //4
    var error:NSError?
    if !managedContext.save(&error)
    {
        println("ERROR SAVING FAVORITE COLOR");
    }
    //5
    array.append(color_data);
}

//------------------------------------------------------------------------------------------------------------------

func savePalette(var p_name:String, inout array:Array<NSManagedObject>)
{
    // 1
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    let managedContext = appDelegate.managedObjectContext!;
    
    // 2
    let entity = NSEntityDescription.entityForName("Palette", inManagedObjectContext: managedContext);
    let palette_data = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext);
    
    
    // 3
    palette_data.setValue(p_name, forKey: "palette_name");
    
    //4
    var error:NSError?
    if !managedContext.save(&error)
    {
        println("ERROR SAVING FAVORITE COLOR");
    }
    //5
    saved_palettes.append(palette_data);
}

//------------------------------------------------------------------------------------------------------------------

func getPaletteName(var index:Int)->String
{
    var managed_object = saved_palettes[index];
    var name:String = managed_object.valueForKey("palette_name") as! String;
    return name;
}



