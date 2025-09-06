package game.desktop;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

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
	public var haxenStartingYPosition = 0.0;

	public var option_play:FlxSprite;
	public var option_options:FlxSprite;

	public var scanlineLayer:FlxTypedGroup<FlxSprite>;

	override public function create()
	{
		haxen = new FlxSprite();
		add(haxen);
		haxen_changeState('idle-' + haxen_random_dir());
		haxen.scale.set(0.5, 0.5);
		haxen.updateHitbox();
		haxen.screenCenter();
		haxen.y = FlxG.height - haxen.height * 0.75;
		haxenStartingYPosition = haxen.y;

		option_play = new FlxSprite();
		add(option_play);
		option_play.loadGraphic(Paths.getImagePath('desktop/options/play'));
		option_play.scale.set(0.5, 0.5);
		option_play.updateHitbox();

		option_play.screenCenter();
		option_play.x = 32;
		option_play.y -= 64;

		option_options = new FlxSprite();
		add(option_options);
		option_options.loadGraphic(Paths.getImagePath('desktop/options/options'));
		option_options.scale.set(0.5, 0.5);
		option_options.updateHitbox();

		option_options.screenCenter();
		option_options.x = FlxG.width - (option_options.width + 32);
		option_options.y -= 64;

		scanlineLayer = new FlxTypedGroup<FlxSprite>();

		super.create();

		add(scanlineLayer);
	}

	public function haxen_idle()
		haxen_changeState('idle-' + haxen_random_dir());

	public function haxen_random_dir()
	{
		return ((FlxG.random.bool(50)) ? 'left' : 'right');
	}

	public function haxen_changeState(newState:String)
		haxen.loadGraphic(Paths.getImagePath('desktop/haxen/' + newState));
}
