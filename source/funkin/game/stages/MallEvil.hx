package funkin.game.stages;

class MallEvil extends BaseStage
{
	override function create()
	{
		var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
		bg.setGraphicSize(Std.int(bg.width * 0.8));
		bg.updateHitbox();
		add(bg);

		var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
		add(evilTree);

		var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
		add(evilSnow);
		setDefaultGF('gf-christmas');

		// Winter Horrorland cutscene
		if ((isStoryMode && !seenCutscene) && songName == 'winter-horrowland')
		{
			startCallback = winterHorrorlandCutscene;
		}
	}

	function winterHorrorlandCutscene()
	{
		var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
		add(blackScreen);
		blackScreen.scrollFactor.set();
		camHUD.visible = false;
		inCutscene = true;

		FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween)
			{
				remove(blackScreen);
			}
		});
		FlxG.sound.play(Paths.sound('Lights_Turn_On'));
		camFollow.set(400, -2050);
		game.camFollowPos.setPosition(400, -2050);
		FlxG.camera.focusOn(camFollow);
		FlxG.camera.zoom = 1.5;

		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			remove(blackScreen);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
				ease: FlxEase.quadInOut,
				onComplete: function(twn:FlxTween)
				{
					camHUD.visible = true;
					startCountdown();
				}
			});
		});
	}
}
