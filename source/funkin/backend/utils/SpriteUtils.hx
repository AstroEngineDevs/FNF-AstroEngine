package funkin.backend.utils;

import flixel.FlxObject;

class SpriteUtils {
    public static function centerOnObject(spr:FlxObject, spr2:FlxObject)
        {
            spr.x = (spr.width - spr2.width) / 2;
            spr.y = (spr.height - spr2.height) / 2;
        }
}