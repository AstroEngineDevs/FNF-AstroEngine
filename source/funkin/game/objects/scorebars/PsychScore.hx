package funkin.game.objects.scorebars;

class PsychScore extends BaseScorebar
{
	private final yVal:Float = game.healthBarBG.y;
	private var scoreText:FlxText;

	override function create()
	{
		super.create();

		scoreText = new FlxText(0, yVal + 36, FlxG.width, "", 20);
		scoreText.scrollFactor.set();
		scoreText.borderSize = 1.25;
		scoreText.visible = !ClientPrefs.data.hideFullHUD;
		scoreText.alpha = 0;
		scoreText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scoreText);
	}

	override function updateScore()
	{
		super.updateScore();
		scoreText.text = 'Score: '
			+ PlayState.instance.songScore
			+ ' - Misses: '
			+ PlayState.instance.songMisses
			+ ' - Rating: '
			+ PlayState.instance.ratingName
			+
			(PlayState.instance.ratingName != '?' ? ' (${Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2)}%) - ${PlayState.instance.ratingFC}' : '');
	}
}
