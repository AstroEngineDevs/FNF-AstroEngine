package funkin.backend.funkinLua.luaStuff;

import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.util.FlxColor;
import funkin.game.states.PlayState;

class ModchartText extends flixel.text.FlxText
{
	public var wasAdded:Bool = false;
	public function new(x:Float, y:Float, text:String, width:Float)
	{
		super(x, y, width, text, 16);
		setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		cameras = [PlayState.instance.camHUD];
		scrollFactor.set();
		borderSize = 2;
	}
}