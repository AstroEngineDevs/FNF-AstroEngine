package psy;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

using StringTools;

class Core extends FlxSprite
{
    //** Customization **/
	public static var coreGame = {
		coreDiscordID: "1095422496473358356",
		mouseEvents: true, // Desktop Only! (i guess unless you plug a mouse into your Phone/Ipad or smth)
	}
    // public static var coreDiscordID:String = "1095422496473358356";
    // public static var mouseEvents:Bool = false; // Desktop Only! (i guess unless you plug a mouse into your Phone/Ipad or smth)

    //** Other Shit **/
    public static var coreVersion:String = '1.5.2';
    public static var colorMenuImage:FlxColor = 0xff525252;

	public function new()
	{
		super();
        
		if (ClientPrefs.lowQuality) { // yeah a lot of shit | Also the mouse lags sometimes
			coreGame.mouseEvents = false;
		}
	}
}