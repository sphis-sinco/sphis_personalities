import game.Mouse;
import game.MouseStates;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	if (Mouse.state != MouseStates.IDLE)
		Mouse.setMouseState(MouseStates.IDLE);
}
