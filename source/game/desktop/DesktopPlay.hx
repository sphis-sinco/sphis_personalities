package game.desktop;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import game.levels.LevelData;
import game.levels.LevelModule;
import game.levels.LevelSpriteGroup;
#if sys
import sys.FileSystem;
#end

class DesktopPlay extends State
{
	public static var instance:DesktopPlay = null;

	override public function new()
	{
		super('desktop-play');

		if (instance != null)
		{
			instance = null;
		}
		instance = this;
	}

	public var levels:Array<String> = [];
	public var levelMetas:Array<LevelModule> = [];
	public var levelsGrp:FlxTypedGroup<LevelSpriteGroup>;
	public var levelsTextGrp:FlxTypedGroup<FlxText>;

	public var curSel:Int = 0;

	public var camFollow:FlxObject;

	public var scanlineLayer:FlxTypedGroup<FlxSprite>;

	override function create()
	{
		levelsGrp = new FlxTypedGroup<LevelSpriteGroup>();
		add(levelsGrp);
		levelsTextGrp = new FlxTypedGroup<FlxText>();
		add(levelsTextGrp);

		camFollow = new FlxObject(320, 240);
		add(camFollow);
		FlxG.camera.follow(camFollow, LOCKON, 0.1);

		scanlineLayer = new FlxTypedGroup<FlxSprite>();

		super.create();

		add(scanlineLayer);
	}

	public function reloadLevels(onComplete:(levelsGrp:FlxTypedGroup<LevelSpriteGroup>, levelsTextGrp:FlxTypedGroup<FlxText>) -> Void = null)
	{
		for (level in levelsGrp.members)
		{
			level.destroy();
			levelsGrp.members.remove(level);
		}
		for (level in levelsTextGrp.members)
		{
			level.destroy();
			levelsTextGrp.members.remove(level);
		}

		levelMetas = [];

		var i = 0;

		for (level in levels)
		{
			var levelGrp = new LevelSpriteGroup();
			levelGrp.ID = i;
			levelsGrp.add(levelGrp);

			levelGrp.scale = .5;
			levelGrp.levelID = level;

			levelGrp.loadLevelAsset();

			levelMetas.push(new LevelModule(level));
			levelGrp.locked = !(levelMetas[i].unlocked ?? true);

			var textField = new FlxText();
			textField.text = (levelMetas[i].displayName ?? 'Unknown');
			textField.size = 32;
			levelsTextGrp.add(textField);

			levelGrp.levelIcon.screenCenter(XY);
			levelGrp.levelIcon.x += ((levelGrp.levelIcon.width) * levelGrp.ID) * 1.5;
			textField.x = levelGrp.levelIcon.x;
			textField.y = levelGrp.levelIcon.y - textField.height;

			camFollow.x = levelGrp.levelIcon.getGraphicMidpoint().x * 2;

			i++;
		}

		if (onComplete != null)
			onComplete(levelsGrp, levelsTextGrp);
	}

	public static function initalizeLevelModules(dir:String):Array<String>
	{
		var lvls = [];

		#if !html5
		for (level in FileSystem.readDirectory(dir))
		{
			if (StringTools.endsWith(level, '.json') || StringTools.endsWith(level, '.xml'))
			{
				var trimmed = StringTools.replace(StringTools.replace(level, '.xml', ''), '.json', '');

				if (!lvls.contains(trimmed))
					lvls.push(trimmed);
			}
		}
		#end

		for (lvl in lvls)
			var module = new LevelModule(lvl);

		return lvls;
	}

	public function sysLoadLevels(dir:String):Bool
	{
		levels = [];

		#if sys
		for (level in FileSystem.readDirectory(dir))
		{
			if (StringTools.endsWith(level, '.json') || StringTools.endsWith(level, '.xml'))
			{
				var trimmed = StringTools.replace(StringTools.replace(level, '.xml', ''), '.json', '');

				if (!levels.contains(trimmed))
					levels.push(trimmed);
			}
		}
		return true;
		#else
		return false;
		#end
	}
}
