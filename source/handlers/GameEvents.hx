package handlers;

class GameEvents
{
	public static function exitOn(?type:Int = 0, ?traceE:Bool = false)
	{
		if (traceE)
			trace("Exit at " + Date.now().toString());

		Sys.exit(type);
	}
}
