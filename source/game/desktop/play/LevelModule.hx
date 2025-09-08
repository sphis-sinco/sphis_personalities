package game.desktop.play;

import crowplexus.iris.Iris;
import game.desktop.play.LevelData.AssetFolders;
import haxe.Json;
import haxe.xml.Access;

class LevelModule
{
	public var displayName:String;
	public var authors:Array<String>;
	public var unlocked:Null<Bool>;

	public var id:String;

	public var assetFolders:AssetFolders;

	public function new(dataFileid:String)
	{
		final path = Paths.getGamePath('levels/data/' + dataFileid + '.xml');

		authors = [];
		assetFolders.haxen = 'general';
		assetFolders.hand = 'general';
		assetFolders.general = 'one';

		displayName = null;
		unlocked = null;
		id = dataFileid;

		trace(path);

		try
		{
			var xmlData = new Access(Xml.parse(Paths.getText(path)).firstElement());
			trace(xmlData.innerHTML);

			for (node in xmlData.elements)
			{
				trace(node.innerHTML);
			}

			/*
				displayName = xmlData.elements.displayName.innerData;
				unlocked = (xmlData.elements.unlocked.att.value.toLowerCase() == 'true'
					|| xmlData.elements.unlocked.att.value.toLowerCase() == '1');
				id = (xmlData.att.id ?? dataFileid); */
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
