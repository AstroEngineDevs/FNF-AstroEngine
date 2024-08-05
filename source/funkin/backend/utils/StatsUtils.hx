package funkin.backend.utils;

class StatsUtils
{
	public static function checkStats(dataStore:String = 'Max Score', otheridk:Dynamic) // simple but effective
	{
		if (ClientPrefs.data.stats.get(dataStore) < otheridk)
			ClientPrefs.data.stats.set(dataStore, otheridk);

		ClientPrefs.saveSettings();
	}
}
