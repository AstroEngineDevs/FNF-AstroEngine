package funkin.game.objects.scorebars;

import funkin.backend.Highscore;
import flixel.util.FlxSpriteUtil;

using StringTools;

class NormalScore extends FlxText
// TODO: Turn into FlxBasic Objects
{
	public static var instance:NormalScore;

	public function new()
	{
		instance = this;

		super(0, PlayState.instance.healthBarBG.y + 36, FlxG.width, "", 20);

		scrollFactor.set();
		alpha = 0;
		borderSize = 1.25;
		visible = !ClientPrefs.data.hideFullHUD;
		setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	}

	public function updateShit()
	{
		text = 'Score: ' + PlayState.instance.songScore;
	}
}
