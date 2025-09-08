package game.desktop.play;

import crowplexus.iris.Iris;
import game.desktop.play.LevelData.AssetFolders;
import haxe.Json;
import haxe.xml.Access;

class LevelModule
{
	public var displayName:String;
	public var authors:Array<String>;
	public var unlocked:Bool;

	public var id:String;

	public var assetFolders:AssetFolders;

	public function new(dataFileid:String)
	{
		final JSONPath = Paths.getGamePath('levels/data/' + dataFileid + '.json');
		final XMLPath = Paths.getGamePath('levels/data/' + dataFileid + '.xml');

		try
		{
			final jsonData:LevelData = Json.parse(Paths.getText(JSONPath));
			final xmlData = new Access(Xml.parse(Paths.getText(XMLPath)));
			trace(xmlData);

			displayName = jsonData.displayName;
			authors = jsonData.authors;
			unlocked = jsonData.unlocked;
			id = (jsonData.id ?? dataFileid);
			assetFolders = jsonData.assetFolders;
		}
		catch (e)
		{
			#if !html5 Iris.error #else trace #end ('Cannot get level data file: ' + dataFileid + '\n\n' + e.message);
		}
	}

	public function getHaxenAsset(state:String)
	{
		return Paths.getImagePath('levels/assets/' + assetFolders.haxen + '/haxen/' + state);
	}

	public function getHandAsset(state:String)
	{
		return Paths.getImagePath('levels/assets/' + assetFolders.hand + '/hand/' + state);
	}

	public function getGeneralAsset(asset:String)
	{
		return Paths.getImagePath('levels/assets/' + assetFolders.general + '/' + asset);
	}
}
