package game.states;

#if desktop
import backend.client.Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import backend.utils.Controls;
import backend.StatChangeables;
import game.options.*;

import backend.system.MusicBeatSubstate;
import backend.system.MusicBeatState;
using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Graphics', 'Gameplay','Stats', 'Visuals and UI', 'Adjust Delay and Combo', 'Other'];
	private var grpOptions:FlxTypedGroup<game.objects.Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new NotesSubState());
			case 'Controls':
				openSubState(new ControlsSubState());
			case 'Graphics':
				openSubState(new GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new VisualsUISubState());
			case 'Gameplay':
				openSubState(new GameplaySettingsSubState());
			case 'Stats':
				openSubState(new StatsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new NoteOffsetState());
			case 'Other':
				openSubState(new OtherSettingsSubState());
		}
	}

	var selectorLeft:game.objects.Alphabet;
	var selectorRight:game.objects.Alphabet;

	var OFFSETFUCKME:Int = 200;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		StatChangeables.loadStats();

		var bg:FlxSprite = new FlxSprite().loadGraphic(backend.utils.Paths.image('menuDesat'));
		bg.color = 0xff525252;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = backend.utils.ClientPrefs.data.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<game.objects.Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:game.objects.Alphabet = new game.objects.Alphabet(0, OFFSETFUCKME, options[i], true);
			optionText.screenCenter();	
			optionText.isMenuItemCenter = true;
			//optionText.changeY = false;
			optionText.changeX = false;
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new game.objects.Alphabet(0, OFFSETFUCKME, '>', true);
		selectorLeft.isMenuItem = true;
		selectorLeft.changeX = false;
		add(selectorLeft);
		selectorRight = new game.objects.Alphabet(0, OFFSETFUCKME, '<', true);
		selectorRight.isMenuItem = true;
		selectorRight.changeX = false;
		add(selectorRight);

		changeSelection();
		backend.utils.ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		backend.utils.ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(backend.utils.Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new game.states.MainMenuState());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;

				/* 
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y - 170;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y - 170;
				*/
			}
		}
		FlxG.sound.play(backend.utils.Paths.sound('scrollMenu'));
	}
}