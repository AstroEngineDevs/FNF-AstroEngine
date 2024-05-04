package funkin.backend.client;

import funkin.backend.data.EngineData;
import funkin.backend.utils.ClientPrefs;
import Sys.sleep;
import lime.app.Application;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end

using StringTools;

class DiscordClient
{
	public static var isInitialized:Bool = false;
	private static final _defaultID:String = EngineData.coreGame.coreDiscordID;
	public static var clientID(default, set):String = _defaultID;
	private static var presence:DiscordRichPresence = DiscordRichPresence.create();

	public static function check()
	{
		if (ClientPrefs.data.discordRPC)
			initialize();
		else if (isInitialized)
			shutdown();
	}

	public static function prepare()
	{
		if (!isInitialized && ClientPrefs.data.discordRPC)
			initialize();

		Application.current.window.onClose.add(function()
		{
			if (isInitialized)
				shutdown();
		});
	}

	public dynamic static function shutdown()
	{
		Discord.Shutdown();
		isInitialized = false;
	}

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestPtr:cpp.Star<DiscordUser> = cpp.ConstPointer.fromRaw(request).ptr;

		if (Std.parseInt(cast(requestPtr.discriminator, String)) != 0) // New Discord IDs/Discriminator system
			traceFr('Connected to User (${cast (requestPtr.username, String)}#${cast (requestPtr.discriminator, String)})');
		else // Old discriminators
			traceFr('Connected to User (${cast (requestPtr.username, String)})');

		changePresence();
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		traceFr('Error ($errorCode: ${cast (message, String)})');
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		traceFr('Disconnected ($errorCode: ${cast (message, String)})');
	}

	public static function initialize()
	{
		var discordHandlers:DiscordEventHandlers = DiscordEventHandlers.create();
		discordHandlers.ready = cpp.Function.fromStaticFunction(onReady);
		discordHandlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		discordHandlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(clientID, cpp.RawPointer.addressOf(discordHandlers), 1, null);

		if (!isInitialized)
			traceFr("Initialized");

		sys.thread.Thread.create(() ->
		{
			var localID:String = clientID;
			while (localID == clientID)
			{
				#if DISCORD_DISABLE_IO_THREAD
				Discord.UpdateConnection();
				#end
				Discord.RunCallbacks();

				// Wait 0.5 seconds until the next loop...
				Sys.sleep(0.5);
			}
		});
		isInitialized = true;
	}

	public static function changePresence(?details:String = 'In the Menus', ?state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool,
			?endTimestamp:Float, largeImageKey:String = 'icon')
	{
		var startTimestamp:Float = 0;
		if (hasStartTimestamp)
			startTimestamp = Date.now().getTime();
		if (endTimestamp > 0)
			endTimestamp = startTimestamp + endTimestamp;

		presence.details = details;
		presence.state = state;
		presence.largeImageKey = largeImageKey;
		presence.largeImageText = "Engine Version: " + cast(EngineData.engineData.coreVersion, String);
		presence.smallImageKey = smallImageKey;
		// Obtained times are in milliseconds so they are divided so Discord can use it
		presence.startTimestamp = Std.int(startTimestamp / 1000);
		presence.endTimestamp = Std.int(endTimestamp / 1000);
		updatePresence();
	}

	public static function updatePresence()
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));

	public static function resetClientID()
		clientID = _defaultID;

	private static function set_clientID(newID:String)
	{
		var change:Bool = (clientID != newID);
		clientID = newID;

		if (change && isInitialized)
		{
			shutdown();
			initialize();
			updatePresence();
		}
		return newID;
	}

	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State)
	{
		Lua_helper.add_callback(lua, "changePresence",
			function(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
			{
				changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
			});

		Lua_helper.add_callback(lua, "changeClientID", function(?newID:String = null)
		{
			if (newID == null)
				newID = _defaultID;
			clientID = newID;
		});
	}
	#end

	private static function traceFr(fr:String)
	{
		trace('RPC ${fr}');
	}
}
