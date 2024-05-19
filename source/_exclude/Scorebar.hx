package funkin.game.objects;

import funkin.backend.Highscore;

using StringTools;

// USED FOR REF OK DUDE WILL BE DELETE LATER ONCE I GET A BRAIN AND FIX EVERYTHING LMAO

class Scorebar extends FlxText {

	public static var instance:Scorebar;

	var inShit = "|";

    public function new() {
		instance = this;

        super(0, PlayState.instance.healthBarBG.y + 36, FlxG.width, "", 20);
		scrollFactor.set();
		alpha = 0;
		borderSize = 1.25;
		visible = !ClientPrefs.data.hideFullHUD;

		switch(ClientPrefs.data.scoreBarType){
			case 'Astro':
				setFormat(Paths.font("PhantomMuff.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				inShit = "•";
			case 'Psych':
				setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				inShit = "|";
			default:
				setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				inShit = "";
		}
    }

    public function updateShit() {
		if(ClientPrefs.data.scoreBarType != 'V-Slice'){
			text = 'Score: '
			+ PlayState.instance.songScore
			+ ' $inShit Misses: '
			+ PlayState.instance.songMisses
			+ ' $inShit Rating: '
			+ PlayState.instance.ratingName
			+ (PlayState.instance.ratingName != '?' ? ' (${Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2)}%) - ${PlayState.instance.ratingFC}' : '');
	
		} else{
			text = 'Score: '+
			PlayState.instance.songScore;
		}

    }
}