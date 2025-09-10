package game.scripts.imports;

class GameVersionScriptVersion
{
	public static var get(get, never):String;

	static function get_get():String
	{
		#if semver
		return GameVersion.get.toString();
		#else
		return GameVersion.get;
		#end
	}
}
