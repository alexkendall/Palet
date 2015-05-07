// file for holding all color data including colors and paletts

import Foundation
import UIKit

var toolbar_height:CGFloat = 49.0;

class Data:NSObject, UITableViewDataSource
{
    var NEXT_PALETTE_ID:UInt64 = 0;
    var favorites = Array<CustomColor>();
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell;
        cell.backgroundColor = favorites[indexPath.row].get_UIColor();
        cell.layer.borderWidth = 0.5;
        return cell;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count;
    }
}

var app_data:Data = Data();