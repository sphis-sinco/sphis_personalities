package game.desktop.play;

typedef LevelData =
{
	var displayName:String;
	var authors:Array<String>;
	var unlocked:Bool;

	var assetFolders:AssetFolders;

	var ?id:String;
}

typedef AssetFolders =
{
	var haxen:String;
}
