package psy;

class GameEvents
{
	public static function exitOn(type:Int = 0)
	{
		Sys.exit(type);
		trace("Exit at" + Date.now()); // dont worry...
	}
}