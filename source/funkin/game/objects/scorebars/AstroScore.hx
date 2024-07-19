package funkin.game.objects.scorebars;

import flixel.util.FlxStringUtil;
import funkin.backend.Highscore;

class AstroScore extends BaseScorebar
{
	private final yVal:Float = game.healthBarBG.y;
	var scoreText:FlxText;
	var watermark:FlxText;
	var songLeft:FlxText;
	var versionTxtSmth:FlxText;
	// erm :(c
	var sickTxt:FlxText;
	var goodsTxt:FlxText;
	var badTxt:FlxText;
	var shitsTxt:FlxText;
	var missTxt:FlxText;

	override function create()
	{
		super.create();

		scoreText = new FlxText(0, yVal + 36, FlxG.width, "ermOwo?", 20);
		scoreText.scrollFactor.set();
		scoreText.borderSize = 1.25;
		scoreText.visible = !ClientPrefs.data.hideFullHUD;
		scoreText.alpha = 0;
		scoreText.setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scoreText);

		watermark = new FlxText(40, game.healthBarBG.y + 37, 0, "", 16);
		watermark.setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		watermark.scrollFactor.set();
		watermark.borderSize = 1.25;
		watermark.alpha = 0;
		watermark.visible = !ClientPrefs.data.hideFullHUD;
		add(watermark);

		songLeft = new FlxText(1140, game.healthBarBG.y + 37, 0, "0:00 • 0:00", 16);
		songLeft.setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songLeft.scrollFactor.set();
		songLeft.alpha = 0;
		songLeft.borderSize = 1.25;
		songLeft.visible = !ClientPrefs.data.hideFullHUD;
		add(songLeft);

		versionTxtSmth = new FlxText(FlxG.width - 320, 10, 400, "Astro Engine: v" + EngineData.engineData.coreVersion, 32);
		versionTxtSmth.setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionTxtSmth.scrollFactor.set();
		versionTxtSmth.alpha = 0;
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

		var main_y:Int = 264;
		var x:Int = 120;
		var y:Int = 40;

		var MAIN_SIZE:Int = 24;
		sickTxt = new FlxText(x, main_y, 0, "SICKS: 000",
			MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		sickTxt.visible = !ClientPrefs.data.hideFullHUD;
		sickTxt.alpha = 0;
		sickTxt.x = FlxG.width - (sickTxt.width + 55);
		add(sickTxt);

		goodsTxt = new FlxText(x, main_y, 0, "GOODS: 000",
			MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		goodsTxt.visible = !ClientPrefs.data.hideFullHUD;
		goodsTxt.x = FlxG.width - (sickTxt.width + 55);
		goodsTxt.y += y;
		goodsTxt.alpha = 0;
		add(goodsTxt);

		badTxt = new FlxText(x, main_y, 0, "BAD: 000",
			MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		badTxt.visible = !ClientPrefs.data.hideFullHUD;
		badTxt.x = FlxG.width - (sickTxt.width + 55);
		badTxt.alpha = 0;
		badTxt.y = goodsTxt.y + y;
		add(badTxt);

		shitsTxt = new FlxText(x, main_y, 0, "SHIT: 000",
			MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		shitsTxt.visible = !ClientPrefs.data.hideFullHUD;
		shitsTxt.x = FlxG.width - (sickTxt.width + 55);
		shitsTxt.y = badTxt.y + y;
		shitsTxt.alpha = 0;
		add(shitsTxt);

		missTxt = new FlxText(x, main_y, 0, "MISS: 000",
			MAIN_SIZE).setFormat(Paths.font("PhantomMuff.ttf"), MAIN_SIZE, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missTxt.visible = !ClientPrefs.data.hideFullHUD;
		missTxt.x = FlxG.width - (sickTxt.width + 55);
		missTxt.y = shitsTxt.y + y;
		missTxt.alpha = 0;
		add(missTxt);
	}

	override function update(f)
	{
		super.update(f);

		final curTime:Float = Conductor.songPosition - ClientPrefs.data.noteOffset;
		songLeft.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false)
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
		
		sickTxt.text = 'Sick: ${game.sicks}';
		goodsTxt.text = 'Good: ${game.goods}';
		badTxt.text = 'Bad: ${game.bads}';
		shitsTxt.text = 'Shit: ${game.shits}';
		missTxt.text = 'Miss: ${game.songMisses}';
	}

	private function addCurveBG(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, ellipseWidthAndHeight:Int = 0, startAlpha:Int = 0,
			?group:FlxTypedGroup<Dynamic>,)
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
