package funkin.backend.utils;

enum CacheType {
    COUNTDOWN;
    POPUPSCORE;
}

class CacheUtils
{
    public static function cache(type:CacheType = COUNTDOWN) {
        trace('Cache: $type');
        switch (type){
            case COUNTDOWN: cacheCountdown();
            case POPUPSCORE: cachePopUpScore();
            default: throw 'invalid type lol :3';
        }
    }

	public static function cacheCountdown()
	{
        final introStuffix = PlayState.instance.introSoundsSuffix;
        
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', [
			'UI/default/countdown/ready',
			'UI/default/countdown/set',
			'UI/default/countdown/go'
		]);
		introAssets.set('pixel', ['UI/pixel/countdown/ready', 'UI/pixel/countdown/set', 'UI/pixel/countdown/date']);

		var introAlts:Array<String> = introAssets.get('default');
		if (PlayState.isPixelStage)
			introAlts = introAssets.get('pixel');

		for (asset in introAlts)
			Paths.image(asset);

		Paths.sound('intro3' + introStuffix);
		Paths.sound('intro2' + introStuffix);
		Paths.sound('intro1' + introStuffix);
		Paths.sound('introGo' + introStuffix);
	}

    public static function cachePopUpScore()
        {
            var pixelShitPart1:String = "UI/";
            if (PlayState.isPixelStage)
                pixelShitPart1 += 'pixel';
            else
                pixelShitPart1 += 'default';
    
            Paths.image('$pixelShitPart1/rating/' + "sick");
            Paths.image('$pixelShitPart1/rating/' + "good");
            Paths.image('$pixelShitPart1/rating/' + "bad");
            Paths.image('$pixelShitPart1/rating/' + "shit");
            Paths.image('$pixelShitPart1/' + "combo");
            
            for (i in 0...10) {
                Paths.image('$pixelShitPart1/numbers/' + 'num' + i);
            }
        }
}
