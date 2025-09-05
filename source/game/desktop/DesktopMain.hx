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
		haxen_changeState('idle-' + haxen_random_dir());
		haxen.screenCenter();

		super.create();
	}

	public function haxen_idle()
		haxen_changeState('idle-' + haxen_random_dir());

	public function haxen_random_dir()
	{
		return ((FlxG.random.bool(50)) ? 'left' : 'right');
	}

	public function haxen_changeState(newState:String)
		haxen.loadGraphic(Paths.getImagePath('desktop/haxen/' + newState));

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
