package funkin.backend.handlers;

#if VIDEOS_ALLOWED
import hxcodec.flixel.FlxVideo;
import flixel.FlxState;

class VidHandler extends MusicBeatState
{
	private static var _video:FlxVideo;
	private static var _videoString:String = '';
	private static var _returnState:FlxState;

	override function create()
	{
		super.create();

		if (FlxG.sound.music != null)
			FlxG.sound.music.fadeOut(1, 0, function(_) FlxG.sound.music.stop());
		if (funkin.game.Main.fpsVar != null)
			funkin.game.Main.fpsVar.visible = false;
		FlxG.mouse.visible = false;
		_video = new FlxVideo();
		_video.play(Paths.video(_videoString));
		_video.onEndReached.add(function()
		{
			if (funkin.game.Main.fpsVar != null)
				funkin.game.Main.fpsVar.visible = ClientPrefs.data.showFPS;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			FlxG.mouse.visible = true;
			_video.dispose();
			MusicBeatState.switchState(_returnState);
			return;
		});
	}

	public static function startVideo(videoName:String, returnStateName:Null<flixel.FlxState>)
	{
		_videoString = videoName;
		_returnState = returnStateName;
		FlxG.switchState(new VidHandler());
		trace('Current Video Playing: $videoName');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if ((FlxG.keys.justPressed.ANY) && _video != null)
		{
			trace('Skipped Video');
			_video.onEndReached.dispatch();
		}
	}

	override function destroy()
	{
		super.destroy();

		_video.dispose();
	}
}
#end
