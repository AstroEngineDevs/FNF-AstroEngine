package funkin.game.videos;

#if VIDEOS_ALLOWED
class TemplateVideo extends MusicBeatState
{
	var video:MP4Handler;

	override function create()
	{
		super.create();

		FlxG.sound.music.fadeOut(1, 0, function(_) FlxG.sound.music.stop());
		if (funkin.game.Main.fpsVar != null)
			funkin.game.Main.fpsVar.visible = false;
		FlxG.mouse.visible = false;
		video = new MP4Handler();
		video.playVideo(Paths.video('VIDEOPATHEHERE')); // ripped from the game
		video.finishCallback = function()
		{
			if (funkin.game.Main.fpsVar != null)
				funkin.game.Main.fpsVar.visible = ClientPrefs.data.showFPS;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			FlxG.mouse.visible = true;
			MusicBeatState.switchState(new MainMenuState());
			return;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if ((FlxG.keys.justPressed.ANY && !controls.ACCEPT) && video != null)
		{
			video.finishVideo();
		}
	}
}
#end
