import UIKit
import CoreData

var current_color = CustomColor(in_red: 128, in_green: 128, in_blue: 128);
var color_height = 5.0 * margin;
var ADD_PALETTE_TABLE_TAG = -5;
var BUTTON_DIM = margin * 1.5;
var FAVORITE_ID:Int = -1;
let EMPTY_STRING = "";

class ColorController: UIViewController
{
    let NUM_SHADES = 9;
    var background = UIView();
    var super_view = UIView();
    var color_view = UIButton();
    let sliders = [UISlider(), UISlider(), UISlider()];
    let RED_INDEX = 0, GREEN_INDEX = 1, BLUE_INDEX = 2;
    var indicators = [UILabel(), UILabel(), UILabel()];
    let indicator_text = ["R","G","B"];
    var RGB = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()];
    var saved_colors = Array<CustomColor>();
    var shade_view = UIView();
    var hex_text = UILabel();
    var rgb_text = UILabel();
    var favorite_button = UIButton();
    var add_button = UIButton()
    var shades = Array<UIButton>();
    var pallete_window = PaletteWindowController();
    var pallete_switch = true;
    var notification_controller = NotificationController();
    
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    func add_to_pallette()
    {
        if(pallete_switch == true)
        {
            add_button.backgroundColor = UIColor.blackColor();
            super_view.addSubview(pallete_window.view);
            pallete_switch = false;
        }
        else
        {
            add_button.backgroundColor = UIColor.lightGrayColor();
            pallete_window.view.removeFromSuperview();
            pallete_switch = true;
        }
    }
    
    
    
    func add_favorite()
    {
        if(InColorArray(current_color, &favorites_data.colors))
        {
            notification_controller.set_text("Color " + current_color.hex_string + " Already in Favorites");
        }
        else
        {
            saveColor(current_color, &favorites_data.colors, "Color", " ");
            favorites_controller.table_view.reloadData();
            notification_controller.set_text("Added " + current_color.hex_string + " to Favorites");
        }
        notification_controller.bring_up();
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated);
        fetch_favorites();
        fetch_palettes();
        
    }
    
    func fetch_favorites()
    {
        var pred = NSPredicate(format:"palette_name like[cd] %@", " ");
        var results:[NSManagedObject] = fetch("Color", pred, true);
        favorites_data.colors = results;
    }
    
    func fetch_palettes()
    {
        var results:[NSManagedObject] = fetch("Palette", NSPredicate(), false);
        saved_palettes = results;
    }
    
    func selected_shade(sender:UIButton!)
    {
        var shade_color = shades[sender.tag].backgroundColor;
        
        var red:CGFloat = 0.0, blue:CGFloat = 0.0, green:CGFloat = 0.0, alpha:CGFloat = 0.0;
        shade_color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha);
        red *= 255.0;
        green *= 255.0;
        blue *= 255.0;
        current_color.set(Int(red), in_green: Int(green), in_blue: Int(blue));
        // update slider values
        sliders[RED_INDEX].value = Float(red);
        sliders[GREEN_INDEX].value = Float(green);
        sliders[BLUE_INDEX].value = Float(blue);
        moved_slider();
    }
    
    func moved_slider()
    {
        var max_val:CGFloat = 255.0;
        var red_val:CGFloat = CGFloat(sliders[RED_INDEX].value) / max_val;
        var green_val:CGFloat = CGFloat(sliders[GREEN_INDEX].value) / max_val;
        var blue_val:CGFloat = CGFloat(sliders[BLUE_INDEX].value) / max_val;
        current_color.set(red_val, in_green: green_val, in_blue: blue_val);
        color_view.backgroundColor = current_color.get_UIColor();
        hex_text.text = current_color.hex_string;
        var rgb_str = String(format: "rgb(%i, %i, %i)", current_color.red(), current_color.green(), current_color.blue());
        rgb_text.text = rgb_str;
        generate_shades(&shades, NUM_SHADES, &shade_view, current_color);
        for(var i = 0; i < shades.count; ++i)
        {
            assert(shades.count == NUM_SHADES, "ERROR INCORRECT NUMBER OF SHADES");
            shades[i].addTarget(self, action: "selected_shade:", forControlEvents: UIControlEvents.TouchUpInside);
            shades[i].tag = i; // tag shade so we know which color to update to when shade is selected
        }
    }
    
    func save_color(sender:UIButton!)
    {
        if(find(saved_colors, current_color) == nil)
        {
            var red = current_color.rgb_discrete[0];
            var green = current_color.rgb_discrete[1];
            var blue = current_color.rgb_discrete[2];
            saved_colors.append(CustomColor(in_red: red, in_green: green, in_blue: blue));
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super_view = self.view;
        color_height = (super_view.bounds.height - toolbar_height) / 5.0;
        add_subview(background, super_view, 1.0, 1.0, 1.0);
        background.backgroundColor = UIColor.whiteColor();
        var super_height:CGFloat = super_view.bounds.width;
        var super_width:CGFloat = super_view.bounds.height;
        //-------------------------------------------------------------------------------------------
        // CONFIGURE COLOR VIEW IN TOP OF DEVICE
        //-------------------------------------------------------------------------------------------
        color_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        color_view.backgroundColor = current_color.get_UIColor();
        color_view.layer.borderColor = UIColor.blackColor().CGColor;
        color_view.layer.borderWidth = 1.0;
        super_view.addSubview(color_view);
        var left = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: margin);
        var top = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: margin);
        var right = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -margin);
        var height = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Width, multiplier: 0.0, constant: color_height);
        // add constraints
        super_view.addConstraint(left);
        super_view.addConstraint(top);
        super_view.addConstraint(right);
        super_view.addConstraint(height);
        // add target to enable saving the color
        color_view.addTarget(self, action: "save_color:", forControlEvents: UIControlEvents.TouchUpInside);
        //-------------------------------------------------------------------------------------------
        // CONFIGURE SAVE BUTTON IN COLOR VIEW
        //-------------------------------------------------------------------------------------------
        var fav_dim = margin * 1.5;
        favorite_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        favorite_button.backgroundColor = UIColor.lightGrayColor();
        favorite_button.setBackgroundImage(UIImage(named: "favorite"), forState: UIControlState.Normal);
        favorite_button.layer.borderWidth = 0.5;
        color_view.addSubview(favorite_button);
        var save_right = NSLayoutConstraint(item: favorite_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0);
        var save_bottom = NSLayoutConstraint(item: favorite_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0);
        var save_height = NSLayoutConstraint(item: favorite_button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: favorite_button, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -fav_dim);
        var save_width = NSLayoutConstraint(item: favorite_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: favorite_button, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: fav_dim);
        // add constraints
        color_view.addConstraint(save_right);
        color_view.addConstraint(save_bottom);
        color_view.addConstraint(save_height);
        color_view.addConstraint(save_width);
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE ADD BUTTON IN COLOR VIEW
        //-------------------------------------------------------------------------------------------
        
        add_button.backgroundColor = UIColor.lightGrayColor();
        add_button.layer.borderWidth = 0.5;
        add_button.setBackgroundImage(UIImage(named: "plus"), forState: UIControlState.Normal);
        add_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        color_view.addSubview(add_button);
        
        var add_right = NSLayoutConstraint(item: add_button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0);
        var add_bottom = NSLayoutConstraint(item: add_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0);
        
        var add_height = NSLayoutConstraint(item: add_button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: favorite_button, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        var add_width = NSLayoutConstraint(item: add_button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: favorite_button, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        // add constraints
        color_view.addConstraint(add_right);
        color_view.addConstraint(add_bottom);
        color_view.addConstraint(add_height);
        color_view.addConstraint(add_width);
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE HEXIDECIMAL TEXT VIEW UNDER COLOR VIEW
        //-------------------------------------------------------------------------------------------
        hex_text.setTranslatesAutoresizingMaskIntoConstraints(false);
        background.addSubview(hex_text);
        var center_hex = NSLayoutConstraint(item: hex_text, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0);
        var top_hex = NSLayoutConstraint(item: hex_text, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: margin/2.0);
        var height_hex = NSLayoutConstraint(item: hex_text, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: hex_text, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -margin);
        var width_hex = NSLayoutConstraint(item: hex_text, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: hex_text, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 8*margin);
        super_view.addConstraint(center_hex);
        super_view.addConstraint(top_hex);
        super_view.addConstraint(height_hex);
        super_view.addConstraint(width_hex);
        hex_text.text = "#000000";
        hex_text.textColor = UIColor.blackColor();
        hex_text.textAlignment = NSTextAlignment.Left;
        //-------------------------------------------------------------------------------------------
        // CONFIGURE RGB TEXT VIEW BY HEX_TEXT
        //-------------------------------------------------------------------------------------------
        rgb_text.setTranslatesAutoresizingMaskIntoConstraints(false);
        rgb_text.text = "rgb(0,0,0)";
        background.addSubview(rgb_text);
        var centery_rgb = NSLayoutConstraint(item: rgb_text, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: hex_text, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        var right_rgb = NSLayoutConstraint(item: rgb_text, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0);
        
        super_view.addConstraint(centery_rgb);
        super_view.addConstraint(right_rgb);
        
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE LABELS IN RHS OF DEVICE
        //-------------------------------------------------------------------------------------------
        for(var i = 0; i < indicators.count; ++i)
        {
            indicators[i].setTranslatesAutoresizingMaskIntoConstraints(false);
            indicators[i].text = indicator_text[i];
            indicators[i].textColor = UIColor.blackColor();
            indicators[i].textAlignment = NSTextAlignment.Center;
            indicators[i].layer.backgroundColor = UIColor.whiteColor().CGColor;
            indicators[i].layer.borderWidth = 1.0;
            background.addSubview(indicators[i]);
            var baseline = (margin / 2.0) + (1.5 * margin * CGFloat(i));
            var left = NSLayoutConstraint(item: indicators[i], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0);
            var right = NSLayoutConstraint(item: indicators[i], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: indicators[i], attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: margin);
            var top = NSLayoutConstraint(item: indicators[i], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: hex_text, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:baseline);
            
            var height = NSLayoutConstraint(item: indicators[i], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: indicators[i], attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:-margin);
            super_view.addConstraint(left);
            super_view.addConstraint(right);
            super_view.addConstraint(top);
            super_view.addConstraint(height);
        }
        //-------------------------------------------------------------------------------------------
        // CONFIGURE SLIDERS ON TOP LHS OF DEVICE
        //-------------------------------------------------------------------------------------------
        //var sliders = [red_slider, green_slider, blue_slider];
        
        var width = (super_view.bounds.width / 2.0) - (margin * 3.0);
        for(var i = 0; i < sliders.count; ++i)
        {
            sliders[i].setTranslatesAutoresizingMaskIntoConstraints(false);
            background.addSubview(sliders[i]);
            sliders[i].minimumValue = 0.0;
            sliders[i].maximumValue = 255.0;    // RGB 0-255
            sliders[i].minimumTrackTintColor = RGB[i];
            // set current val to 0
            //sliders[i].value = 128;
            // add extra margin space on left side to put rgb labels to left of sliders
            var left = NSLayoutConstraint(item: sliders[i], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: indicators[i], attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: margin / 2.0);
            var right = NSLayoutConstraint(item: sliders[i], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -margin);
            var center_y = NSLayoutConstraint(item: sliders[i], attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: indicators[i], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant:0.0);
            super_view.addConstraint(left);
            super_view.addConstraint(right);
            super_view.addConstraint(center_y);
            sliders[i].addTarget(self, action: "moved_slider", forControlEvents: UIControlEvents.ValueChanged);
        }
        sliders[RED_INDEX].value = Float(current_color.red());
        sliders[GREEN_INDEX].value = Float(current_color.green());
        sliders[BLUE_INDEX].value = Float(current_color.blue());
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE SHADE VIEW OF BUTTONS
        //-------------------------------------------------------------------------------------------
        shade_view.backgroundColor = UIColor.whiteColor();
        shade_view.layer.borderWidth = 1.0;
        shade_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        background.addSubview(shade_view);
        var shade_centerx = NSLayoutConstraint(item: shade_view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant:0.0);
        var shade_width = NSLayoutConstraint(item: shade_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant:0.0);
        var shade_top = NSLayoutConstraint(item: shade_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: indicators[2], attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:margin);
        var shade_bottom = NSLayoutConstraint(item: shade_view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:-(margin + toolbar_height));
        super_view.addConstraint(shade_centerx);
        super_view.addConstraint(shade_width);
        super_view.addConstraint(shade_top);
        super_view.addConstraint(shade_bottom);
        moved_slider();
        
        // add target for saving color
        favorite_button.addTarget(self, action: "add_favorite", forControlEvents: UIControlEvents.TouchUpInside);
        // add target for adding color to palette
        add_button.addTarget(self, action: "add_to_pallette", forControlEvents: UIControlEvents.TouchUpInside);
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE CHILD VIEW CONTROLLERS
        //-------------------------------------------------------------------------------------------
        self.addChildViewController(pallete_window);
        self.addChildViewController(notification_controller);
        
        //-------------------------------------------------------------------------------------------
        // ADD NOTIFICATION VIEW
        //-------------------------------------------------------------------------------------------
        super_view.addSubview(notification_controller.view);
    }
    //-------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //-------------------------------------------------------------------------
}

class PaletteWindowController:UIViewController, UITextFieldDelegate
{
    var super_view = UIView();
    var text_background = UIView();
    var enter_text = UITextField();
    var commit_button = UIButton();
    var palette_table = UITableView();
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if(enter_text.text != "")
        {
            add_new_palette();
        }
        else
        {
            enter_text.endEditing(true);
        }
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
                picker_controller.notification_controller.set_text("Palette already exists!");
                picker_controller.notification_controller.bring_up();
            }
        }
    }
    
    func started_editing()
    {
        // allow user to cancel entry/ make keybaord disappear
        if(enter_text.editing && enter_text.text == "")
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
        var init_frame = super_view.frame;
        var frame_width = init_frame.width - (2.0 * margin);
        var frame_height = init_frame.height - margin - color_height - margin - toolbar_height + 1.0;
        var x = margin;
        var y = margin + color_height - 1.0;
        super_view.frame = CGRect(x: x, y: y, width: frame_width, height: frame_height);
        super_view.layer.borderWidth = 1.0;
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE ADD PICKER TEXT VIEW
        //-------------------------------------------------------------------------------------------
        var picker_height:CGFloat = 44.0;
        text_background.backgroundColor = UIColor.whiteColor();
        text_background.layer.borderWidth = 1.0;
        add_subview(text_background, super_view, 0.0, frame_height - picker_height, 0.0, 0.0);
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE CREATE PALETTE ENTER TEXT AND COMMIT VIEWS
        //-------------------------------------------------------------------------------------------
        var text_height:CGFloat = 44.0;
        enter_text.backgroundColor = UIColor.whiteColor();
        enter_text.placeholder = "Create New Palette";
        add_subview(enter_text, super_view, 0.0, frame_height - text_height + 1.0, 10.0, text_height);
        enter_text.setNeedsLayout();
        enter_text.layoutIfNeeded();
        enter_text.addTarget(self, action: "started_editing", forControlEvents: UIControlEvents.TouchDown);
        enter_text.delegate = self;
        var commit_width = text_height;
        commit_button.backgroundColor = UIColor.grayColor();
        commit_button.setTitle("ADD", forState: UIControlState.Normal);
        commit_button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        commit_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted);
        add_subview(commit_button, super_view, 0.0, frame_height - text_height + 1.0, frame_width - commit_width, 0.0);
        commit_button.addTarget(self, action: "add_new_palette", forControlEvents: UIControlEvents.TouchUpInside);
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE ADD TABLE VIEW
        //-------------------------------------------------------------------------------------------
        palette_table.dataSource = palette_data;
        palette_table.delegate = pallettes_controller;
        add_subview(palette_table, super_view, picker_height - 1.0, 0.0, 0.0, 0.0);
        palette_table.backgroundColor = UIColor.lightGrayColor();
        palette_table.separatorStyle = UITableViewCellSeparatorStyle.None;
        palette_table.registerClass(paletteTableViewCell.self, forCellReuseIdentifier: "cell");
        
        // tag table so we can use different color cells fromt those in PaletteController
        palette_table.tag = ADD_PALETTE_TABLE_TAG;
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

class NotificationController: UIViewController
{
    var notification_text:String = String();
    var notification_label = UILabel();
    var super_view = UIView();
    var visible = false;
    var alpha_val:CGFloat = 0.0;
    var ascending:Bool = true;
    var peaking:Bool = false;
    var peak_count:Int = 0;
    var timer = NSTimer();
    
    override func viewDidLoad()
    {
        picker_controller.color_view.layoutIfNeeded();
        picker_controller.color_view.setNeedsLayout();
        picker_controller.favorite_button.layoutIfNeeded();
        picker_controller.favorite_button.setNeedsLayout();
        var color_height = picker_controller.color_view.bounds.height;
        var color_width = picker_controller.color_view.bounds.width;
        var fav_height = picker_controller.favorite_button.bounds.height;
        var fav_width = picker_controller.favorite_button.bounds.width;
        var width:CGFloat = color_width - (fav_width * 2.0);
        var height:CGFloat = fav_height;
        
        super_view = self.view;
        super_view.frame = CGRect(x: margin + BUTTON_DIM, y: margin + (color_height - BUTTON_DIM), width: width, height: height);
        super_view.bounds = CGRect(x: 0.0, y: 0.0, width: width+2.0, height: height);
        
        add_subview(notification_label, super_view, 1.0, 1.0, 1.0);
        notification_label.text = notification_text;
        notification_label.textAlignment = NSTextAlignment.Center;
        notification_label.textColor = UIColor.blackColor();
        notification_label.font = UIFont.systemFontOfSize(12.0);
        notification_label.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5);
        notification_label.layer.borderWidth = 0.5;
        notification_label.alpha = 0.0;
        super_view.addSubview(notification_label);
        super.viewDidLoad()
    }
    
    func set_text(var in_text:String)
    {
        notification_label.text = in_text;
    }
    
    func bring_up()
    {
        if(!visible)
        {
            visible = true;
        }
        else
        {
            // invalidate current timer and reset values
            timer.invalidate();
            alpha_val = 0.0;
            ascending = true;
            peaking = false;
            peak_count = 0;
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: "animate", userInfo: nil, repeats: true);
    }
    
    func animate()
    {
        if(ascending)
        {
            alpha_val += 0.5;
            if(alpha_val > 1.0)
            {
                ascending = false;
                peaking = true;
                alpha_val = 1.0;
            }
        }
        else if(peaking)
        {
            ++peak_count;
            if(peak_count == 20)
            {
                peaking = false;
                peak_count = 0; // reset
            }
        }
        else    // descending
        {
            alpha_val -= 0.02;
            if(alpha_val < 0)
            {
                alpha_val = 0.0;
                ascending = true;
                peaking = false;
                timer.invalidate();
                visible = false;
            }
        }
        
        notification_label.alpha = alpha_val;
        
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