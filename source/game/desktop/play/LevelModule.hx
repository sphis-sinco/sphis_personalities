package game.desktop.play;

import crowplexus.iris.Iris;
import game.desktop.play.LevelData.AssetFolders;
import haxe.Json;

class LevelModule
{
	public var displayName:String;
	public var authors:Array<String>;
	public var unlocked:Bool;

	public var id:String;

	public var assetFolders:AssetFolders;

	public function new(dataFileid:String)
	{
		final path = Paths.getGamePath('levels/data/' + dataFileid + '.json');

		try
		{
			final jsonData:LevelData = Json.parse(Paths.getText(path));

			displayName = jsonData.displayName;
			authors = jsonData.authors;
			unlocked = jsonData.unlocked;
			id = (jsonData.id ?? dataFileid);
			assetFolders = jsonData.assetFolders;
		}
		catch (e)
		{
			Iris.error('Cannot get level data file: ' + dataFileid + '\n\n' + e.message);
		}
	}

	public function getHaxenAsset(state:String)
	{
		return Paths.getImagePath('levels/assets/' + assetFolders.haxen + '/haxen/' + state);
	}
}
