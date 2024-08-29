package funkin.backend.utils.native;

import flixel.input.mouse.*;

typedef MouseUtilStruc =
{
	// Mouse shit
	var onClick:flixel.FlxSprite->Void;
	var onHover:Void->Void; // clicklmao

	// Selected Smth
	var selectedSomethin:Bool;
	var selectedSomethinMouse:Bool;
}

class MouseUtil
{
	private static var globalManager:FlxMouseEventManager = new FlxMouseEventManager();

	public static function MOUSESUPPORT(spr:flixel.FlxSprite, data:MouseUtilStruc)
	{
		if (ClientPrefs.data.mouseEvents && !ClientPrefs.data.lowQuality)
		{
			globalManager.add(spr, null, data.onClick, function(_)
			{
				new FlxTimer().start(0.01, function(tmr:FlxTimer) data.selectedSomethinMouse = true);

				if (!data.selectedSomethin && data.selectedSomethinMouse)
					data.onHover();
			});
		}
	}
}
