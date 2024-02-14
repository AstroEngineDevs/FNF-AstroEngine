package backend.core;

import flixel.FlxSprite;

using StringTools;

class Core extends FlxSprite
{
    //** Customization **/
	public static var coreGame = {
		coreDiscordID: "1095422496473358356",
	}

    //** Other Shit **/
	public static var mainCoreShit = {
		coreVersion: '1.6',
		colorMenuImage: 0xff525252,
		mainRepo: "https://github.com/Hackx2/FNF-PsyEngine",
	}

	//** ignore this **/
	public function new()
	{
		super();
        
		if (ClientPrefs.lowQuality)
			ClientPrefs.mouseEvents = false;
	}
}