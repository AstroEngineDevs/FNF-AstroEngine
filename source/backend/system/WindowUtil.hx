package backend.system;

import lime.app.Application;

@:buildXml('
<target id="haxe">
    <lib name="dwmapi.lib" if="windows" />
</target>
')
@:cppFileCode('
 #include <dwmapi.h>
 ')
#if windows
class WindowUtil
{
	@:functionCode('
    int darkMode = enable ? 1 : 0;
    HWND window = GetActiveWindow();
    if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode)))
        DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
    ')
	public static function darkMode(enable:Bool)
	{
	}

	public static function setTitle(?s:String, ?normal:Bool = true)
	{
		if (normal)
			title(Application.current.meta.get('name') + " - " + s);
		else if (s == null)
			title(Application.current.meta.get('name'));
		else
			title(s);
	}

	// UHHHH

	static function title(string:String)
		Application.current.window.title = string;
}
#end
