package funkin.game.videos;

#if VIDEOS_ALLOWED
class TemplateVideo extends MusicBeatState
{
	override function create()
	{
		super.create();

		VidHandler.startVideo('owo', new MainMenuState());
	}
}
#end
