package funkin.game.states;

import flixel.FlxState;
import flixel.FlxSubState;
import haxe.extern.EitherType;
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
import funkin.game.states.*;

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
	final menuButtons:Array<MenuItemsStructure> = [
		{
			name: 'story_mode',
			state: new StoryMenuState()
		},
		{
			name: 'freeplay',
			state: new FreeplayState()
		},		
		#if MODS_ALLOWED
		{
			name: 'mods',
			state: new ModsMenuState()
		}
		#end,
		#if ACHIEVEMENTS_ALLOWED
		{
			name: 'awards',
			state: new AchievementsMenuState()
		}
		#end,
		{
			name: 'credits',
			state: new CreditsState()
		},
		#if !switch
		{
			name: 'donate',
			link: 'https://ninja-muffin24.itch.io/funkin'
		}#end,
		{
			name: 'options',
			state: new OptionsState()
		}
	];
	// Versons
	final engineVersions:Array<MenuVersionStructure> = [
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
		FlxG.mouse.visible = true;

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
		var yScroll:Float = Math.max(0.25 - (0.05 * (menuButtons.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.color = bgColor;
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
		for (i in 0...menuButtons.length)
		{
			var offset:Float = 108 - (Math.max(menuButtons.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			menuItem.scale.x = 1;
			menuItem.scale.y = 1;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + menuButtons[i].name);
			menuItem.animation.addByPrefix('idle', menuButtons[i].name + " basic", 24);
			menuItem.animation.addByPrefix('selected', menuButtons[i].name + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (menuButtons.length - 4) * 0.135;
			if (menuButtons.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.data.globalAntialiasing;
			menuItem.updateHitbox();
			MouseUtil.MOUSESUPPORT(menuItem, {
				onClick: (_) -> onStateChange(),
				selectedSomethin: selectedSomethin,
				selectedSomethinMouse: selectedSomethinMouse,
				onHover: () ->
				{
					if(curSelected == i) return;

					FlxG.sound.play(Paths.sound('scrollMenu'));
					curSelected = i;
					changeItem();
				}
			});
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
				onStateChange();
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

	function onStateChange():Void
	{
		if (menuButtons[curSelected].link != null)
			CoolUtil.browserLoad(menuButtons[curSelected].link);
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
						var daChoice:EitherType<FlxState,FlxSubState> = menuButtons[curSelected].state;

						if(Std.is(daChoice, FlxState))
							MusicBeatState.switchState(daChoice);
						else 
							openSubState(daChoice);
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
