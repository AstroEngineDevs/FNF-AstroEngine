package backend.data;

import flixel.FlxSprite;

using StringTools;

@:final class EngineData
{
    //** Customization **/
	public static final coreGame = {
		coreDiscordID: "1095422496473358356",
	}

    //** Other Shit **/
	public static final mainCoreShit = {
		coreVersion: '0.2.2',
		colorMenuImage: 0xff525252,
		mainRepo: "https://github.com/Hackx2/FNF-AstroEngine"
	}

	//** ignore this **/
	public function new()
	{
		if (backend.utils.ClientPrefs.data.lowQuality)
			backend.utils.ClientPrefs.data.mouseEvents = false;
	}
}