package funkin.game.objects.scorebars;
class VSliceScore extends BaseScorebar
{
	private var scoreText:FlxText;

	override function create()
	{
		super.create();

		scoreText = new FlxText(0, defaultPos.y + 36, FlxG.width, "", 20);
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
		scoreText.text = 'Score: ' + PlayState.instance.songScore;
	}
}
