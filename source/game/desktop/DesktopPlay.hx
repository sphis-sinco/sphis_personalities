package game.desktop;

import flixel.group.FlxGroup.FlxTypedGroup;
import game.desktop.play.LevelData;
import game.desktop.play.LevelSpriteGroup;
import haxe.Json;

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
	public var levelMetas:Array<LevelData> = [];
	public var levelsGrp:FlxTypedGroup<LevelSpriteGroup>;

	override function create()
	{
		levelsGrp = new FlxTypedGroup<LevelSpriteGroup>();
		add(levelsGrp);

		Mouse.setMouseState(MouseStates.BLANK);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (levelGrp in levelsGrp.members)
		{
			levelGrp.levelIcon.screenCenter();
			levelGrp.levelIcon.x += (levelGrp.levelIcon.width * 1.25) * levelGrp.ID;

			levelGrp.update(elapsed);
		}
	}

	public function reloadLevels()
	{
		for (level in levelsGrp.members)
		{
			level.destroy();
			levelsGrp.members.remove(level);
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

			levelMetas.push(Json.parse(Paths.getText(Paths.getGamePath('levels/data/' + level + '.json'))));
			levelGrp.locked = !levelMetas[i].unlocked;

			i++;
		}
	}
}
