#if !macro 

//Discord API
#if DISCORD_ALLOWED
import backend.client.Discord;
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

import backend.data.*;

import game.objects.characters.*;
import game.objects.characters.MenuCharacter;

import game.objects.MenuItem;
import game.objects.TypedAlphabet;
import game.options.objects.Option;

import backend.PlayerSettings;

import backend.CoolUtil;

import backend.macro.*;

import game.states.LoadingState;
import game.objects.FlxUIDropDownMenuCustom;

import backend.utils.Paths;

import backend.system.MusicBeatSubstate;
import backend.system.MusicBeatState;

import backend.utils.Paths;
import backend.utils.Controls;
import backend.CoolUtil;
import backend.system.MusicBeatState;
import backend.system.MusicBeatSubstate;
import game.transitions.CustomFadeTransition;
import backend.utils.ClientPrefs;
import backend.Conductor;

import game.objects.Alphabet;
import game.objects.BGSprite;

import game.states.PlayState;
import game.states.LoadingState;
import backend.utils.Controls;

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