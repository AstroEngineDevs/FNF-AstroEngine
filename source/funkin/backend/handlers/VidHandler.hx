package funkin.backend.handlers;

// TODO: umm make video states easier :3
#if VIDEOS_ALLOWED
import hxcodec.flixel.FlxVideo;

using StringTools;

class VidHandler extends MusicBeatState{
    static var video:FlxVideo;
    
	override function create()
	{
		super.create();
	}
    public static function startVideo(videoName:String) {
        if(FlxG.sound.music != null)
		    FlxG.sound.music.fadeOut(1, 0, function(_) FlxG.sound.music.stop());
		if (funkin.game.Main.fpsVar != null)
			funkin.game.Main.fpsVar.visible = false;
		FlxG.mouse.visible = false;
		video = new FlxVideo();
		video.play(Paths.video(videoName));
        trace(videoName);
		video.onEndReached.add(function() {
			if (funkin.game.Main.fpsVar != null)
				funkin.game.Main.fpsVar.visible = ClientPrefs.data.showFPS;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			FlxG.mouse.visible = true;
			MusicBeatState.switchState(new MainMenuState());
			return;
		});
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if ((FlxG.keys.justPressed.ANY && !controls.ACCEPT) && video != null)
		{
			video.stop();
		}
	}
}
#end
