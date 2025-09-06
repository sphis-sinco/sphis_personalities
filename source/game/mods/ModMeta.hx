package game.mods;

typedef ModMeta =
{
	var name:String;
	var version:Dynamic;

	var credits:Array<
		{
			var name:String;
			var role:String;
		}>;

	var ?priority:Int;
}
