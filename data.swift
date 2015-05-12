// file for holding all color data including colors and paletts

import Foundation
import UIKit
import CoreData

//----------------------------------------------------------------------------------
var toolbar_height:CGFloat = 49.0;
var margin:CGFloat = 25.0;
var current_palette_index = -1;
//----------------------------------------------------------------------------------

class FavoritesData:NSObject, UITableViewDataSource  // data source of favorite color data
{
    //var colors = Array<CustomColor>();
    var colors = Array<NSManagedObject>();
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:FavoriteTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! FavoriteTableViewCell;
        var color = getColor(indexPath.row);
        cell.set_info(color.hex_string, rgb_string: color.rgb_str(), custom_color: color, in_row: indexPath.row);
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
        var cell:myTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! myTableViewCell;
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = UIColor.blackColor().CGColor;
        cell.textLabel?.text = palette_data.palettes[indexPath.row].palette_name;
        cell.backgroundColor = UIColor.grayColor();
        cell.textLabel?.textColor = UIColor.whiteColor();
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        cell.row = indexPath.row;
        cell.remove_delete();
        return cell;
    }
    
}

var favorites_data:FavoritesData = FavoritesData();
var palette_data:PalettesData = PalettesData();



// GETS COLOR CORESPONDING TO INDEX ROW, NOTE THIS FUNCTION HANDLES LIFO STACK ORIENTATION IN WHICH COLORS ARE STORED
func getColor(var index:Int) ->CustomColor
{
    var color_data = favorites_data.colors[favorites_data.colors.count - 1 - index];  // STACK (LIFO)
    
    var red:Int = (color_data.valueForKey("red") as? Int)!;
    var green:Int = (color_data.valueForKey("green") as? Int)!;
    var blue:Int = (color_data.valueForKey("blue") as? Int)!;
    
    var color = CustomColor(in_red: red, in_green: green, in_blue: blue);
    return color;
}

