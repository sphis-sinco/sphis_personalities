package game.desktop;

import flixel.FlxG;
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
		haxen = new FlxSprite();
		haxen.loadGraphic(Paths.getImagePath('desktop/haxen/idle-' + ((FlxG.random.bool(50)) ? 'left' : 'right')));
		add(haxen);
		haxen.screenCenter();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
