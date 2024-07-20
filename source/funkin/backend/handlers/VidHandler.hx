package funkin.backend.handlers;

// TODO: umm make video states easier :3 NEW: DONE I GUESS
import flixel.FlxState;
#if VIDEOS_ALLOWED
import hxcodec.flixel.FlxVideo;



class VidHandler extends MusicBeatState{
    static var video:FlxVideo;
	static var videoString:String = '';
	static var returnState:FlxState;
    
	override function create()
	{
		super.create();

		if(FlxG.sound.music != null)
		    FlxG.sound.music.fadeOut(1, 0, function(_) FlxG.sound.music.stop());
		if (funkin.game.Main.fpsVar != null)
			funkin.game.Main.fpsVar.visible = false;
		FlxG.mouse.visible = false;
		video = new FlxVideo();
		video.play(Paths.video(videoString));
		video.onEndReached.add(function(){
			if (funkin.game.Main.fpsVar != null)
				funkin.game.Main.fpsVar.visible = ClientPrefs.data.showFPS;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			FlxG.mouse.visible = true;
			MusicBeatState.switchState(returnState);
			return;
		});
	}
    public static function startVideo(videoName:String, returnStateName:Null<flixel.FlxState>) {
		videoString = videoName;
		returnState = returnStateName;
		FlxG.switchState(new VidHandler());
		trace('Current Video Playing: $videoName');
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if ((FlxG.keys.justPressed.ANY) && video != null){
			trace('Skipped Video');
			video.onEndReached.dispatch();
		}
	}

	override function destroy() {
		super.destroy();

		video.dispose();
	}
}
#end
