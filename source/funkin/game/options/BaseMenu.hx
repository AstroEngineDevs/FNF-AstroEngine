package funkin.game.options;

import flixel.addons.display.FlxGridOverlay;

class BaseMenu extends MusicBeatSubstate
{
	private var bg:FlxSprite;
	private var grid:FlxSprite;

	override function create()
	{
		super.create();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = EngineData.coreGame.menuColor;
		bg.screenCenter();
		bg.antialiasing = funkin.backend.utils.ClientPrefs.data.globalAntialiasing;
		add(bg);

		grid = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		var bg:FlxSprite = new FlxSprite(720).makeGraphic(FlxG.width - 720, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.25;
		add(bg);
		var bg:FlxSprite = new FlxSprite(750, 160).makeGraphic(FlxG.width - 780, 540, FlxColor.BLACK);
		bg.alpha = 0.25;
		add(bg);
	}
}
