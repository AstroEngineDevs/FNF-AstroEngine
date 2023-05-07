package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

import Alphabet;
import psy.Core;
import backend.StatChangeables;

using StringTools;

class Stats extends MusicBeatState
{
	private var bg:FlxSprite;
	private var text:FlxText;
	private var textBG:FlxSprite;

	private var statsTxt:Alphabet;
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var curSelected:Int = 0;

	var stats:Array<Array<Dynamic>> = [
        ["Best Score", StatChangeables.MAX_SCORE],
		["Most Misses", StatChangeables.MOST_MISSES],
    ];

	override function create() {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		StatChangeables.loadStats();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = Core.mainCoreShit.colorMenuImage;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...stats.length)
		{
			statsTxt = new Alphabet(0, 200, "N/A: 0000", false);
			statsTxt.screenCenter();
			statsTxt.text = stats[i][0] + ": " + stats[i][1];
			statsTxt.alpha = 0.6;
			statsTxt.isMenuItemCenter = true;
			statsTxt.targetY = i;
			statsTxt.changeX = false;
			grpTexts.add(statsTxt);
		}

		textBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.scrollFactor.set(0, 0);
		textBG.alpha = 0.6;
		add(textBG);

		text = new FlxText(textBG.x, textBG.y + 4, FlxG.width, "Press RESET to clear stats!", 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER);
		text.scrollFactor.set(0, 0);
		add(text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new options.OptionsState());
			FlxG.sound.play(Paths.sound('cancelMenu'));
			StatChangeables.saveStats();
		}

		if(controls.RESET)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				StatChangeables.resetStats();
				MusicBeatState.switchState(FlxG.state);
			}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = stats.length - 1;
		if (curSelected >= stats.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0){
				item.alpha = 1;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
