package funkin.game.states;

import funkin.backend.CoolUtil;
import funkin.backend.data.*;
#if desktop
import funkin.backend.client.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import funkin.backend.utils.ClientPrefs;
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
import funkin.game.objects.Achievements;
import funkin.game.editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import funkin.backend.data.*;
import funkin.backend.system.MusicBeatSubstate;
import funkin.backend.system.MusicBeatState;
import flixel.input.mouse.FlxMouseEvent;

/**
	Structure For Versions

	@param name Name / Astro Engine v
	@param version Version / 0.0.0
	@param offset Offsets / FlxPoint.get(X,Y)
**/
typedef VersionStructure =
{
	// Name
	var name:Null<String>;
	// Version
	var version:Null<String>;
	// Offsets | XY
	@:optional var offset:FlxPoint;
}

class MainMenuState extends MusicBeatState
{
	static var curSelected:Int = 0;

	var versionShitInt:Int = 1;

	// Group
	var menuItems:FlxTypedGroup<FlxSprite>;
	var versionTextGroup:FlxTypedGroup<FlxSprite>;

	// Cameras
	var camGame:FlxCamera;
	var camAchievement:FlxCamera;

	// Sprites
	var bgFlashing:FlxSprite;
	var camFollow:FlxObject;
	var debugKeys:Array<FlxKey>;

	// Items
	final optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	];

	final engineVersions:Array<VersionStructure> = [
		{
			name: 'Astro Engine v',
			version: EngineData.engineData.coreVersion,
			offset: FlxPoint.get(0, 0)
		},
		{
			name: 'Psych Engine v',
			version: PsychData.psychVersion,
			offset: FlxPoint.get(0, 0)
		},
		{
			name: 'Friday Night Funkin\' v',
			version: Application.current.meta.get('version'),
			offset: FlxPoint.get(0, 0)
		},
	];

	override function create()
	{
		engineVersions.reverse();

		// Updates
		persistentUpdate = persistentDraw = true;

		// Discord RPC
		#if desktop 
		DiscordClient.changePresence("Main Menu", null); 
		WindowUtil.setTitle('Main Menu');
		#end

		// Mods
		#if MODS_ALLOWED Paths.pushGlobalMods(); #end
		WeekData.loadTheFirstEnabledMod();

		// Editor Debug Keys
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		// Camera
		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// Transistions
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// Background
		var bgColor:FlxColor = EngineData.coreGame.menuColor;
		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.color = EngineData.coreGame.menuColor;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.globalAntialiasing;
		add(bg);

		if (ClientPrefs.data.flashing)
		{
			bgFlashing = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
			bgFlashing.scrollFactor.set(0, yScroll);
			bgFlashing.setGraphicSize(Std.int(bgFlashing.width * 1.175));
			bgFlashing.updateHitbox();
			bgFlashing.screenCenter();
			bgFlashing.visible = false;
			bgFlashing.antialiasing = ClientPrefs.data.globalAntialiasing;
			bgFlashing.color = bgColor.getDarkened(.4);
			add(bgFlashing);
		}

		// Groups
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		versionTextGroup = new FlxTypedGroup();
		add(versionTextGroup);

		// Items Loop
		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			menuItem.scale.x = 1;
			menuItem.scale.y = 1;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.data.globalAntialiasing;
			menuItem.updateHitbox();
			MOUSESUPPORT(menuItem, i);
		}

		// Version Loop
		for (i in 0...engineVersions.length)
		{
			var versionShit:FlxText = new FlxText(12, FlxG.height - 22 * versionShitInt, 0, engineVersions[i].name + engineVersions[i].version);
			versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			versionShit.x += engineVersions[i].offset.x;
			versionShit.y += engineVersions[i].offset.y;
			versionShit.scrollFactor.set();
			versionTextGroup.add(versionShit);

			versionShitInt++;
		}

		changeItem();

		// Achievement Check
		#if ACHIEVEMENTS_ALLOWED
		AchievementUtils.checkAndGrantAchievement('friday_night_play', camAchievement);
		#end

		super.create();

		// Camera Follow
		FlxG.camera.follow(camFollow, null, 0.15);
	}

	// TODO: make a utils file that houses this function
	private function MOUSESUPPORT(sus:FlxSprite, ?eee:Int = 0)
	{
		if (ClientPrefs.data.mouseEvents && !ClientPrefs.data.lowQuality)
		{
			FlxMouseEvent.add(sus, null, function(_) stateChangeThing(), function(_)
			{
				new FlxTimer().start(0.01, function(tmr:FlxTimer) selectedSomethinMouse = true);

				if (!selectedSomethin && selectedSomethinMouse)
				{
					if (curSelected == eee)
						return;
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curSelected = eee;
					changeItem();
				}
			});
		}
	}

	var selectedSomethin:Bool = false;
	var selectedSomethinMouse:Bool = true;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if (funkin.game.states.FreeplayState.vocals != null)
				funkin.game.states.FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
				selectedSomethinMouse = false;
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
				selectedSomethinMouse = false;
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new funkin.game.states.TitleState());
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

		menuItems.forEach(function(spr:FlxSprite) spr.screenCenter(X));
	}

	function stateChangeThing():Void
	{
		if (optionShit[curSelected] == 'donate')
			CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
		else
		{
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			if (ClientPrefs.data.flashing)
				FlxFlicker.flicker(bgFlashing, 1.1, 0.15, false);

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
								MusicBeatState.switchState(new funkin.game.states.StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new funkin.game.states.FreeplayState());
							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new funkin.game.states.ModsMenuState());
							#end
							case 'awards':
								MusicBeatState.switchState(new funkin.game.states.AchievementsMenuState());
							case 'credits':
								MusicBeatState.switchState(new funkin.game.states.CreditsState());
							case 'options':
								LoadingState.loadAndSwitchState(new funkin.game.states.OptionsState());
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
				if (menuItems.length > 4)
					add = menuItems.length * 8;
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
