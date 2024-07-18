package funkin.backend.utils;
class StringUtils
{
	/**
		Formats first:String by removing "-" & Making every word a Cap
	**/
	public inline static function formatText(first:String, ?toRemove:String = '-'):String
	{
		/* Like fuck off dude :3c */
		/* Let me cook dude :Dc */
		return StringTools.replace(first, toRemove, " ")
			.split(" ")
			.map(s -> s.charAt(0).toUpperCase() + s.substr(1))
			.join(" ");
	}
}
