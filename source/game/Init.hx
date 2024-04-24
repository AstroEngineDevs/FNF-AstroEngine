package game;

class Init extends MusicBeatState
{
	override function create()
	{
		Logs.init();
		backend.PlayerSettings.init();

		#if LUA_ALLOWED
		backend.utils.Paths.pushGlobalMods();
		backend.data.WeekData.loadTheFirstEnabledMod();
		#end

		super.create();

		FlxG.save.bind('funkin', backend.CoolUtil.getSavePath());

		backend.utils.ClientPrefs.loadPrefs();
		backend.Highscore.load();

		MusicBeatState.switchState(new game.states.TitleState());
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
		if (infos != null && infos.customParams != null)
		{
			var extra:String = "";
			for (v in infos.customParams)
				extra += "," + v;
			Sys.println('[Astro Engine]: ${v + extra}');
		}
		else
			Sys.println('[Astro Engine]: $v');
	}
}
