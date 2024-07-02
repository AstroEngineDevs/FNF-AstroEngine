package funkin.game;

@:final
@:publicFields
class Config {
    static final gameSize:Array<Int> = [1280, 720]; // WINDOW width & height.
	static final skipSplash:Bool = true; // If HaxeFlixel splash screen should be skipped.
	static final startFullscreen:Bool = false; // If the game should start in fullscreen mode.

	static final discordID:String = '';
	static final discordButton:Bool = true;
}