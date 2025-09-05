package game.scripts.events;

class BaseEvent
{
	public var type:String = 'base';

	public function new() {}

	public function toString()
	{
		return 'Event(type:' + type + ')';
	}
}
