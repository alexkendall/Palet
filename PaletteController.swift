
// file holding palette controller class

import Foundation
import UIKit

class PaletteControler:UIViewController, UITableViewDelegate
{
    
    var table_view = UITableView();
    var background = UIView();
    var superview = UIView();
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        superview = self.view;
        superview.backgroundColor = UIColor.whiteColor();
        add_subview(table_view, superview, margin, margin + toolbar_height, margin, margin);
        
        // configure table view
        table_view.delegate = self;
        table_view.dataSource = palette_data;
        table_view.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell");
        table_view.separatorStyle = UITableViewCellSeparatorStyle.None;
        table_view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8);
        table_view.layer.borderWidth = 1.0;
        table_view.layer.borderColor = UIColor.blackColor().CGColor;
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var name = palette_data.palettes[indexPath.row].palette_name;
        println("selected palette named " + name);
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
}