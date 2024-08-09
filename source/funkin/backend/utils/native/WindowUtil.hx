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
	}
	#end

	public static function setTitle(?s:String, ?normal:Bool = true)
	{
		if (normal)
			Application.current.window.title = Application.current.meta.get('name') + " - " + s;
		else if (s == null)
			Application.current.window.title = Application.current.meta.get('name');
		else
			Application.current.window.title = s;
	}

	public static function resetTitle()
		Application.current.window.title = Application.current.meta.get('name');
}
