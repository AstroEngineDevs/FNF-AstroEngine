package funkin.backend.data;

@:final class EngineData
{
	//** Customization (Source Code Only) **/
	public static final coreGame = {
		coreDiscordID: "1095422496473358356",
		menuColor: 0xff525252,
	}

	//** ignore this **/

	public static final engineData = {
		coreVersion: '0.2.3',
		repository: "https://github.com/AstroEngineDevs/FNF-AstroEngine"
	}

	public function new()
	{
		if (funkin.backend.utils.ClientPrefs.data.lowQuality)
			funkin.backend.utils.ClientPrefs.data.mouseEvents = false;
	}
}
