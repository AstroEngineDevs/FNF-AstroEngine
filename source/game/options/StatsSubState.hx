package game.options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

import game.objects.Alphabet;
import backend.data.*;
import backend.StatChangeables;
import backend.system.MusicBeatSubstate;
import backend.utils.Paths;
#if desktop
import backend.client.Discord.DiscordClient;
#end
using StringTools;

class StatsSubState extends MusicBeatSubstate
{
	private var bg:FlxSprite;
	private var text:FlxText;
	private var textBG:FlxSprite;

	private var statsTxt:game.objects.Alphabet;
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var curSelected:Int = 0;

	var stats:Array<Array<Dynamic>> = [
        ["Best Score", StatChangeables.MAX_SCORE],
		["Most Misses", StatChangeables.MOST_MISSES],
    ];
	public function new() {
		super();

		StatChangeables.loadStats();

		#if desktop
		DiscordClient.changePresence("Viewing Stats", null);
		#end
		
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = EngineData.mainCoreShit.colorMenuImage;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = backend.utils.ClientPrefs.globalAntialiasing;
		add(bg);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...stats.length)
		{
			statsTxt = new Alphabet(0, 200, "N/A: 0000", false);
			statsTxt.screenCenter();
			statsTxt.text = stats[i][0] + ": " + stats[i][1];
			statsTxt.isMenuItemCenter = true;
			statsTxt.targetY = i;
			statsTxt.ID = i;
			statsTxt.changeX = false;
			grpTexts.add(statsTxt);
		}

		textBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.scrollFactor.set(0, 0);
		textBG.alpha = 0.6;
		add(textBG);

		text = new FlxText(textBG.x, textBG.y + 4, FlxG.width, "Press RESET to clear stats!", 18);
		text.setFormat(backend.utils.Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER);
		text.scrollFactor.set(0, 0);
		add(text);

		
		changeSelection();
	}

	override function update(elapsed:Float)
	{

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
			close();
			FlxG.sound.play(backend.utils.Paths.sound('cancelMenu'));
			StatChangeables.saveStats();
		}

		if(controls.RESET)
			{
				FlxG.sound.play(backend.utils.Paths.sound('cancelMenu'));
				StatChangeables.resetStats();
				//MusicBeatSubState.switchState(FlxG.state);
				openSubState(new StatsSubState());
			}

		super.update(elapsed);
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

			if (item.ID == curSelected){
				item.alpha = 1;
			}
		}
		FlxG.sound.play(backend.utils.Paths.sound('scrollMenu'));
	}
}
