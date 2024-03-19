package game.options;

import backend.utils.ClientPrefs;
#if desktop
import backend.client.Discord.DiscordClient;
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
import backend.utils.Controls;
import openfl.Lib;
import game.options.*;

using StringTools;

class OtherSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Other';
		rpcTitle = 'Other Settings'; //for Discord Rich Presence

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

		if(game.Main.fpsVar != null)
			game.Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
}