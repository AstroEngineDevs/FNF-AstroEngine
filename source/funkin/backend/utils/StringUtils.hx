package funkin.backend.utils;

class StringUtils {
    public static function formatShit(first:String)
		{
			// like fuck off dude :3c
			return StringTools.replace(first, "-", " ")
				.split(" ")
				.map(s -> s.charAt(0).toUpperCase() + s.substr(1))
				.join(" ");
		}
}