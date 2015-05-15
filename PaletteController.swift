// file holding palette controller class

import Foundation
import UIKit
import CoreData
let PALETTE_DUPLICATE_STR = "PALETTE ALREADY EXISTS!";
let DEFAULT_PLACEHOLDER = "Create New Palette";

class PaletteControler:UIViewController, UITableViewDelegate
{
    
    //var table_view = UITableView();
    var background = UIView();
    var superview = UIView();
    var color_grid = GridController();
    var add_controler = AddController();
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        superview = self.view;
        superview.backgroundColor = UIColor.whiteColor();
        self.addChildViewController(add_controler);
        superview.addSubview(add_controler.view);
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var name = getPaletteName(indexPath.row);
        if(tableView.tag == ADD_PALETTE_TABLE_TAG)  // IN PICKER_CONTROLLER -> ADD COLOR TO THIS PALETTE
        {
            if(ColorInPalette(current_color, name)) // color is duplicate
            {
                picker_controller.notification_controller.set_text("Color " + current_color.hex_string + " already in palette");
            }
            else
            {
                saveColor(current_color, &saved_palette_colors, "Color", name);
                picker_controller.notification_controller.set_text("Added " + current_color.hex_string + " to " + name);
                
                // update palette color grid window if it is present
                var sub_array:Array<UIView> = self.view.subviews as! Array<UIView>;
                var color_view:UIView = color_grid.view;
                
                if(find(sub_array, color_view) != nil)  // color grid window is up...we must update it
                {
                    color_grid.add_colors();
                }
            }
            picker_controller.notification_controller.bring_up();
        }
        else    // IN PALETTE CONTROLER -> DISPLAY COLORS IN PALETTE
        {
            color_grid.info_controller.view.removeFromSuperview();
            self.view.addSubview(color_grid.view);
            color_grid.exit.addTarget(self, action: "remove_grid", forControlEvents: UIControlEvents.TouchUpInside);
            color_grid.title_label.text = name;
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
    var title_margin:CGFloat = 44.0;
    var current_index:Int = -1;
    var current_selected_color:Int = -1;
    var colors = Array<UIButton>();
    var colors_source = Array<NSManagedObject>();
    var info_controller = ColorInfoController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        super_view = self.view;
        super_view.backgroundColor = UIColor.whiteColor();
        var super_width = super_view.bounds.width;
        var super_height = super_view.bounds.height;
        var exit_width = title_margin;
        
        // configure title label
        title_label.textColor = UIColor.blackColor();
        title_label.font = UIFont.systemFontOfSize(20.0);
        title_label.textAlignment = NSTextAlignment.Center;
        title_label.backgroundColor = UIColor.whiteColor();
        title_label.layer.borderWidth = 1.0;
        add_subview(title_label, super_view, margin, super_view.bounds.height - title_margin - margin, margin, margin);
        
        // configure scroll view
        add_subview(scroll, super_view, margin + title_margin - 1, margin + toolbar_height, margin, margin);
        scroll.backgroundColor = UIColor.lightGrayColor();
        scroll.layer.borderWidth = 1.0;
        scroll.scrollEnabled = true;
        scroll.clipsToBounds = true;
        
        // configure exit button
        add_subview(exit, super_view, margin, super_height - margin - exit_width, super_width - margin - exit_width, margin);
        exit.backgroundColor = UIColor.blackColor();
        exit.setTitle("exit", forState: UIControlState.Normal);
        exit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        exit.titleLabel?.font = UIFont.systemFontOfSize(15.0);
        
        // add child controller
        self.addChildViewController(info_controller);
        
    }
    
    func selected_color(sender:UIButton!)
    {
        if((current_selected_color > -1))
        {
            colors[current_selected_color].layer.borderWidth = 1.0;
            colors[current_selected_color].layer.borderColor = UIColor.blackColor().CGColor;
        }
        if(current_selected_color != sender.tag)
        {
            current_selected_color = sender.tag; // update current selected color from palette
            var color_index = sender.tag;
            //var color = CustomColor(color: palette_data.palettes[current_index].colors[color_index]);
            var color = CustomColor(color:colors[color_index].backgroundColor!);
            
            
            
            sender.layer.borderWidth = 3.0;
            sender.layer.borderColor = UIColor.whiteColor().CGColor;
            current_color = color;
            picker_controller.viewDidLoad();
            
            info_controller.set_text(current_color.hex_string + "  " + current_color.rgb_str());
            super_view.addSubview(info_controller.view);
        }
        else    // toggle off current selected
        {
            current_selected_color = -1;
            colors[sender.tag].layer.borderWidth = 1.0;
            colors[sender.tag].layer.borderColor = UIColor.blackColor().CGColor;
            info_controller.view.removeFromSuperview();
        }
    }
    
    func delete_color(delete_button:UIButton!)
    {
        var palette_name = title_label.text;
        var this_color = colors[delete_button.tag].backgroundColor;
        var color = CustomColor(color: this_color!);
        
        var red:Int = color.red();
        var green:Int = color.green();
        var blue:Int = color.blue();
        
        // FETCH COLOR WITH THAT ATTRIBUTE FROM CORE DATA STACK
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        let managedContext = appDelegate.managedObjectContext;
        
        let fetchRequest = NSFetchRequest(entityName: "Color");
        var pred = NSPredicate(format:"(palette_name like[cd] %@) AND (red == %i) AND (green == %i) AND (blue == %i)", palette_name!, red, green, blue);
        fetchRequest.predicate = pred;
        
        var error:NSError?;
        let fetchedResults = managedContext?.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject];
        
        var resulting_objects = Array<NSManagedObject>();
        
        if let results = fetchedResults
        {
            resulting_objects = fetchedResults!;
        }
        
        // DELETE THE OBJECT
        for(var i = 0; i < resulting_objects.count; ++i)
        {
            managedContext?.deleteObject(resulting_objects[i]);
        }
        
        var error_2:NSError?;
        if !managedContext!.save(&error_2)
        {
            println("Unable to delete favorite color");
        }
        
        colors_source.removeAtIndex(delete_button.tag);
        add_colors();
        info_controller.view.removeFromSuperview();
    }
    
    func add_colors()
    {
        var palette_name:String = title_label.text!;
        var pred = NSPredicate(format:"palette_name like[cd] %@", palette_name);
        colors_source = fetch("Color", pred, true); // retrieve each color belonging to this palette
        
        colors.removeAll(keepCapacity: true); // clear pre-existing views-> refresh
        current_selected_color = -1;
        
        // clear scroll
        var subs = scroll.subviews;
        for(var i = 0; i < subs.count; ++i)
        {
            subs[i].removeFromSuperview();
        }
        scroll.setNeedsLayout();
        scroll.layoutIfNeeded();
        var color_width = (scroll.bounds.width - (margin * 3.0)) / 2.0;
        var color_height = color_width;
        
        // iterate through each color in palette
        var count = colors_source.count;
        var j = -1;
        
        for(var i = 0; i < colors_source.count; ++i)
        {
            var color_view = UIButton();
            color_view.layer.borderWidth = 1.0;
            color_view.layer.borderColor = UIColor.blackColor().CGColor;
            
            color_view.backgroundColor = getPaletteColor(i, &colors_source).get_UIColor();
            color_view.setTranslatesAutoresizingMaskIntoConstraints(false);
            scroll.addSubview(color_view);
            color_view.addTarget(self, action: "selected_color:", forControlEvents: UIControlEvents.TouchUpInside);
            color_view.tag = i;
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
            var distFromTop = margin + ((color_height + (margin)) * CGFloat(j));
            
            // add constraints
            var width_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: scroll, attribute: NSLayoutAttribute.Width, multiplier: 0.0, constant: color_width);
            
            var height_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scroll, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: color_height);
            
            var top_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scroll, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: distFromTop);
            
            var left_constr = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scroll, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: distFromLeft);
            
            scroll.addConstraint(width_constr);
            scroll.addConstraint(height_constr);
            scroll.addConstraint(top_constr);
            scroll.addConstraint(left_constr);
            colors.append(color_view);
            
            // set up delete button for each color
            var delColBut = UIButton();
            delColBut.backgroundColor = UIColor.blackColor();
            delColBut.setTitle("x", forState: UIControlState.Normal);
            delColBut.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
            delColBut.tag = i;
            color_view.layoutIfNeeded();
            color_view.setNeedsLayout();
            var color_dim = color_view.bounds.width;
            var del_dim:CGFloat = 30.0;
            var del_margin = color_dim - del_dim;
            add_subview(delColBut, color_view, 0.0, del_margin, del_margin, 0.0);
            delColBut.addTarget(self, action: "delete_color:", forControlEvents: UIControlEvents.TouchDown);
        }
        var content_height:CGFloat = (color_height + (margin)) * CGFloat((ceil(Double(count) / 2.0)) * 2.0) / 2.0 + margin;
        scroll.contentSize = CGSize(width: scroll.bounds.width, height: content_height);
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

class ColorInfoController:UIViewController
{
    var super_view = UIView();
    var colorInfoLabel = UILabel();
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // configure controllers root view
        var label_height = 1.5 * margin;
        super_view = self.view;
        var super_height = super_view.frame.height;
        var super_width = super_view.frame.width;
        super_view.frame = CGRect(x: 0, y: super_height - toolbar_height - label_height, width: super_width, height: label_height);
        
        // configure label
        add_subview(colorInfoLabel, super_view, 1.0, 1.0, 1.0);
        colorInfoLabel.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8);
        colorInfoLabel.textColor = UIColor.whiteColor();
        colorInfoLabel.textAlignment = NSTextAlignment.Center;
    }
    
    func set_text(var in_text:String)
    {
        colorInfoLabel.text = in_text;
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


class AddController:UIViewController, UITextFieldDelegate
{
    var super_view = UIView();
    var text_background = UIView();
    var enter_text = UITextField();
    var commit_button = UIButton();
    var palette_table = UITableView();
    var background = UIView();
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if(enter_text != "")
        {
            add_new_palette();
        }
        enter_text.endEditing(true);
        return true;
    }
    
    func add_new_palette()
    {
        if(enter_text.text != "")   // don't allow user to name palette the empty string
        {
            if(InPaletteArray(enter_text.text) == false)
            {
                enter_text.endEditing(true);  // remove keybaord
                
                var name = enter_text.text;
                //var pid = Int(palette_data.NEXT_PALETTE_ID++);
                savePalette(name, &saved_palettes);
                enter_text.text = "";   // reset text
                palette_table.reloadData();
                pallettes_controller.add_controler.palette_table.reloadData();
                picker_controller.pallete_window.palette_table.reloadData();
            }
            else
            {
                enter_text.text = "";
                enter_text.placeholder = PALETTE_DUPLICATE_STR;
            }
        }
    }
    
    func started_editing()
    {
        if(enter_text.placeholder == PALETTE_DUPLICATE_STR)
        {
            enter_text.placeholder = DEFAULT_PLACEHOLDER;
        }
        if((enter_text.editing) && (enter_text.text == ""))
        {
            enter_text.endEditing(true);
        }
    }
    
    override func viewDidLoad()
    {
        //-------------------------------------------------------------------------------------------
        // CONFIGURE SUPER VIEW BOUNDS AND FRAMES
        //-------------------------------------------------------------------------------------------
        super.viewDidLoad();
        super_view = self.view;
        
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE BACKGROUND
        //-------------------------------------------------------------------------------------------
        add_subview(background, super_view, margin, margin + toolbar_height, margin, margin);
        background.backgroundColor = UIColor.lightGrayColor();
        background.layer.borderWidth = 1.0;
        background.layoutIfNeeded();
        background.setNeedsLayout();
        
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE ADD PICKER TEXT VIEW
        //-------------------------------------------------------------------------------------------
        var picker_height:CGFloat = 44.0;
        text_background.backgroundColor = UIColor.whiteColor();
        text_background.layer.borderWidth = 1.0;
        var bottom_margin = background.frame.height - picker_height;
        add_subview(text_background, background, 0.0, bottom_margin, 0.0, 0.0);
        
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE FIELD TO ENTER TEXT
        //-------------------------------------------------------------------------------------------
        
        var frame_height = background.frame.height;
        var frame_width = background.frame.width;
        var text_height:CGFloat = 44.0;
        
        enter_text.backgroundColor = UIColor.whiteColor();
        enter_text.placeholder = DEFAULT_PLACEHOLDER;
        add_subview(enter_text, background, 0.0, frame_height - text_height + 1.0, 10.0, text_height);
        enter_text.setNeedsLayout();
        enter_text.layoutIfNeeded();
        enter_text.addTarget(self, action: "started_editing", forControlEvents: UIControlEvents.TouchDown);
        enter_text.delegate = self;
        
        var commit_width = text_height;
        commit_button.backgroundColor = UIColor.grayColor();
        commit_button.setTitle("ADD", forState: UIControlState.Normal);
        commit_button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        commit_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted);
        add_subview(commit_button, background, 0.0, frame_height - text_height + 1.0, frame_width - commit_width, 0.0);
        commit_button.addTarget(self, action: "add_new_palette", forControlEvents: UIControlEvents.TouchUpInside);
        
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE ADD TABLE VIEW
        //-------------------------------------------------------------------------------------------
        palette_table.dataSource = palette_data;
        palette_table.delegate = pallettes_controller;
        add_subview(palette_table, background, picker_height - 1.0, 0.0, 0.0, 0.0);
        palette_table.backgroundColor = UIColor.lightGrayColor();
        palette_table.separatorStyle = UITableViewCellSeparatorStyle.None;
        palette_table.registerClass(paletteTableViewCell.self, forCellReuseIdentifier: "cell");
        
        // tag table so we can use different color cells fromt those in PaletteController
        palette_table.tag = 0;
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated);
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
