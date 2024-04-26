package game.states;
import backend.CoolUtil;
import backend.data.*;
#if desktop
import backend.client.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import game.objects.Achievements;
import game.editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import backend.data.*;

import backend.system.MusicBeatSubstate;
import backend.system.MusicBeatState;
#if (flixel >= "5.0.0")
	import flixel.input.mouse.FlxMouseEvent;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	];

	private var versionShitInt:Int = 1;
	private var versionShitArray:Array<Array<Dynamic>> = [// Name, Version, X, Y
		["Astro Engine v", EngineData.engineData.coreVersion, null, null],
		["Psych Engine v", PsychData.psychVersion, null, null],
		["Friday Night Funkin' v", Application.current.meta.get('version'), null, null]
	];
	private var selectedSomethinAnal:Bool = true;


	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{

		#if MODS_ALLOWED
		backend.utils.Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = backend.utils.ClientPrefs.copyKey(backend.utils.ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(backend.utils.Paths.image('menuDesat'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.color = EngineData.coreGame.menuColor;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = backend.utils.ClientPrefs.data.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(backend.utils.Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = backend.utils.ClientPrefs.data.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = backend.utils.Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = backend.utils.ClientPrefs.data.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			if (backend.utils.ClientPrefs.data.mouseEvents && !backend.utils.ClientPrefs.data.lowQuality)
			{
				
				#if (flixel >= "5.0.0") // update your fucking flixel
					FlxMouseEvent.add(menuItem, null, function(e) stateChangeThing(), function(e)
					{
						new FlxTimer().start(0.01, function (tmr:FlxTimer) {
							selectedSomethinAnal = true;
						});

						if (!selectedSomethin && selectedSomethinAnal)
						{
							curSelected = i;
							changeItem();
							FlxG.sound.play(backend.utils.Paths.sound('scrollMenu'));
						}
					});
				#end
			}
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		versionShitArray.reverse();
		for (i in 0...versionShitArray.length){// ngl it looks ugly, with all the [i]s
			if (versionShitArray[i][1] == null) versionShitArray[i][1] = "";

			var versionShit:FlxText = new FlxText(12, FlxG.height - 22 * versionShitInt, 0, versionShitArray[i][0] + versionShitArray[i][1]);
			versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			versionShit.x += versionShitArray[i][2];
			versionShit.y -= versionShitArray[i][3];
			versionShit.scrollFactor.set();
			add(versionShit);

			versionShitInt++;
		}

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();
		
		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();

		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				backend.utils.ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(backend.utils.Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(game.states.FreeplayState.vocals != null) game.states.FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(backend.utils.Paths.sound('scrollMenu'));
				changeItem(-1);
				susOWO();
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(backend.utils.Paths.sound('scrollMenu'));
				changeItem(1);
				susOWO();
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(backend.utils.Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new game.states.TitleState());
			}

			if (controls.ACCEPT)
			{
				stateChangeThing();
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function susOWO() {
		selectedSomethinAnal = false;
	}

	function stateChangeThing(){
		if (optionShit[curSelected] == 'donate')
			{
				CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
			}
		else
			{
				selectedSomethin = true;
				FlxG.sound.play(backend.utils.Paths.sound('confirmMenu'));

				if(backend.utils.ClientPrefs.data.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'story_mode':
									MusicBeatState.switchState(new game.states.StoryMenuState());
								case 'freeplay':
									MusicBeatState.switchState(new game.states.FreeplayState());
								#if MODS_ALLOWED
								case 'mods':
									MusicBeatState.switchState(new game.states.ModsMenuState());
								#end
								case 'awards':
									MusicBeatState.switchState(new game.states.AchievementsMenuState());
								case 'credits':
									MusicBeatState.switchState(new game.states.CreditsState());
								case 'options':
									LoadingState.loadAndSwitchState(new game.states.OptionsState());
							}
						});
					}
				});
			}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
