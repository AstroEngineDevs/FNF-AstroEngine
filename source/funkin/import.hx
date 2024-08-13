#if !macro 
// Game
import funkin.game.objects.characters.*;
import funkin.game.objects.*;
import funkin.game.options.objects.*;
import funkin.game.states.*;
import funkin.game.transitions.*;
import funkin.game.objects.Note.EventNote;
import funkin.game.objects.stages.objects.*;
import funkin.game.transitions.*;
import funkin.game.objects.notes.NoteUtils;
import funkin.game.objects.characters.*;
import funkin.game.options.objects.Option;

// backend
import funkin.backend.macro.*;
import funkin.backend.system.*;
import funkin.backend.utils.*;
import funkin.backend.data.*;
import funkin.backend.*;
import funkin.backend.base.*;
import funkin.backend.utils.native.*;
import funkin.backend.base.BaseStage.Countdown;
import funkin.backend.Structures;

//Discord API
#if DISCORD_ALLOWED
import funkin.backend.client.Discord;
#end

// Lua
import funkin.backend.funkinLua.*;
import funkin.backend.funkinLua.luaStuff.*;
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

// Videos
#if VIDEOS_ALLOWED
import hxcodec.flixel.FlxVideo;
#end

// Shader
#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

// System
#if sys
import sys.FileSystem;
import sys.io.File;
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
import flixel.FlxBasic;
#end
using StringTools;

#if !macro
using funkin.backend.utils.StringUtils;
using funkin.backend.utils.ObjectUtils;
#end
