package funkin.game.videos;

#if VIDEOS_ALLOWED
class TemplateVideo extends VidHandler
{
	override function create()
	{
		super.create();

		VidHandler.startVideo('HEWWO');
	}
}
#end
