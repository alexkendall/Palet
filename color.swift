
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
    
    func print()
    {
       var discrete_str = String(format: "RGB Discrete: Red % i, Green %i, Blue %i\n",rgb_discrete[0], rgb_discrete[1], rgb_discrete[2]);
       
        var contin_str = String(format: "RGB Continuous: Red % f, Green %f, Blue %f\n",rgb_continuous[0], rgb_continuous[1], rgb_continuous[2]);
        
        println(discrete_str);
        println(contin_str);
    }
    
    //-------------------------------------------------------------------------
    // data
    var rgb_continuous:Array<CGFloat> = [0.0, 0.0, 0.0];
    var rgb_discrete:Array<Int> = [0,0,0];
    var hex_string = String();
    //-------------------------------------------------------------------------
}

func ==(lhs:CustomColor , rhs:CustomColor) -> Bool
{
    lhs.print();
    rhs.print();
    println("comparing values");
    if(lhs.rgb_discrete[0] == rhs.rgb_discrete[0]) &&
        (lhs.rgb_discrete[1] == rhs.rgb_discrete[1]) &&
        (lhs.rgb_discrete[2] == rhs.rgb_discrete[2])
    {
        println("equal");
        return true;
    }
    println("not equal");
    return false;
}