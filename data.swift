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
        var color = getColor(indexPath.row, &favorites_data.colors);
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

//------------------------------------------------------------------------------------------------------------------

// GETS COLOR CORESPONDING TO INDEX ROW, NOTE THIS FUNCTION HANDLES LIFO STACK ORIENTATION IN WHICH COLORS ARE STORED
func getColor(var index:Int, inout array:Array<NSManagedObject>) ->CustomColor
{
    var color_data = array[favorites_data.colors.count - 1 - index];  // STACK (LIFO)
    
    var red:Int = (color_data.valueForKey("red") as? Int)!;
    var green:Int = (color_data.valueForKey("green") as? Int)!;
    var blue:Int = (color_data.valueForKey("blue") as? Int)!;
    
    var color = CustomColor(in_red: red, in_green: green, in_blue: blue);
    return color;
}

//------------------------------------------------------------------------------------------------------------------

func InColorArray(var color:CustomColor, inout array:Array<NSManagedObject>)->Bool
{
    for(var i = 0; i < favorites_data.colors.count; ++i)
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

func saveColor(var color:CustomColor, inout array:Array<NSManagedObject>, var entityName:String, var p_id:Int)
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
    color_data.setValue(p_id, forKey: "palette_id");
    
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






