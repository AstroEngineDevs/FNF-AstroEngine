package funkin.backend.utils.native;

import flixel.input.mouse.FlxMouseEvent;
import flixel.FlxSprite;

typedef MouseUtilStruc = {
    // Mouse shit
    var onClick:FlxSprite->Void; 
    var onHover:Void ->Void;//clicklmao

    // Selected Smth
    var selectedSomethin:Bool;
    var selectedSomethinMouse:Bool;
} 

class MouseUtil {
    public static function MOUSESUPPORT(spr:FlxSprite, data:MouseUtilStruc)
        {
            if (ClientPrefs.data.mouseEvents && !ClientPrefs.data.lowQuality)
            {
                FlxMouseEvent.add(spr, null, data.onClick, function(_)
                {
                    new FlxTimer().start(0.01, function(tmr:FlxTimer) data.selectedSomethinMouse = true);
    
                    if (!data.selectedSomethin && data.selectedSomethinMouse)
                    {
                        data.onHover();
                    }
                });
            }
        }
}