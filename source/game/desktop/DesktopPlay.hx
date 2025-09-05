package game.desktop;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

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

	public var levelsGrp:FlxTypedGroup<FlxSprite>;

	override function create()
	{
		levelsGrp = new FlxTypedGroup<FlxSprite>();
		add(levelsGrp);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function reloadLevels() {}
}
