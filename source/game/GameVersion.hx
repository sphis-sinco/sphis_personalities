package game;

#if semver
import thx.semver.Version;
#end

class GameVersion
{
	static var version = '1.2.0';

	#if semver
	public static var get(get, never):Version;

	static function get_get():Version
	{
		return Version.stringToVersion(version);
	}
	#else
	public static var get(get, never):String;

	static function get_get():String
	{
		return version;
	}
	#end
}
