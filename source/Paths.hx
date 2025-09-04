package;

class Paths
{
	public static function getGamePath(path:String)
	{
		var retpath = '${(StringTools.startsWith(path, 'game/') ? '' : 'game/')}$path';
		return retpath;
	}
}