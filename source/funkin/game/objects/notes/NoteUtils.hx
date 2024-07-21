package funkin.game.objects.notes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import funkin.game.objects.shaders.ColorSwap;
import funkin.game.states.PlayState;

class NoteUtils extends FlxSprite
{
	public static inline function checkNote():String {
		var skin:String = 'NOTE_assets';

		return skin;
	}

	public static inline function checkSplash():String
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
