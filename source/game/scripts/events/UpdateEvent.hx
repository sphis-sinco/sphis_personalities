package game.scripts.events;

class UpdateEvent extends BaseStateEvent
{
	public var elapsed:Float;

	override public function new(state:String, elapsed:Float)
	{
		super(state);

		this.elapsed = elapsed;

		type = 'update';
	}

	override function toString():String
	{
		return StringTools.replace(super.toString(), ')', ', ') + 'elapsed: ' + elapsed + ')';
	}
}
