#if !macro 

// game
import funkin.game.objects.characters.*;
import funkin.game.objects.*;
import funkin.game.options.objects.*;
import funkin.game.states.*;
import funkin.game.transitions.*;

// backend
import funkin.backend.macro.*;
import funkin.backend.system.*;
import funkin.backend.utils.*;
import funkin.backend.data.*;
import funkin.backend.*;

//Discord API
#if DISCORD_ALLOWED
import funkin.backend.client.Discord;
#end

// Lua
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end

// System
#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

// Flixel
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
#end

using StringTools;
using funkin.backend.utils.StringUtils;