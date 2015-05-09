// file for holding all color data including colors and paletts

import Foundation
import UIKit

//--- global structs
var toolbar_height:CGFloat = 49.0;
var margin:CGFloat = 25.0;
var current_palette_index = -1;
//--- global structs

class FavoritesData:NSObject, UITableViewDataSource  // data source of favorite color data
{
    var colors = Array<CustomColor>();
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell;
        // reuse cell -> remove all subviews if any are present
        var subs = cell.subviews;
        for(var i = 0; i < subs.count; ++i)
        {
            subs[i].removeFromSuperview();
        }
        cell.backgroundColor = UIColor.whiteColor();
        cell.layer.borderWidth = 0.5;
        
        //-----------------------------------------------------------------------------
        
        // get cell height and width attributes
        cell.setNeedsLayout();
        cell.layoutIfNeeded();
        var cell_height:CGFloat = cell.bounds.size.height;
        var cell_width:CGFloat = cell.frame.size.width;
        
        // configure view that will hold color
        var custom_color = colors[favorites_data.colors.count - 1 - indexPath.row];  // STACK (LIFO)
        var color_view = UIView();
        color_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        color_view.backgroundColor = custom_color.get_UIColor();
        color_view.layer.borderWidth = 0.5;
        var cell_margin:CGFloat = 5.0;
        var color_height = (cell_height - (2.0 * cell_margin));
        var color_width = color_height;
        
        // configure color constiants
        var color_left = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: cell_margin);
        
        var color_top = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: cell_margin);
        
        var color_bottom = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -cell_margin);
        
        var color_width_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        cell.addSubview(color_view);
        cell.addConstraint(color_left);
        cell.addConstraint(color_top);
        cell.addConstraint(color_bottom);
        cell.addConstraint(color_width_constr);
        
        //-----------------------------------------------------------------------------
        
        // configure hex font to display
        var hex_string:String = custom_color.hex_string;
        var hex_label = UILabel();
        hex_label.setTranslatesAutoresizingMaskIntoConstraints(false);
        hex_label.text = hex_string;
        cell.addSubview(hex_label);
        var centerx_const = cell_margin;
        var center_hex = NSLayoutConstraint(item: hex_label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: cell_margin * 2.0);
        var center_y = NSLayoutConstraint(item: hex_label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        cell.addConstraint(center_hex);
        cell.addConstraint(center_y);
        
        // configure rgb font to display
        var rgb_string:String = custom_color.rgb_str();
        var rgb_label = UILabel();
        cell.addSubview(rgb_label);
        rgb_label.setTranslatesAutoresizingMaskIntoConstraints(false);
        rgb_label.text = rgb_string;
        cell.addSubview(hex_label);
        var center_rgb = NSLayoutConstraint(item: rgb_label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        var center_yrgb = NSLayoutConstraint(item: rgb_label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        cell.addConstraint(center_rgb);
        cell.addConstraint(center_yrgb);
        cell.selectionStyle = UITableViewCellSelectionStyle.None;        
        return cell;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return colors.count;
    }
}

class PalettesData:NSObject, UITableViewDataSource
{    
    var NEXT_PALETTE_ID:UInt64 = 0;
    var palettes = Array<Palette>();
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return palettes.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell;
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = UIColor.blackColor().CGColor;
        cell.textLabel?.text = palette_data.palettes[indexPath.row].palette_name;
        cell.backgroundColor = UIColor.grayColor();
        cell.textLabel?.textColor = UIColor.whiteColor();
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell;
    }
    
}


var favorites_data:FavoritesData = FavoritesData();
var palette_data:PalettesData = PalettesData();





























