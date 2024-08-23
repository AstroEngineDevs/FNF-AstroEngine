package funkin.backend;

import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.FlxG;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}


	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
		#else
		if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	inline public static function colorFromString(color:String):FlxColor
		{
			var hideChars = ~/[\t\n\r]/;
			var color:String = hideChars.split(color).join('').trim();
			if(color.startsWith('0x')) color = color.substring(color.length - 6);
	
			var colorNum:Null<FlxColor> = FlxColor.fromString(color);
			if(colorNum == null) colorNum = FlxColor.fromString('#$color');
			return colorNum != null ? colorNum : FlxColor.WHITE;
		}
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/**
		Helper Function to Fix Save Files for Flixel 5

		-- EDIT: [November 29, 2023] --

		this function is used to get the save path, period.
		since newer flixel versions are being enforced anyways.
		@crowplexus
	**/
	inline public static function getSavePath():String {
		final company:String = FlxG.stage.application.meta.get('company');
		@:privateAccess
		return '${company}/${FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
	}


	public static function setTextBorderFromString(text:FlxText, border:String)
		{
			switch(border.toLowerCase().trim())
			{
				case 'shadow':
					text.borderStyle = SHADOW;
				case 'outline':
					text.borderStyle = OUTLINE;
				case 'outline_fast', 'outlinefast':
					text.borderStyle = OUTLINE_FAST;
				default:
					text.borderStyle = NONE;
			}
		}
}
