package game;

import thx.semver.Version;

class GameVersion
{
	public static var get(get, never):Version;

	static function get_get():Version
	{
		return Version.stringToVersion('1.0.0');
	}
}
