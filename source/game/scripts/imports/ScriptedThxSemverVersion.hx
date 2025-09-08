package game.scripts.imports;

import thx.semver.Version;

class ScriptedThxSemverVersion
{
	public static function arrayToVersion(array:Array<Int>)
		return Version.arrayToVersion(array);

	public static function stringToVersion(string:String)
		return Version.stringToVersion(string);

	public static function lessThan(main:Version, other:Version)
		return main.lessThan(other);

	public static function lessThanOrEqual(main:Version, other:Version)
		return main.lessThanOrEqual(other);

	public static function greaterThan(main:Version, other:Version)
		return main.greaterThan(other);

	public static function greaterThanOrEqual(main:Version, other:Version)
		return main.greaterThanOrEqual(other);
}
