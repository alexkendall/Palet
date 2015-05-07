
// file that defines palette class

import Foundation

class Palette:NSObject
{
    var colors = Array<CustomColor>();
    var palette_id:UInt64;
    var palette_name:String = "";
    init(var name:String)
    {
        self.palette_id = palette_data.NEXT_PALETTE_ID;
        self.palette_name = name;
        palette_data.NEXT_PALETTE_ID++;
        super.init();
    }
    init(var name:String, var color:CustomColor)
    {
        self.palette_id = palette_data.NEXT_PALETTE_ID;
        self.palette_name = name;
        self.colors.append(color);
        palette_data.NEXT_PALETTE_ID++;
        super.init();
    }
    init(var name:String, var color_array:Array<CustomColor>)
    {
        self.palette_id = palette_data.NEXT_PALETTE_ID;
        self.palette_name = name;
        for(var i = 0; i < color_array.count; ++i)
        {
            colors.append(color_array[i]);
        }
        palette_data.NEXT_PALETTE_ID++;
        super.init();
    }
}
