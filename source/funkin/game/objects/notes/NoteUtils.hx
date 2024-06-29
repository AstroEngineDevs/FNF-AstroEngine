package funkin.game.objects.notes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import funkin.game.objects.shaders.ColorSwap;
import funkin.game.states.PlayState;

class NoteUtils extends FlxSprite
{
	public function new()
	{
		super();
	}

	public static function checkSplash()
	{
        var skin:String = 'normal';
        
        if(PlayState.SONG.splashSkin == 'normal' || ClientPrefs.data.forceNoteSplashes)
			skin = ClientPrefs.data.noteSplashesType;
		else 
			skin = PlayState.SONG.splashSkin;
		if(PlayState.SONG.splashSkin == null)
			skin = 'normal';

        return skin;
	}
}
