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
		final path = Paths.getGamePath('levels/data/' + dataFileid + '.json');

		try
		{
			var xmlData = new Access(Xml.parse(Paths.getText(path)).firstElement());

			authors = [];
			assetFolders.haxen = 'general';
			assetFolders.hand = 'general';
			assetFolders.general = 'one';

			displayName = null;
			unlocked = null;
			id = dataFileid;

			if (!xmlData.hasNode.displayName)
			{
				trace('Missing XML Node: displayName');
				return;
			}
			if (!xmlData.hasNode.authors)
			{
				trace('Missing XML Node: authors');
			}
			else {}
			if (!xmlData.hasNode.unlocked)
			{
				trace('Missing XML Node: unlocked');
				return;
			}
			if (!xmlData.hasNode.id)
			{
				trace('Missing XML Node: id');
			}
			if (!xmlData.hasNode.assetFolders)
			{
				trace('Missing XML Node: assetFolders');
				return;
			}
			else
			{
				var assetFoldersNode = xmlData.node.assetFolders;

				if (!assetFoldersNode.hasNode.haxen)
				{
					trace('Missing XML "assetFolders" Node: haxen');
					return;
				}
				if (!assetFoldersNode.hasNode.hand)
				{
					trace('Missing XML "assetFolders" Node: hand');
					return;
				}
				if (!assetFoldersNode.hasNode.general)
				{
					trace('Missing XML "assetFolders" Node: general');
					return;
				}
			}

			displayName = xmlData.node.displayName.innerData;
			unlocked = (xmlData.node.unlocked.att.value.toLowerCase() == 'true' || xmlData.node.unlocked.att.value.toLowerCase() == '1');
			id = (xmlData.att.id ?? dataFileid);
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
