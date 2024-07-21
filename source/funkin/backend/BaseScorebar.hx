package funkin.backend;

class BaseScorebar extends FlxBasic {
    private var game(get, never):Dynamic;
    private var updateScore(default, set):Void->Void;
    private var updateFunc(default, set):Void->Void;

    public function new() {
        super();
        create();

        game.updateFunc = update;
        updateScore = updateShit;

        PlayState.instance.uiGroup.forEach((spr)->{
            spr.alpha = 0;
        });
    }

    public function create() {}

    public function updateShit() {}

    // Gets And Sets Shit
    private inline function set_updateFunc(erm:Void->Void) {
        game.updateFunc = erm;
        erm();
        return erm;
    }
    private inline function set_updateScore(erm:Void->Void) {
        game.scoreUpdateFunc = erm;
        erm();
        return erm;
    }
    private inline function get_game():Dynamic {
		return PlayState.instance;
	}

    // FlxBasic Default
    
    function add(object:FlxBasic)
        game.uiGroup.add(object);

	function remove(object:FlxBasic)
        game.uiGroup.remove(object);

	function insert(position:Int, object:FlxBasic)
        game.uiGroup.insert(position,object);

}