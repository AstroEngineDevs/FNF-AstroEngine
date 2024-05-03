#if !macro 

//Discord API
#if DISCORD_ALLOWED
import funkin.backend.client.Discord;
#end

// Astro
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

import funkin.backend.data.*;

import funkin.game.objects.characters.*;
import funkin.game.objects.characters.MenuCharacter;

import funkin.game.objects.MenuItem;
import funkin.game.objects.TypedAlphabet;
import funkin.game.options.objects.Option;

import funkin.backend.PlayerSettings;

import funkin.backend.CoolUtil;

import funkin.backend.macro.*;

import funkin.game.states.LoadingState;
import funkin.game.objects.FlxUIDropDownMenuCustom;

import funkin.backend.utils.Paths;
import funkin.backend.utils.Controls;
import funkin.backend.CoolUtil;
import funkin.backend.system.MusicBeatState;
import funkin.backend.system.MusicBeatSubstate;
import funkin.game.transitions.CustomFadeTransition;
import funkin.backend.utils.ClientPrefs;
import funkin.backend.Conductor;

import funkin.game.objects.Alphabet;
import funkin.game.objects.BGSprite;

import funkin.game.states.PlayState;
import funkin.game.states.LoadingState;
import funkin.backend.utils.Controls;

//Flixel
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

using StringTools;
#end