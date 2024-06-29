package funkin.backend.macro;

#if macro
import sys.io.Process;
#end

using StringTools;

class CommitMacro
{
	// idea stolen from codename engine
	public static var commitNumber(get, never):Int;
	public static var commitHash(get, never):String;

	static function get_commitNumber()
	{
		return _commitNumber();
	}

	static function get_commitHash()
	{
		return _commitHash();
	}

	// Other Shitzz

	private static macro function _commitNumber()
	{
		#if display
		return macro $v{0};
		#else
		try
		{
			var process = new Process('git', ['rev-list', 'HEAD', '--count'], false);
			process.exitCode(true);

			return macro $v{Std.parseInt(process.stdout.readLine())};
		}
		catch (e)
		{
			trace("Error Gettings Hash from Git" + e);
		}
		return macro $v{0} #end
	}

	private static macro function _commitHash()
	{
		#if display
		return macro $v{"~"};
		#else
		try
		{
			var process = new Process('git', ['rev-parse', '--short', 'HEAD'], false);
			process.exitCode(true);

			return macro $v{process.stdout.readLine()};
		}
		catch (e)
		{
			trace("Error Gettings Hash from Git" + e);
		}
		return macro $v{"~"} #end
	}
}
