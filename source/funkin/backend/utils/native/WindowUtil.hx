package funkin.backend.utils.native;

import lime.app.Application;

#if windows
@:buildXml('
<target id="haxe">
    <lib name="dwmapi.lib" if="windows" />
</target>
')
@:cppFileCode('
 #include <dwmapi.h>
 ')
#end
class WindowUtil
{
	static var osInfo(get, never):String;
	static var osVersion(get, never):String;

	#if windows
	@:functionCode('
    int darkMode = enable ? 1 : 0;
    HWND window = GetActiveWindow();
    if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode)))
        DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
    ')
	public static function darkMode(enable:Bool)
	{
		trace('Darkmode ${enable ? 'Enabled' : 'Disabled'}');

		// Windows 10 support?
		if (!osInfo.contains('11')){
			Application.current.window.borderless = true;
			Application.current.window.borderless = false;
		}

		trace(osInfo + ' ' + osVersion);
	}
	#end

	public static function setTitle(?s:String, ?normal:Bool = true)
	{
		if (s == null)
		{
			if (normal)
				Application.current.window.title = Application.current.meta.get('name') + " - " + s;
			else
				Application.current.window.title = s;
		}
	}

	public static function resetTitle()
		Application.current.window.title = Application.current.meta.get('name');

	// bro

	private static function get_osInfo()
	{ // stolen from twist engine lmao
		if (lime.system.System.platformLabel != null
			&& lime.system.System.platformLabel != ""
			&& lime.system.System.platformVersion != null
			&& lime.system.System.platformVersion != "")
			return lime.system.System.platformLabel.replace(lime.system.System.platformVersion, "").trim();
		else
			trace('Unable to grab OS Label');

		return null;
	}

	private static inline function get_osVersion()
		return lime.system.System.platformVersion;
}
