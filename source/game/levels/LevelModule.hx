package game.levels;

import crowplexus.iris.Iris;
import game.levels.LevelData.AssetFolders;
import haxe.Json;
import haxe.xml.Access;

class LevelModule
{
	public static var loadedModules:Map<String, LevelModule> = [];

	public var displayName:String;
	public var authors:Array<String>;
	public var unlocked:Bool;

	public var id:String;

	public var assetFolders:AssetFolders;

	public function new(levelID:String)
	{
		var loadOGlI = true;
		for (module in loadedModules)
		{
			if (module.id == levelID)
			{
				loadOGlI = false;
				trace('Another Level(' + Ansi.fg('', WHITE) + module.id + Ansi.reset('') + ') Module loaded, loading Module...');
			}
		}

		if (!loadedModules.exists(levelID) && loadOGlI)
		{
			loadModule(levelID);
		}
		else
		{
			trace('Level(' + Ansi.fg('', WHITE) + levelID + Ansi.reset('') + ') Module already loaded');
			var module = loadedModules.get(levelID);

			try
			{
				this.assetFolders = module.assetFolders;
				this.authors = module.authors;
				this.displayName = module.displayName;
				this.id = module.id;
				this.unlocked = module.unlocked;
			}
			catch (_)
			{
				loadModule(levelID);
			}
		}
	}

	public function loadModule(levelID:String)
	{
		trace('Initalizing new Level(' + Ansi.fg('', WHITE) + levelID + Ansi.reset('') + ') Module');

		var JSONPath = Paths.getGamePath('levels/data/' + levelID + '.json');
		var XMLPath = Paths.getGamePath('levels/data/' + levelID + '.xml');

		var jsonData:LevelData;
		var xmlData:Access;

		if (!Paths.pathExists(JSONPath))
		{
			#if !html5 Iris.warn #else trace #end ('Nonexistant level data file (JSON): ' + levelID);
		}
		if (!Paths.pathExists(XMLPath))
		{
			#if !html5 Iris.warn #else trace #end ('Nonexistant level data file (XML): ' + levelID);
		}

		assetFolders = {
			haxen: 'general',
			hand: 'general',
			general: 'one'
		};

		try
		{
			xmlData = new Access(Xml.parse(Paths.getText(XMLPath)).firstElement());
			parseXML(xmlData, levelID);
		}
		catch (e)
		{
			#if !html5 Iris.warn #else trace #end ('Cannot get level data file (XML): ' + levelID + '\n\n' + e.message);

			try
			{
				jsonData = Json.parse(Paths.getText(JSONPath));
				parseJSON(jsonData, levelID);
			}
			catch (e)
			{
				#if !html5 Iris.error #else trace #end ('Cannot get level data file (JSON): ' + levelID + '\n\n' + e.message);
			}
		}

		loadedModules.set(levelID, this);
	}

	public function parseJSON(data:LevelData, levelID:String)
	{
		trace('Level(' + Ansi.fg('', WHITE) + levelID + Ansi.reset('') + ') JSON being parsed');
		displayName = data.displayName;
		authors = data.authors;
		unlocked = data.unlocked;
		id = (data.id ?? levelID);
		assetFolders = data.assetFolders;
	}

	public function parseXML(data:Access, levelID:String)
	{
		for (element in data.elements)
		{
			try
			{
				trace('Level(' + Ansi.fg('', WHITE) + levelID + Ansi.reset('') + ') XML Element(' + element.name + ') being parsed');

				if (element.name.toLowerCase() == 'displayname')
				{
					displayName = element.att.value;
				}
				if (element.name.toLowerCase() == 'authors')
				{
					authors = [];
					for (author in element.elements)
					{
						authors.push(author.att.value);
					}
				}
				if (element.name.toLowerCase() == 'unlocked')
				{
					unlocked = (element.att.value.toLowerCase() == 'true' || element.att.value.toLowerCase() == '1');
				}
				if (element.name.toLowerCase() == 'assetfolders')
				{
					try
					{
						assetFolders.haxen = 'general';
						assetFolders.hand = 'general';
						assetFolders.general = 'one';

						for (assetFolder in element.elements)
						{
							switch (assetFolder.name)
							{
								case 'haxen':
									assetFolders.haxen = assetFolder.att.value;
								case 'hand':
									assetFolders.hand = assetFolder.att.value;
								case 'general':
									assetFolders.general = assetFolder.att.value;
							}
						}
					}
					catch (e)
					{
						trace('assetFolders XML failed: ' + e.message);
					}
				}
			}
			catch (e)
			{
				trace(element.name + ' did smth: ' + e.message);
			}
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
