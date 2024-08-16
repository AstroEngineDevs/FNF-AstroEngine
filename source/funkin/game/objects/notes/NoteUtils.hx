package funkin.game.objects.notes;

import funkin.game.states.PlayState;

enum NoteType
{
	NORMAL; // normal notes
	PIXEL; // pixel notes
	CUSTOM; // special notes like hurtnote (Not Used YET)
}

class NoteUtils
{
	public inline static var pixelNotePath:String = 'UI/notes/pixel/';
	public inline static var normalNotePath:String = 'UI/notes/';
	public inline static var customNotePath:String = 'UI/notes/custom/';
	
	public static var CURRENTSKIN:String = 'NOTE_assets';
	public static var CURRENTSPLASH:String = 'normal';

	public static inline function checkNote(?type:NoteType = NORMAL):String
		return getNotePath(type) + CURRENTSKIN;

	public static inline function checkSplash():String
	{
		if (PlayState.SONG.splashSkin == 'normal' || ClientPrefs.data.forceNoteSplashes)
			CURRENTSPLASH = ClientPrefs.data.noteSplashesType;
		else
			CURRENTSPLASH = PlayState.SONG.splashSkin;
		if (PlayState.SONG.splashSkin == null)
			CURRENTSPLASH = 'normal';

		return CURRENTSPLASH;
	}

	public static inline function getNotePath(type:NoteType)
		return switch (type)
		{
			case NORMAL: normalNotePath;
			case PIXEL: pixelNotePath;
			case CUSTOM: customNotePath;
			default: throw 'unknown notetype';
		};
}
