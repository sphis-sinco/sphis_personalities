package;

class Paths
{
	public static function getGamePath(path:String)
	{
		var retpath = (StringTools.startsWith(path, 'game/') ? '' : 'game/') + path;
		return retpath;
	}

	public static function getImagePath(path:String, ?game:Bool)
	{
		return (game ? getGamePath(path + '.png') : path + '.png');
	}
}
