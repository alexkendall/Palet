
// file defining custom color class

import Foundation
import UIKit

class CustomColor:Equatable
{
    init()
    {
        set(0, in_green: 0, in_blue: 0);
        hex_string = "#000000";
    }
    //-------------------------------------------------------------------------
    init(var in_red:CGFloat, var in_green:CGFloat, var in_blue:CGFloat)
    {
        set(in_red, in_green: in_green, in_blue: in_blue);
    }
    //-------------------------------------------------------------------------
    init(var in_red:Int, var in_green:Int, var in_blue:Int)
    {
        set(in_red, in_green: in_green, in_blue: in_blue);
    }
    //-------------------------------------------------------------------------
    init(var color:UIColor)
    {
        var r:CGFloat = 0.0, g:CGFloat = 0.0, b:CGFloat = 0.0, a:CGFloat = 0.0;
        color.getRed(&r, green: &g, blue: &b, alpha: &a);
        set(r, in_green: g, in_blue: b);
    }
    //-------------------------------------------------------------------------
    init(var color:CustomColor) // copy consturctor
    {
        self.set(color.red(), in_green: color.green(), in_blue: color.blue());
    }
    //-------------------------------------------------------------------------
    func MAX_RGB()->CGFloat
    {
        return 255.0;
    }
    //-------------------------------------------------------------------------
    func get_UIColor()->UIColor
    {
        return UIColor(red: rgb_continuous[0], green: rgb_continuous[1],
            blue: rgb_continuous[2], alpha: 1.0);
    }
    //-------------------------------------------------------------------------
    func red()->Int
    {
        return rgb_discrete[0];
    }
    //-------------------------------------------------------------------------
    func green()->Int
    {
        return rgb_discrete[1];
    }
    //-------------------------------------------------------------------------
    func blue()->Int
    {
        return rgb_discrete[2]
    }
    //-------------------------------------------------------------------------
    func set(var in_red:Int, var in_green:Int, var in_blue:Int)
    {
        var max = in_red;
        if(max < in_green)
        {
            max = in_green;
        }
        if(max < in_blue)
        {
            max = in_blue;
        }
        if(max > Int(MAX_RGB()))
            // scale each color down proporionally if one value is greater than max rgb
        {
            in_red /= max;
            in_green /= max;
            in_blue /= max;
        }
        // update discrete rgb components
        rgb_discrete = [in_red, in_green, in_blue];
        
        // update continuous rgb components
        var red_cont:CGFloat = CGFloat(in_red) / MAX_RGB();
        var green_cont:CGFloat = CGFloat(in_green) / MAX_RGB();
        var blue_cont:CGFloat = CGFloat(in_blue) / MAX_RGB();
        rgb_continuous = [red_cont, green_cont, blue_cont];
        
        // update hex string
        hex_string = NSString(format:"#%02X%02X%02X", in_red, in_green, in_blue) as String;
    }
    //-------------------------------------------------------------------------
    func set(var in_red:CGFloat, var in_green:CGFloat, var in_blue:CGFloat)
    {
        var red:Int = Int(in_red * MAX_RGB());
        var green:Int = Int(in_green * MAX_RGB());
        var blue:Int = Int(in_blue * MAX_RGB());
        set(red, in_green: green, in_blue:blue);
    }
    //-------------------------------------------------------------------------
    
    func rgb_str()->String
    {
        var discrete_str = String(format:"rgb(%i, %i, %i)",rgb_discrete[0], rgb_discrete[1], rgb_discrete[2]);
        return discrete_str;
    }
    
    func print()
    {
        println(hex_string);
    }
    //-------------------------------------------------------------------------
    // data
    var rgb_continuous:Array<CGFloat> = [0.0, 0.0, 0.0];
    var rgb_discrete:Array<Int> = [0,0,0];
    var hex_string = String();
    //-------------------------------------------------------------------------
}

//-------------------------------------------------------------------------
// operator overloading
//-------------------------------------------------------------------------

func ==(lhs:CustomColor , rhs:CustomColor) -> Bool
{
    if(lhs.rgb_discrete[0] == rhs.rgb_discrete[0]) &&
        (lhs.rgb_discrete[1] == rhs.rgb_discrete[1]) &&
        (lhs.rgb_discrete[2] == rhs.rgb_discrete[2])
    {
        return true;
    }
    return false;
}

//-------------------------------------------------------------------------

func +(lhs:CustomColor , rhs:CustomColor) -> CustomColor
{
    var red = lhs.red() + rhs.red();
    var green = lhs.green() + rhs.green();
    var blue = lhs.blue() + rhs.blue();
    return CustomColor(in_red: red, in_green: green, in_blue: blue);
}

//-------------------------------------------------------------------------

func *(lhs:CustomColor , rhs:Float) -> CustomColor
{
    var red = Int(Float(lhs.red()) * rhs);
    var green = Int(Float(lhs.green()) * rhs);
    var blue = Int(Float(lhs.blue()) * rhs);
    return CustomColor(in_red: red, in_green: green, in_blue: blue);
}

func /(lhs:CustomColor , rhs:Float) -> CustomColor
{
    var red = Int(Float(lhs.red()) / rhs);
    var green = Int(Float(lhs.green()) / rhs);
    var blue = Int(Float(lhs.blue()) / rhs);
    return CustomColor(in_red: red, in_green: green, in_blue: blue);
}

//-------------------------------------------------------------------------
func generate_shades(inout shades:Array<UIButton>,var num_shades:Int, inout superview:UIView, var color:CustomColor)
{
    shades.removeAll(keepCapacity: true);
    var black = CustomColor(in_red: 0, in_green: 0, in_blue: 0);
    var white = CustomColor(in_red: 255, in_green: 255, in_blue: 255);
    for(var i = 0; i < num_shades; ++i)
    {
        // configure shade button in heiarchy
        superview.setNeedsLayout();
        superview.layoutIfNeeded();
        var dist_from_top = superview.bounds.size.height / CGFloat(num_shades) * CGFloat(i);
        var shade = UIButton();
        shade.setTranslatesAutoresizingMaskIntoConstraints(false);
        superview.addSubview(shade);
        
        var width = NSLayoutConstraint(item: shade, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        var height = NSLayoutConstraint(item: shade, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Height, multiplier: 1.0 / CGFloat(num_shades), constant:0.0);
        
        var center_x =  NSLayoutConstraint(item: shade, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var top =  NSLayoutConstraint(item: shade, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: dist_from_top);
        
        superview.addConstraint(width);
        superview.addConstraint(height);
        superview.addConstraint(center_x);
        superview.addConstraint(top);
        shades.append(shade);
    }
}

func edit_shades(inout shades:Array<UIButton>,var num_shades:Int, var color:CustomColor)
{
    var hex_str:String = color.hex_string;
    
    println(hex_str);
    // first half shades are linear combo of white and color
    var white = CustomColor(in_red: 1.0, in_green: 1.0, in_blue: 1.0);
    var black = CustomColor(in_red: 0.0, in_green: 0.0, in_blue: 0.0);
    
    var half_index = shades.count / 2;
    var increment = 1.0 / Float(half_index);
    var t:Float = 0.0;
    for(var i = 0; i < half_index; ++i)
    {
        var shade_color = (white * (1.0 - t)) + (color * t);
        shades[i].backgroundColor = shade_color.get_UIColor();
        t = t + increment;
    }
    shades[half_index].backgroundColor = color.get_UIColor();
    
    t = 0.0;
    for(var i = half_index+1; i < shades.count; ++i)
    {
        t += increment;
        var shade_color = (color * (1.0-t)) + (black * t);
        shades[i].backgroundColor = shade_color.get_UIColor();
    }
}

//-------------------------------------------------------------------------