package funkin.game.objects.scorebars;

import funkin.backend.Highscore;
import flixel.util.FlxSpriteUtil;

using StringTools;

class AstroScore extends FlxText
{
	public static var instance:AstroScore;

	public function new()
	{
		instance = this;

		super(0, PlayState.instance.healthBarBG.y + 36, FlxG.width, "", 20);

		scrollFactor.set();
		alpha = 0;
		borderSize = 1.25;
		visible = !ClientPrefs.data.hideFullHUD;
		setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	}

	public function updateShit()
	{
		text = 'Score: '
			+ PlayState.instance.songScore
			+ ' • Misses: '
			+ PlayState.instance.songMisses
			+ ' • Rating: '
			+ PlayState.instance.ratingName
			+
			(PlayState.instance.ratingName != '?' ? ' (${Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2)}%) - ${PlayState.instance.ratingFC}' : '');
	}
}
