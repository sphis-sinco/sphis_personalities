package game.scripts.events;

class BaseStateEvent extends BaseEvent
{
	public var state:String = 'unknown-state';

	override public function new(state:String)
	{
		super();
		this.state = state;
	}

	override public function toString()
	{
		return StringTools.replace(super.toString(), ')', ', ') + 'state: ' + state + ')';
	}
}
