package funkin.backend.system;

import flixel.FlxG;
import funkin.game.states.PlayState;
import funkin.backend.Conductor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxState;
import funkin.backend.utils.Controls;
import flixel.FlxCamera;
import flixel.FlxBasic;

class MusicBeatState extends FlxState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	var _astroCameraInitialized:Bool = false;
	inline function get_controls():Controls
		return Controls.instance;

	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public static function getVariables()
		return getState().variables;

	override function create()
	{
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		super.create();

		if(!_astroCameraInitialized) initAstroCamera();

		if (!skip)
		{
			openSubState(new FadeTransition(0.5, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
		timePassedOnState = 0;
	}

	
	public function initAstroCamera():AstroCamera
		{
			var camera = new AstroCamera();
			FlxG.cameras.reset(camera);
			FlxG.cameras.setDefaultDrawTarget(camera, true);
			_astroCameraInitialized = true;
			return camera;
		}

	public static function init()
	{
		trace('Init Complete'); // Makes Sure MusicBeatState isnt null fr
	}

	public function addBehindObject(obj:FlxBasic, obj2:FlxBasic)
		return insert(members.indexOf(obj2), obj);

	public function addAheadObject(obj:FlxBasic, obj2:FlxBasic)
		return insert(members.indexOf(obj2) + 1, obj);

	public static var timePassedOnState:Float = 0;
	override function update(elapsed:Float)
	{
		// everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if (curStep > 0)
				stepHit();

			if (PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if (FlxG.save.data != null)
			FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if (stepsToDo < 1)
			stepsToDo = Math.round(getBeatsOnSection() * 4);
		while (curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if (curStep < 0)
			return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if (stepsToDo > curStep)
					break;

				curSection++;
			}
		}

		if (curSection > lastSection)
			sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep / 4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - funkin.backend.utils.ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState)
		{
			if(nextState == null) nextState = FlxG.state;
			if(nextState == FlxG.state)
			{
				resetState();
				return;
			}
	
			if(FlxTransitionableState.skipNextTransIn) FlxG.switchState(nextState);
			else startTransition(nextState);
			FlxTransitionableState.skipNextTransIn = false;
		}
	
		public static function resetState() {
			if(FlxTransitionableState.skipNextTransIn) FlxG.resetState();
			else startTransition();
			FlxTransitionableState.skipNextTransIn = false;
		}
	
		// Custom made Trans in
		public static function startTransition(nextState:FlxState = null)
		{
			if(nextState == null)
				nextState = FlxG.state;
	
			FlxG.state.openSubState(new FadeTransition(0.6, false));
			if(nextState == FlxG.state)
				FadeTransition.finishCallback = function() FlxG.resetState();
			else
				FadeTransition.finishCallback = function() FlxG.switchState(nextState);
		}
	public static function getState():MusicBeatState
	{
		return cast (FlxG.state, MusicBeatState);
	}

	public function stepHit():Void
	{
		stagesFunc(function(stage:BaseStage)
		{
			stage.curStep = curStep;
			stage.curDecStep = curDecStep;
			stage.stepHit();
		});

		if (curStep % 4 == 0)
			beatHit();
	}

	public var stages:Array<BaseStage> = [];

	public function beatHit():Void
	{
		// trace('Beat: ' + curBeat);
		stagesFunc(function(stage:BaseStage)
		{
			stage.curBeat = curBeat;
			stage.curDecBeat = curDecBeat;
			stage.beatHit();
		});
	}

	public function sectionHit():Void
	{
		// trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
		stagesFunc(function(stage:BaseStage)
		{
			stage.curSection = curSection;
			stage.sectionHit();
		});
	}

	function stagesFunc(func:BaseStage->Void)
	{
		for (stage in stages)
			if (stage != null && stage.exists && stage.active)
				func(stage);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if (PlayState.SONG != null && PlayState.SONG.notes[curSection] != null)
			val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
