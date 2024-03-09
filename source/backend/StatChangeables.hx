package backend;

import flixel.FlxG;

using StringTools;

class StatChangeables {
    public static var MAX_SCORE:Int;
    public static var MOST_MISSES:Int;

    public static function saveStats() {
        FlxG.save.data.maxScore = MAX_SCORE;
        FlxG.save.data.mostMisses = MOST_MISSES;
        
        trace("Saved Stats");
    }
    
    public static function loadStats() {
        if(FlxG.save.data.maxScore != null) MAX_SCORE = FlxG.save.data.maxScore;

        if(FlxG.save.data.mostMisses != null) MOST_MISSES = FlxG.save.data.mostMisses;

        trace("Loaded Stats");
    }

    public static function resetStats() {
        MAX_SCORE = 0;
        MOST_MISSES = 0;
        saveStats();
        trace("Reset Stats");
    }
}