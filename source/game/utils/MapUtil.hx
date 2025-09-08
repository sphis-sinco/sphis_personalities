package game.utils;

class MapUtil
{
	public static function keysArray(map:Map<Dynamic, Dynamic>):Array<Dynamic>
	{
		var array = [];
		for (key => value in map)
		{
			array.push(key);
		}
		return array;
	}
}
