
import UIKit
var current_color = CustomColor(in_red: 128, in_green: 128, in_blue: 128);
var color_height = 5.0 * margin;

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
        var temp = CustomColor(color: current_color);
        
        // enforce no duplicate colors
        if(find(favorites_data.colors, current_color) == nil)
        {
            favorites_data.colors.append(CustomColor(color: current_color));
            favorites_controller.table_view.reloadData();
        }
        else    // if duplicate -> push selected duplicate to top of stack
        {
            var index = find(favorites_data.colors, temp);
            favorites_data.colors.removeAtIndex(index!);
            add_favorite();
        }
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
        favorite_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        favorite_button.backgroundColor = UIColor.lightGrayColor();
        favorite_button.setBackgroundImage(UIImage(named: "favorite"), forState: UIControlState.Normal);
        favorite_button.layer.borderWidth = 0.5;
        color_view.addSubview(favorite_button);
        var save_right = NSLayoutConstraint(item: favorite_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0);
        var save_bottom = NSLayoutConstraint(item: favorite_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0);
        var save_height = NSLayoutConstraint(item: favorite_button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: favorite_button, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -margin * 1.25);
        var save_width = NSLayoutConstraint(item: favorite_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: favorite_button, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: margin * 1.25);
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
        
        self.addChildViewController(pallete_window);
    }
    //-------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //-------------------------------------------------------------------------
}

class PaletteWindowController:UIViewController
{
    var super_view = UIView();
    var text_background = UIView();
    var enter_text = UITextField();
    var commit_button = UIButton();
    var palette_table = UITableView();
    
    func enter_name()
    {
        super_view.setNeedsLayout();
        super_view.layoutIfNeeded();
        var frame_height = super_view.frame.height;
        var frame_width = super_view.frame.width;
        var text_height = margin * 2.0;
        enter_text.backgroundColor = UIColor.whiteColor();
        enter_text.placeholder = "Add New Palette";
        add_subview(enter_text, super_view, 0.0, frame_height - text_height + 1.0, 10.0, text_height);
        enter_text.setNeedsLayout();
        enter_text.layoutIfNeeded();
        var commit_width = text_height;
        commit_button.backgroundColor = UIColor.grayColor();
        commit_button.setTitle("ADD", forState: UIControlState.Normal);
        commit_button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        commit_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted);
        add_subview(commit_button, super_view, 0.0, frame_height - text_height + 1.0, frame_width - commit_width, 0.0);
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
        super_view.backgroundColor = UIColor.lightGrayColor();
        super_view.layer.borderWidth = 1.0;
        
        //-------------------------------------------------------------------------------------------
        // CONFIGURE ADD PICKER TEXT VIEW
        //-------------------------------------------------------------------------------------------
        var picker_height = margin * 2.0;
        text_background.backgroundColor = UIColor.whiteColor();
        text_background.layer.borderWidth = 1.0;
        add_subview(text_background, super_view, 0.0, frame_height - picker_height, 0.0, 0.0);
        enter_name();
        //-------------------------------------------------------------------------------------------
        // CONFIGURE ADD TABLE VIEW
        //-------------------------------------------------------------------------------------------
        add_subview(palette_table, super_view, picker_height, 0.0, 0.0, 0.0);
        palette_table.backgroundColor = UIColor.blackColor();
        palette_table.separatorStyle = UITableViewCellSeparatorStyle.None;
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





