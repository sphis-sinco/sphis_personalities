package game.scripts.events;

class AddedEvent extends BaseEvent
{
	public var name:String;

	override public function new(name:String)
	{
		super();

		type = 'added';
		this.name = name;
	}

	override function toString():String
	{
		return StringTools.replace(super.toString(), ')', ', ') + 'name: ' + name + ')';
	}
}
