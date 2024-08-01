package funkin.game;

import funkin.backend.handlers.CrashHandler;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import funkin.backend.utils.ClientPrefs;
#if DISCORD_ALLOWED
import funkin.backend.client.Discord.DiscordClient;
#end
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
#end
import funkin.backend.data.*;
import funkin.game.FPS;



/*
	No need to change anything here unless you know what your doin' :3c
	If you want to add something that will run once the game has started, edit Init.hx
 */
class Main extends Sprite
{
	final game = {
		zoom: -1.0, // game state bounds
		framerate: 144, // default framerate
	};

	public static var fpsVar:FPS;

	// You can pretty much ignore everything from here on - your code should go in your game.states.

	public static function main():Void
	{
		Lib.current.addChild(new funkin.game.Main());
	}

	public static function exitOn(?type:Int = 0, ?traceE:Bool = false)
	{
		if (traceE) trace('Exited at ${Date.now().toString()}');
		Sys.exit(type);
	}

	public function new()
	{
		#if CRISP_VISUALS
		@:functionCode("
			#include <windows.h>
			setProcessDPIAware()
		")
		#end

		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / Config.gameSize[0];
			var ratioY:Float = stageHeight / Config.gameSize[1];
			game.zoom = Math.min(ratioX, ratioY);
			Config.gameSize[0] = Math.ceil(stageWidth / game.zoom);
			Config.gameSize[1] = Math.ceil(stageHeight / game.zoom);
		}

		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(Config.gameSize[0], Config.gameSize[1], Init, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, Config.skipSplash,
			Config.startFullscreen));

		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if (fpsVar != null)
			fpsVar.visible = ClientPrefs.data.showFPS;
		#end

		#if html5
		FlxG.autoPause = FlxG.mouse.visible = false;
		#end

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, CrashHandler());
		#end
	}
}
