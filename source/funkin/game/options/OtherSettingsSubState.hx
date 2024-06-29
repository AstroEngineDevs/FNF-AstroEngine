package funkin.game.options;

import funkin.backend.utils.ClientPrefs;
#if desktop
import funkin.backend.client.Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxCamera;
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
import funkin.backend.utils.Controls;
import openfl.Lib;
import funkin.game.options.*;

using StringTools;

class OtherSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Other';
		rpcTitle = 'Other Settings'; //for Discord Rich Presence

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Note Splashes Type:',
			"Different Note Splashes",
			'noteSplashesType',
			'string',
			'normal',
			['normal', 'diamond']);
		addOption(option);

		var option:Option = new Option('Force Splashes',
		"Override current notesplash",
		'forceNoteSplashes',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Opponent Note Splashes',
			"It's in the fucking name nerd",
			'opnoteSplashes',
			'bool',
			true);
		addOption(option);

		#if DISCORD_ALLOWED
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord",
			'discordRPC',
			'bool');
		addOption(option);
		option.onChange = onChangediscord;
		#end

		var option:Option = new Option('Hide HUD',
			'Hide\'s all HUD elements\nimproves performance.',
			'hideFullHUD',
			'bool',
			false);
		addOption(option);
		option.onChange = onChangefuckmedaddy;

		var option:Option = new Option('Botplay',
			'It\'s fucking botplay', 
			'botplayStudio',
			'bool',
			false);
		addOption(option);

		super();
	}

	function onChangediscord() {
		var fr = ClientPrefs.data.discordRPC;
		if (fr)
			DiscordClient.initialize();
		else
			DiscordClient.shutdown();
	}

	function onChangefuckmedaddy()
	{
		if (ClientPrefs.data.hideFullHUD){
			ClientPrefs.data.showFPS = false;
		}else{
			ClientPrefs.data.showFPS = true;
		}

		if(funkin.game.Main.fpsVar != null)
			funkin.game.Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
}