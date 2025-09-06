package game;

class BlankState extends State
{
	public static var instance:BlankState = null;

	override public function new(state:String)
	{
		super(state);
		trace('Initalized Blank State with state: ' + state);

		if (instance != null)
			instance = null;
		instance = this;
	}
}
