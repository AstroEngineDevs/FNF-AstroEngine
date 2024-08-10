package funkin.backend.funkinLua.functions;

#if (!flash && sys)
import flixel.addons.display.FlxRuntimeShader;
#end

class ShaderFunctions
{
	public static function implement(funk:FunkinLua)
	{
		var lua = funk.lua;

		// shader shit
		Lua_helper.add_callback(lua, "initLuaShader", function(name:String, glslVersion:Int = 120)
		{
			if (!ClientPrefs.data.shaders)
				return false;

			#if (!flash && MODS_ALLOWED && sys)
			return funk.initLuaShader(name, glslVersion);
			#else
			funk.luaTrace("initLuaShader: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
			return false;
		});

		Lua_helper.add_callback(lua, "setSpriteShader", function(obj:String, shader:String)
		{
			if (!ClientPrefs.data.shaders)
				return false;

			#if (!flash && MODS_ALLOWED && sys)
			if (!funk.runtimeShaders.exists(shader) && !funk.initLuaShader(shader))
			{
				FunkinLua.luaTrace('setSpriteShader: Shader $shader is missing!', false, false, FlxColor.RED);
				return false;
			}

			var killMe:Array<String> = obj.split('.');
			var leObj:FlxSprite = LuaUtils.getObjectDirectly(killMe[0]);
			if (killMe.length > 1)
			{
				leObj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoopThingWhatever(killMe), killMe[killMe.length - 1]);
			}

			if (leObj != null)
			{
				var arr:Array<String> = funk.runtimeShaders.get(shader);
				leObj.shader = new FlxRuntimeShader(arr[0], arr[1]);
				return true;
			}
			#else
			funk.luaTrace("setSpriteShader: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
			return false;
		});
		Lua_helper.add_callback(lua, "removeSpriteShader", function(obj:String)
		{
			var killMe:Array<String> = obj.split('.');
			var leObj:FlxSprite = LuaUtils.getObjectDirectly(killMe[0]);
			if (killMe.length > 1)
			{
				leObj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoopThingWhatever(killMe), killMe[killMe.length - 1]);
			}

			if (leObj != null)
			{
				leObj.shader = null;
				return true;
			}
			return false;
		});

		Lua_helper.add_callback(lua, "getShaderBool", function(obj:String, prop:String)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
			{
				return null;
			}
			return shader.getBool(prop);
			#else
			funk.luaTrace("getShaderBool: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		Lua_helper.add_callback(lua, "getShaderBoolArray", function(obj:String, prop:String)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
			{
				return null;
			}
			return shader.getBoolArray(prop);
			#else
			funk.luaTrace("getShaderBoolArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		Lua_helper.add_callback(lua, "getShaderInt", function(obj:String, prop:String)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
			{
				return null;
			}
			return shader.getInt(prop);
			#else
			funk.luaTrace("getShaderInt: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		Lua_helper.add_callback(lua, "getShaderIntArray", function(obj:String, prop:String)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
			{
				return null;
			}
			return shader.getIntArray(prop);
			#else
			funk.luaTrace("getShaderIntArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		Lua_helper.add_callback(lua, "getShaderFloat", function(obj:String, prop:String)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
			{
				return null;
			}
			return shader.getFloat(prop);
			#else
			funk.luaTrace("getShaderFloat: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		Lua_helper.add_callback(lua, "getShaderFloatArray", function(obj:String, prop:String)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
			{
				return null;
			}
			return shader.getFloatArray(prop);
			#else
			funk.luaTrace("getShaderFloatArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});

		Lua_helper.add_callback(lua, "setShaderBool", function(obj:String, prop:String, value:Bool)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
				return;

			shader.setBool(prop, value);
			#else
			funk.luaTrace("setShaderBool: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
		});
		Lua_helper.add_callback(lua, "setShaderBoolArray", function(obj:String, prop:String, values:Dynamic)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
				return;

			shader.setBoolArray(prop, values);
			#else
			funk.luaTrace("setShaderBoolArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
		});
		Lua_helper.add_callback(lua, "setShaderInt", function(obj:String, prop:String, value:Int)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
				return;

			shader.setInt(prop, value);
			#else
			funk.luaTrace("setShaderInt: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
		});
		Lua_helper.add_callback(lua, "setShaderIntArray", function(obj:String, prop:String, values:Dynamic)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
				return;

			shader.setIntArray(prop, values);
			#else
			funk.luaTrace("setShaderIntArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
		});
		Lua_helper.add_callback(lua, "setShaderFloat", function(obj:String, prop:String, value:Float)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
				return;

			shader.setFloat(prop, value);
			#else
			funk.luaTrace("setShaderFloat: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
		});
		Lua_helper.add_callback(lua, "setShaderFloatArray", function(obj:String, prop:String, values:Dynamic)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
				return;

			shader.setFloatArray(prop, values);
			#else
			funk.luaTrace("setShaderFloatArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
		});

		Lua_helper.add_callback(lua, "setShaderSampler2D", function(obj:String, prop:String, bitmapdataPath:String)
		{
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = funk.getShader(obj);
			if (shader == null)
				return;

			// trace('bitmapdatapath: $bitmapdataPath');
			var value = Paths.image(bitmapdataPath);
			if (value != null && value.bitmap != null)
			{
				// trace('Found bitmapdata. Width: ${value.bitmap.width} Height: ${value.bitmap.height}');
				shader.setSampler2D(prop, value.bitmap);
			}
			#else
			funk.luaTrace("setShaderSampler2D: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
		});
	}
}
