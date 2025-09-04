package game.desktop;

import flixel.FlxSprite;

class DesktopMain extends State
{
	public static var instance:DesktopMain = null;

	override public function new()
	{
		super('desktop-main');

		if (instance != null)
		{
			instance = null;
		}
		instance = this;
	}

	public var haxen:FlxSprite;

	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
