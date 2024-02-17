package backend.data;

import flixel.FlxSprite;
using StringTools;

@:final class EngineData extends FlxSprite
{
    //** Customization **/
	public static var coreGame = {
		coreDiscordID: "1095422496473358356",
	}

    //** Other Shit **/
	public static var mainCoreShit = {
		coreVersion: '0.6',
		colorMenuImage: 0xff525252,
		mainRepo: "https://github.com/Hackx2/FNF-AstroEngine",
	}

	//** ignore this **/
	public function new()
	{
        super();
		if (backend.utils.ClientPrefs.lowQuality)
			backend.utils.ClientPrefs.mouseEvents = false;
	}
}