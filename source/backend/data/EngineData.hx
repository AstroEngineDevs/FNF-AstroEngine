package backend.data;

import haxegithub.utils.Repository;
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
		coreVersion: '0.2.2',
		colorMenuImage: 0xff525252,
		mainRepo: "https://github.com/Hackx2/FNF-AstroEngine",
		commits: Repository.get('hackx2', 'FNF-AstroEngine/commits'),
	}

	//** ignore this **/
	public function new()
	{
        super();

		if (backend.utils.ClientPrefs.data.lowQuality)
			backend.utils.ClientPrefs.data.mouseEvents = false;
	}
}