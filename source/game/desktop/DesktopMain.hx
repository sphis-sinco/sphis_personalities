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
		add(haxen);
		haxen_changeState('idle-' + ((FlxG.random.bool(50)) ? 'left' : 'right'));
		haxen.screenCenter();

		super.create();
	}

	public function haxen_changeState(newState:String)
	{
		haxen.loadGraphic(Paths.getImagePath('desktop/haxen/' + newState));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
