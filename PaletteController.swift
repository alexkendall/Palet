
// file holding palette controller class

import Foundation
import UIKit

class PaletteControler:UIViewController, UITableViewDelegate
{
    
    var table_view = UITableView();
    var background = UIView();
    var superview = UIView();
    var color_grid = GridController();
    
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
        
        self.addChildViewController(color_grid);
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var name = palette_data.palettes[indexPath.row].palette_name;
        if(tableView.tag == -5)
        {
            palette_data.palettes[indexPath.row].colors.append(CustomColor(in_red: current_color.red(), in_green: current_color.green(), in_blue: current_color.blue()));
        }
        else
        {
            self.view.addSubview(color_grid.view); // bring up color grid
            color_grid.exit.addTarget(self, action: "remove_grid", forControlEvents: UIControlEvents.TouchUpInside);
            color_grid.title_label.text = "Palette: " + name;
            
        }
    }
    
    func remove_grid()
    {
        color_grid.view.removeFromSuperview();  // remove color grid
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
}

class GridController:UIViewController
{
    var super_view = UIView();
    var title_label = UILabel();
    var exit = UIButton();
    var scroll = UIScrollView();
    var title_margin = margin * 3.0;
    override func viewDidLoad()
    {
        super_view = self.view;
        super_view.backgroundColor = UIColor.whiteColor();
        var super_width = super_view.bounds.width;
        var super_height = super_view.bounds.height;
        var exit_width = margin;
        
        
        // configure title label
        title_label.textColor = UIColor.blackColor();
        title_label.textAlignment = NSTextAlignment.Center;
        title_label.backgroundColor = UIColor.whiteColor();
        title_label.layer.borderWidth = 1.0;
        add_subview(title_label, super_view, margin, super_view.bounds.height - title_margin - margin, margin, margin);
        
        // configure exit button
        add_subview(exit, super_view, 0.0, super_height - exit_width, super_width - exit_width, 0.0);
        exit.backgroundColor = UIColor.blackColor();
        exit.setTitle("X", forState: UIControlState.Normal);
        exit.titleLabel?.font = UIFont.systemFontOfSize(15.0);
        
        // configure scroll view
        add_subview(scroll, super_view, title_margin, margin + toolbar_height, margin, margin);
        scroll.backgroundColor = UIColor.lightGrayColor();
        scroll.layer.borderWidth = 1.0;
        
        
        super.viewDidLoad()
    }
    
    //-------------------------------------------------------------------------
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated);
    }
    
    //-------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------------------

}


