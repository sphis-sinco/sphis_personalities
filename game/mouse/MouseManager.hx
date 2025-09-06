import game.Mouse;
import game.MouseStates;
import game.desktop.DesktopMain;
import game.scripts.events.UpdateEvent;

function onUpdate(event:UpdateEvent)
{
	Mouse.setMouseState(MouseStates.IDLE);

	if (event.state == 'desktop-main' && DesktopMain.instance.haxen.y == DesktopMain.instance.haxenStartingYPosition)
	{
		if (Mouse.overlaps(DesktopMain.instance.option_play))
			Mouse.setMouseState(MouseStates.CAN_SELECT);
		if (Mouse.overlaps(DesktopMain.instance.haxen))
			Mouse.setMouseState(MouseStates.CAN_SELECT);

		if (Mouse.overlaps(DesktopMain.instance.option_options))
			Mouse.setMouseState(MouseStates.CANT_SELECT);
	}
	if (event.state == 'desktop-play')
	{
		Mouse.setMouseState(MouseStates.BLANK);
	}

	if (Mouse.pressed && Mouse.state == MouseStates.CAN_SELECT)
	{
		Mouse.setMouseState(MouseStates.SELECTED);
	}
}
