package funkin.game.objects.scorebars;

import flixel.util.FlxStringUtil;
import funkin.backend.Highscore;

class AstroScore extends BaseScorebar
{
	private final yVal:Float = game.healthBarBG.y;
	private var scoreText:FlxText;
	private var watermark:FlxText;
	private var songLeft:FlxText;
	private var versionTxtSmth:FlxText;
	// erm :3c
	private var sickTxt:FlxText;
	private var goodsTxt:FlxText;
	private var badTxt:FlxText;
	private var shitsTxt:FlxText;
	private var missTxt:FlxText;

	override function create()
	{
		super.create();

		scoreText = new FlxText(0, yVal + 36, FlxG.width, "ermOwo?", 20);
		scoreText.scrollFactor.set();
		scoreText.borderSize = 1.25;
		scoreText.visible = !ClientPrefs.data.hideFullHUD;
		scoreText.setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scoreText);

		watermark = new FlxText(40, yVal + 37, 0, "", 16);
		watermark.setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		watermark.scrollFactor.set();
		watermark.borderSize = 1.25;
		watermark.visible = !ClientPrefs.data.hideFullHUD;
		add(watermark);

		songLeft = new FlxText(1140, yVal + 37, 0, "0:00 • 0:00", 16);
		songLeft.setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songLeft.scrollFactor.set();
		songLeft.borderSize = 1.25;
		songLeft.visible = !ClientPrefs.data.hideFullHUD;
		add(songLeft);

		versionTxtSmth = new FlxText(FlxG.width - 320, 10, 400, "Astro Engine: v" + EngineData.engineData.coreVersion, 32);
		versionTxtSmth.setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionTxtSmth.scrollFactor.set();
		versionTxtSmth.updateHitbox();
		versionTxtSmth.visible = !ClientPrefs.data.hideFullHUD;
		add(versionTxtSmth);

		watermark.text = PlayState.SONG.song.formatText() + " • " + CoolUtil.difficulties[PlayState.storyDifficulty];
		addCurveBG(watermark.x - 10, scoreText.y + 4.5, watermark.fieldWidth + 20, 35, 35, 0, game.uiBackgroundGroup); // WaterMark
		addCurveBG(game.healthBarBG.x, scoreText.y + 4.5, 600, 35, 35, 0, game.uiBackgroundGroup); // ScoreBar
		addCurveBG(songLeft.x - 12.5, scoreText.y + 4.5, 125, 35, 35, 0, game.uiBackgroundGroup); // TimeBar (Alt)

		songLeft.y += 10;
		watermark.y += 10;
		scoreText.y += 10;

		// SHIT YOU DONT WANNA LOOK AT OWO
		if (ClientPrefs.data.showRatingStats) // if i aint broke dont fix it -psy
		{
			final main_y:Int = 264;
			final x:Int = 40;
			final y:Int = 40;

			var MAIN_SIZE:Int = 24;
			sickTxt = new FlxText(x, main_y, 0, "SICKS: 000",
				MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			sickTxt.visible = !ClientPrefs.data.hideFullHUD;
			add(sickTxt);
			addCurveBG(sickTxt.x - 10, sickTxt.y - 2.5, sickTxt.fieldWidth - 10, 35, 35, 0, game.uiBackgroundGroup);

			goodsTxt = new FlxText(x, main_y, 0, "GOODS: 000",
				MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			goodsTxt.visible = !ClientPrefs.data.hideFullHUD;
			goodsTxt.y += y;
			add(goodsTxt);
			addCurveBG(goodsTxt.x - 10, goodsTxt.y - 2.5, sickTxt.fieldWidth - 10, 35, 35, 0, game.uiBackgroundGroup);

			badTxt = new FlxText(x, main_y, 0, "BAD: 000",
				MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			badTxt.visible = !ClientPrefs.data.hideFullHUD;
			badTxt.y = goodsTxt.y + y;
			add(badTxt);
			addCurveBG(badTxt.x - 10, badTxt.y - 2.5, sickTxt.fieldWidth - 10, 35, 35, 0, game.uiBackgroundGroup);

			shitsTxt = new FlxText(x, main_y, 0, "SHIT: 000",
				MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			shitsTxt.visible = !ClientPrefs.data.hideFullHUD;
			shitsTxt.y = badTxt.y + y;
			add(shitsTxt);
			addCurveBG(shitsTxt.x - 10, shitsTxt.y - 2.5, sickTxt.fieldWidth - 10, 35, 35, 0, game.uiBackgroundGroup);

			missTxt = new FlxText(x, main_y, 0, "MISS: 000",
				MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			missTxt.visible = !ClientPrefs.data.hideFullHUD;
			missTxt.y = shitsTxt.y + y;
			add(missTxt);
			addCurveBG(missTxt.x - 10, missTxt.y - 2.5, sickTxt.fieldWidth - 10, 35, 35, 0, game.uiBackgroundGroup);
		}
	}

	override function update(f)
	{
		super.update(f);

		songLeft.text = FlxStringUtil.formatTime(Math.max(0, Math.floor((Conductor.songPosition - ClientPrefs.data.noteOffset) / 1000)), false)
			+ " • "
			+ FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}

	override function updateShit()
	{
		super.updateShit();
		scoreText.text = 'Score: '
			+ game.songScore
			+ ' • Misses: '
			+ game.songMisses
			+ ' • Rating: '
			+ game.ratingName
			+ (game.ratingName != '?' ? ' (${Highscore.floorDecimal(game.ratingPercent * 100, 2)}%) - ${game.ratingFC}' : '');

		if (ClientPrefs.data.showRatingStats)
		{
			sickTxt.text = 'Sick: ${game.sicks}';
			goodsTxt.text = 'Good: ${game.goods}';
			badTxt.text = 'Bad: ${game.bads}';
			shitsTxt.text = 'Shit: ${game.shits}';
			missTxt.text = 'Miss: ${game.songMisses}';
		};
	}

	private function addCurveBG(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, ellipseWidthAndHeight:Int = 0, startAlpha:Int = 0,
			?group:FlxTypedGroup<Dynamic>)
	{
		final width = Std.int(width);
		final height = Std.int(height);

		final helloLmao = new FlxSprite(x, y).makeGraphic(width, height, FlxColor.TRANSPARENT, false);
		flixel.util.FlxSpriteUtil.drawRoundRect(helloLmao, 0, 0, width, height, ellipseWidthAndHeight, ellipseWidthAndHeight, FlxColor.BLACK);
		helloLmao.alpha = startAlpha;
		if (group != null)
			group.insert(game.members.indexOf(game.uiGroup), helloLmao);
	}
}
