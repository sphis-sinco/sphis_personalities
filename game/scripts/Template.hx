import game.scripts.events.AddedEvent;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;

function onAdded(event:AddedEvent)
{
	trace(event.toString());
}

function onCreate(event:CreateEvent)
{
	trace(event.toString());
}

function onUpdate(event:UpdateEvent)
{
	trace(event.toString());
}
