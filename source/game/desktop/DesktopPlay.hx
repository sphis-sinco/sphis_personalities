package game.desktop;

import flixel.group.FlxGroup.FlxTypedGroup;
import game.desktop.play.LevelSpriteGroup;

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
	}

	public function reloadLevels()
	{
		for (level in levelsGrp.members)
		{
			level.destroy();
			levelsGrp.members.remove(level);
		}

		var i = 0;

		for (level in levels)
		{
			var levelGrp = new LevelSpriteGroup();
			levelGrp.ID = i;
			levelsGrp.add(levelGrp);

			levelGrp.levelID = level;

			levelGrp.lock.scale.set(.5, .5);
			levelGrp.loadLevelAsset();
			levelGrp.lock.screenCenter();
			levelGrp.lock.x += (levelGrp.lock.width * 1.25) * i;

			i++;
		}
	}
}
