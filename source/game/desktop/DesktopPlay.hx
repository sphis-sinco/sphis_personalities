package game.desktop;

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

	public var levels:Array<String> = ['level1', 'level2'];

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
