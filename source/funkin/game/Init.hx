package funkin.game;

import flixel.input.keyboard.FlxKey;
import funkin.backend.utils.Paths;

class Init extends MusicBeatState
{
	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		FlxG.save.bind('funkin', funkin.backend.CoolUtil.getSavePath());

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		funkin.backend.data.WeekData.loadTheFirstEnabledMod();

		#if DISCORD_ALLOWED
		DiscordClient.prepare();
		#end

		Logs.init();
		Volume.init();
		funkin.backend.Highscore.load();
		funkin.backend.utils.ClientPrefs.init();

		super.create();

		MusicBeatState.switchState(new funkin.game.states.TitleState());
	}
}

class Volume
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static function init()
	{
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];
	}
}

@:private class Logs // Modded trace func
{
	private static final fuckbaby:String = "[Astro System]"; // prefix i guess

	public static function init()
	{
		haxe.Log.trace = tracev2;
	}

	private static function tracev2(v:Dynamic, ?infos:haxe.PosInfos):Void
	{
		final nerddd = infos.fileName + ":" + infos.lineNumber;
		if (infos != null && infos.customParams != null)
		{
			var extra:String = "";
			for (v in infos.customParams)
				extra += ", " + v;
			#if debug
			Sys.println('$fuckbaby: ${v + extra} : $nerddd');
			#else
			Sys.println('$fuckbaby: ${v + extra}');
			#end
		}
		else
			#if debug
			Sys.println('$fuckbaby: $v : $nerddd');
			#else
			Sys.println('$fuckbaby: $v');
			#end
	}
}
