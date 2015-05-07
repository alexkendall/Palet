
import UIKit
var current_color = CustomColor(in_red: 128, in_green: 128, in_blue: 128);

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
    var save_button = UIButton();
    var shades = Array<UIButton>();
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    func add_favorite()
    {
        var temp = CustomColor(color: current_color);
        
        // enforce no duplicate colors
        if(find(app_data.favorites, current_color) == nil)
        {
            app_data.favorites.append(CustomColor(color: current_color));
            favorites_controller.table_view.reloadData();
        }
        else    // if duplicate -> push selected duplicate to top of stack
        {
            var index = find(app_data.favorites, temp);
            app_data.favorites.removeAtIndex(index!);
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
        var height = NSLayoutConstraint(item: color_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Width, multiplier: 0.0, constant: margin * 5.0);
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
        save_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        save_button.backgroundColor = UIColor.lightGrayColor();
        save_button.setBackgroundImage(UIImage(named: "favorite"), forState: UIControlState.Normal);
        save_button.layer.borderWidth = 0.5;
        color_view.addSubview(save_button);
        var save_right = NSLayoutConstraint(item: save_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0);
        var save_bottom = NSLayoutConstraint(item: save_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: color_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0);
        var save_height = NSLayoutConstraint(item: save_button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: save_button, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -margin * 1.25);
        var save_width = NSLayoutConstraint(item: save_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: save_button, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: margin * 1.25);
        // add constraints
        color_view.addConstraint(save_right);
        color_view.addConstraint(save_bottom);
        color_view.addConstraint(save_height);
        color_view.addConstraint(save_width);
        
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
        
        // add action for saving color
        save_button.addTarget(self, action: "add_favorite", forControlEvents: UIControlEvents.TouchUpInside);
    }
    //-------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //-------------------------------------------------------------------------
}