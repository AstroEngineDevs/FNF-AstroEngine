package funkin.backend.utils;

class ObjectUtils
{
	/**
	* Center Object On A Sprite
	* @param spr Sprite You Want to center.
	* @param spr2 Sprite you want your sprite to be centered on.
	* @return Converted Sprite
	**/
	public static function centerOnObject(spr:flixel.FlxObject, spr2:flixel.FlxObject, axes:flixel.util.FlxAxes):flixel.FlxObject
	{
		if (axes.x)
			spr.x = (spr.width - spr2.width) / 2;
		if (axes.y)
			spr.y = (spr.height - spr2.height) / 2;

		return spr;
	}
}
