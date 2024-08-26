package funkin.backend.utils;

enum CacheType {
    COUNTDOWN;
    POPUPSCORE;
}

class CacheUtils
{
    public static function cache(type:CacheType = COUNTDOWN) {
        trace('Cached: $type');
        switch (type){
            case COUNTDOWN: cacheCountdown();
            case POPUPSCORE: cachePopUpScore();
            default: throw 'invalid type lol :3';
        }
    }

	public static function cacheCountdown()
	{
        final introStuffix = PlayState.instance.introSoundsSuffix;
        
        var stageUI = PlayState?.stageUI;
        var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
        var introImagesArray:Array<String> = switch(stageUI) {
            case "pixel": ['${stageUI}UI/ready-pixel', '${stageUI}UI/set-pixel', '${stageUI}UI/date-pixel'];
            case "normal": ["ready", "set" ,"go"];
            default: ['${stageUI}UI/ready', '${stageUI}UI/set', '${stageUI}UI/go'];
        }
        introAssets.set(stageUI, introImagesArray);

		for (asset in introAssets.get(stageUI))
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
