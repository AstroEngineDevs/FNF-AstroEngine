package options;

#if desktop
import Discord.DiscordClient;
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
import Controls;
import openfl.Lib;

using StringTools;

class StudioSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Studio';
		rpcTitle = 'Studio Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Hide HUD', // Name
			'Hide\'s all HUD elements\nimproves performance.', // Description
			'hideFullHUD', // hideFullHUD
			'bool', // Variable type
			false); // Default value
		addOption(option);
		option.onChange = onChangefuckmedaddy;

		var option:Option = new Option('Botplay', // Name
			'It\'s fucking botplay', // Description
			'botplayStudio', // hideFullHUD
			'bool', // Variable type
			false); // Default value
		addOption(option);

		super();
	}

	function onChangefuckmedaddy()
	{
		if (ClientPrefs.hideFullHUD){
			ClientPrefs.showFPS = false;
		}else{
			ClientPrefs.showFPS = true;
		}

		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
}