package funkin.backend.funkinLua.luaStuff;

class ModchartSprite extends flixel.FlxSprite
{
	public var wasAdded:Bool = false;
	public var animOffsets:Map<String, Array<Float>> = new Map<String, Array<Float>>();

	public function new(?x:Float = 0, ?y:Float = 0)
	{
		super(x, y);
		antialiasing = funkin.backend.utils.ClientPrefs.data.globalAntialiasing;
	}
}