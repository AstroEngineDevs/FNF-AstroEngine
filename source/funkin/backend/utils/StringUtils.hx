package funkin.backend.utils;

class StringUtils
{
	/**
	 * Formats first:String by removing "-" & Making every word a Cap
	 * @param x Input
	 * @param y Will be changed to " " instead of y
	 * @return Converted String 
	**/
	public inline static function formatText(x:String, ?y:String = '-'):String
	{
		return StringTools.replace(x, y, " ").capitalize();
	}

	/**
	 * Capitalizes Text
	 * @param x Input
	 * @return Converted String 
	**/
	public inline static function capitalize(x:String):String
	{
		return x.split(" ").map(s -> s.charAt(0).toUpperCase() + s.substr(1)).join(" ");
	}

	/**
	 * Resets Map to a value of your choosing
	 * @param map Input
	 * @param resetVal Optional the reset value
	 * @return Resetted Map
	**/
	public static function resetMap(map:Map<Dynamic, Dynamic>, ?resetVal:Dynamic = false)
	{
		for (i in map.keys())
			map.set(i, resetVal);
	}
}
