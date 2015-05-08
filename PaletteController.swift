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
        current_palette_index = indexPath.row;
        if(tableView.tag == -5)
        {
            palette_data.palettes[indexPath.row].colors.append(CustomColor(in_red: current_color.red(), in_green: current_color.green(), in_blue: current_color.blue()));
        }
        else
        {
            color_grid.current_index = indexPath.row;
            self.view.addSubview(color_grid.view); // bring up color grid
            color_grid.exit.addTarget(self, action: "remove_grid", forControlEvents: UIControlEvents.TouchUpInside);
            color_grid.title_label.text = "Palette: " + name;
            color_grid.add_colors();
            
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
    var current_index:Int = -1;
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
    
    func add_colors()
    {
        if(current_index < 0 || (current_index > (palette_data.palettes.count - 1)))
        {
            EXIT_FAILURE;
        }
        scroll.setNeedsLayout();
        scroll.layoutIfNeeded();
        var color_width = (scroll.bounds.width - (margin * 3.0)) / 2.0;
        var color_height = color_width;
        // iterate through each color in palette
        var count = palette_data.palettes[current_index].colors.count;
        println(count);
        var j = -1;
        for(var i = 0; i < count; ++i)
        {
            var color_view = UIButton();
            color_view.backgroundColor = palette_data.palettes[current_index].colors[i].get_UIColor();
            color_view.setTranslatesAutoresizingMaskIntoConstraints(false);
            scroll.addSubview(color_view);
            
            var distFromLeft:CGFloat = CGFloat();
            if((i % 2) == 0)    // even
            {
                ++j;
                distFromLeft = margin;
            }
            else    // odd
            {
                distFromLeft = (margin * 2.0) + color_width;
            }
            var distFromTop = margin + ((color_height + (margin * 2.0)) * CGFloat(j));
            
            // add constraints
            var width_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: scroll, attribute: NSLayoutAttribute.Width, multiplier: 0.0, constant: color_width);
            
            var height_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scroll, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: color_height);
            
            var top_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scroll, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: distFromTop);
            
            var left_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scroll, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: distFromLeft);
            
            scroll.addConstraint(width_constr);
            scroll.addConstraint(height_constr);
            scroll.addConstraint(top_constr);
            scroll.addConstraint(left_constr);
        }
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


