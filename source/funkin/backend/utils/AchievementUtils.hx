package funkin.backend.utils;

import funkin.game.objects.Achievements.AchievementObject;
#if ACHIEVEMENTS_ALLOWED
class AchievementUtils
{
	public static var keysPressed:Array<Int> = [];
	public static var boyfriendIdleTime:Float = 0.0;
	public static var boyfriendIdled:Bool = false;

	private static final defaultArray:Array<String> = [
		'week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss', 'week5_nomiss', 'week6_nomiss', 'week7_nomiss', 'ur_bad', 'ur_good', 'hype',
		'two_keys', 'toastie', 'debugger'
	];

	public static function resetVars()
	{
		keysPressed = [];
		boyfriendIdleTime = 0.0;
		boyfriendIdled = false;
	}

	public static function checkAndGrantAchievement(name:String, camera:FlxCamera) {
		trace('Checking Achievement "$name"');
		final lol = checkForAchievement([name]);
		if(lol != null && !Achievements.isAchievementUnlocked(name))
			FlxG.state.add(new AchievementObject(name, camera));
	}

	public static function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if (achievesToCheck == null)
			achievesToCheck = defaultArray;

		if (PlayState.chartingMode)
			return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length)
		{
			var achievementName:String = achievesToCheck[i];
			if (!Achievements.isAchievementUnlocked(achievementName) && !PlayState.instance?.cpuControlled)
			{
				var unlock:Bool = false;

				if (achievementName.contains(WeekData.getWeekFileName())
					&& achievementName.endsWith('nomiss')) // any FC achievements, name should be "weekFileName_nomiss", e.g: "weekd_nomiss";
				{
					if (PlayState.isStoryMode
						&& PlayState.campaignMisses + PlayState.instance.songMisses < 1
						&& Difficulty.getString().toUpperCase() == 'HARD'
						&& PlayState.storyPlaylist.length <= 1
						&& !PlayState.changedDifficulty
						&& !usedPractice)
						unlock = true;
				}
				switch (achievementName)
				{
					case 'friday_night_play':
						final swagDate = Date.now();
						if (swagDate.getDay() == 5 && swagDate.getHours() >= 18)
							unlock = true;

					case 'ur_bad':
						if (PlayState.instance.ratingPercent < 0.2 && !PlayState.instance.practiceMode)
							unlock = true;

					case 'ur_good':
						if (PlayState.instance.ratingPercent >= 1 && !usedPractice)
							unlock = true;

					case 'roadkill_enthusiast':
						if (Achievements.henchmenDeath >= 100)
							unlock = true;

					case 'oversinging':
						if (PlayState.instance.boyfriend.holdTimer >= 10 && !usedPractice)
							unlock = true;

					case 'hype':
						if (!boyfriendIdled && !usedPractice)
							unlock = true;

					case 'two_keys':
						unlock = (!usedPractice && keysPressed.length <= 2);
					case 'toastie':
						unlock = (!ClientPrefs.data.cacheOnGPU && !ClientPrefs.data.shaders && ClientPrefs.data.lowQuality && !ClientPrefs.data.antialiasing);

					case 'debugger':
						if (Paths.formatToSongPath(PlayState.SONG.song) == 'test' && !usedPractice)
							unlock = true;

					default:
						unlock = false;
				}

				if (unlock)
				{
					Achievements.unlockAchievement(achievementName);
					ClientPrefs.saveSettings();
					return achievementName;
				}
			}
		}
		return null;
	}
}
#end
