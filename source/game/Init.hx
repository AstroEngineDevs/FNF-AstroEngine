package game;

import flixel.input.keyboard.FlxKey;

class Init extends MusicBeatState

{
	override function create()
	{

		backend.utils.Paths.clearStoredMemory();
		backend.utils.Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		backend.utils.Paths.pushGlobalMods();
		backend.data.WeekData.loadTheFirstEnabledMod();
		#end

		Logs.init();
		Volume.init();
		backend.utils.ClientPrefs.init();
		backend.Highscore.load();

		super.create();

		FlxG.save.bind('funkin', backend.CoolUtil.getSavePath());

		MusicBeatState.switchState(new game.states.TitleState());
	}
}

class Volume {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static function init(){
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];
	}
}

class Logs // Modded trace func
{
	public static function init()
	{
		haxe.Log.trace = tracev2;
	}

	static function tracev2(v:Dynamic, ?infos:haxe.PosInfos):Void
	{
		final ddd = infos.fileName + ":" + infos.lineNumber;
		if (infos != null && infos.customParams != null)
		{
			var extra:String = "";
			for (v in infos.customParams)
				extra += "," + v;
			#if debug
				Sys.println('[Astro Engine]: ${v + extra} : $ddd');
			#else
				Sys.println('[Astro Engine]: ${v + extra}');
			#end
		}
		else
			#if debug
				Sys.println('[Astro Engine]: $v : $ddd');
			#else
			Sys.println('[Astro Engine]: $v');
			#end
	}
}
