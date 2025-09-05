package game.desktop;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import game.desktop.play.LevelSprite;

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

	public var levelsGrp:FlxTypedGroup<LevelSprite>;

	override function create()
	{
		levelsGrp = new FlxTypedGroup<LevelSprite>();
		add(levelsGrp);

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
			var levelSprite = new LevelSprite(level);
			levelSprite.ID = i;
			levelsGrp.add(levelSprite);

			i++;
		}
	}
}
